// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:prism/core/util/widgets/app_button.dart';
import 'package:prism/core/util/sevices/app_routes.dart';
import 'package:prism/core/util/widgets/custom_cached_network_image.dart';
import 'package:prism/features/account/domain/enitities/account/status/status_entity.dart';
import 'package:prism/features/account/domain/enitities/account/highlight/highlight_entity.dart';
import 'package:prism/features/account/presentation/bloc/account/status_bloc/status_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/highlight_bloc/highlight_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:prism/features/account/presentation/pages/account/archived_status_viewer_page.dart';
import 'package:prism/core/util/functions/functions.dart';

class ArchivedStatusesPage extends StatefulWidget {
  final bool isAddToHighlightMode;
  const ArchivedStatusesPage({super.key, this.isAddToHighlightMode = false});

  @override
  State<ArchivedStatusesPage> createState() => _ArchivedStatusesPageState();
}

class _ArchivedStatusesPageState extends State<ArchivedStatusesPage> {
  final PageController _pageController = PageController();
  final Set<StatusEntity> _selectedStatuses = {};
  List<StatusEntity> _allStatuses = [];
  List<StatusEntity> _filteredStatuses = [];
  String _selectedFilter = '';
  File? _coverImage;
  final TextEditingController _textController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  double _uploadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    context.read<StatusBloc>().add(GetArchivedStatusesEvent());
  }

  @override
  void dispose() {
    _pageController.dispose();
    _textController.dispose();
    _coverImage = null;
    super.dispose();
  }

  void _filterStatuses(AppLocalizations localizations) {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    setState(() {
      if (_selectedFilter == localizations.today) {
        _filteredStatuses =
            _allStatuses
                .where(
                  (s) =>
                      s.createdAt.year == now.year &&
                      s.createdAt.month == now.month &&
                      s.createdAt.day == now.day,
                )
                .toList();
      } else if (_selectedFilter == localizations.yesterday) {
        _filteredStatuses =
            _allStatuses
                .where(
                  (s) =>
                      s.createdAt.year == yesterday.year &&
                      s.createdAt.month == yesterday.month &&
                      s.createdAt.day == yesterday.day,
                )
                .toList();
      } else if (_selectedFilter == localizations.thisWeek) {
        _filteredStatuses =
            _allStatuses
                .where((s) => now.difference(s.createdAt).inDays <= 7)
                .toList();
      } else if (_selectedFilter == localizations.thisMonth) {
        _filteredStatuses =
            _allStatuses
                .where(
                  (s) =>
                      s.createdAt.year == now.year &&
                      s.createdAt.month == now.month,
                )
                .toList();
      } else if (_selectedFilter == localizations.thisYear) {
        _filteredStatuses =
            _allStatuses.where((s) => s.createdAt.year == now.year).toList();
      } else {
        _filteredStatuses = List.from(_allStatuses);
      }
    });
  }

  Map<String, List<StatusEntity>> _groupStatuses(
    List<StatusEntity> statuses,
    AppLocalizations localizations,
  ) {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    final Map<String, List<StatusEntity>> grouped = {
      localizations.today: [],
      localizations.yesterday: [],
      localizations.thisWeek: [],
      localizations.thisMonth: [],
      localizations.thisYear: [],
      localizations.older: [],
    };

    for (var status in statuses) {
      if (status.createdAt.year == now.year &&
          status.createdAt.month == now.month &&
          status.createdAt.day == now.day) {
        grouped[localizations.today]!.add(status);
      } else if (status.createdAt.year == yesterday.year &&
          status.createdAt.month == yesterday.month &&
          status.createdAt.day == yesterday.day) {
        grouped[localizations.yesterday]!.add(status);
      } else if (now.difference(status.createdAt).inDays <= 7) {
        grouped[localizations.thisWeek]!.add(status);
      } else if (status.createdAt.year == now.year &&
          status.createdAt.month == now.month) {
        grouped[localizations.thisMonth]!.add(status);
      } else if (status.createdAt.year == now.year) {
        grouped[localizations.thisYear]!.add(status);
      } else {
        grouped[localizations.older]!.add(status);
      }
    }

    grouped.forEach((key, value) {
      value.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });

    grouped.removeWhere((key, value) => value.isEmpty);

    return grouped;
  }

  void _onStatusTap(StatusEntity status) async {
    if (widget.isAddToHighlightMode) {
      final initialIndex = _filteredStatuses.indexOf(status);
      if (initialIndex != -1) {
        final result = await Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (_) => ArchivedStatusViewerPage(
                  statuses: _filteredStatuses,
                  initialIndex: initialIndex,
                ),
          ),
        );

        if (result == true && mounted) {
          context.read<StatusBloc>().add(GetArchivedStatusesEvent());
        }
      }
    } else {
      final initialIndex = _filteredStatuses.indexOf(status);
      if (initialIndex != -1) {
        final result = await Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (_) => ArchivedStatusViewerPage(
                  statuses: _filteredStatuses,
                  initialIndex: initialIndex,
                ),
          ),
        );

        if (result == true && mounted) {
          context.read<StatusBloc>().add(GetArchivedStatusesEvent());
        }
      }
    }
  }

  void _onStatusLongPress(StatusEntity status) {
    if (widget.isAddToHighlightMode) {
      Navigator.of(context).pushNamed(
        AppRoutes.selectHighlight,
        arguments: {'statusId': status.id},
      );
    } else {
      setState(() {
        if (_selectedStatuses.contains(status)) {
          _selectedStatuses.remove(status);
        } else {
          _selectedStatuses.add(status);
        }
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null && mounted) {
      setState(() {
        _coverImage = File(pickedFile.path);
      });
    }
  }

  void _submitHighlight() {
    if (_formKey.currentState?.validate() ?? false) {
      _pageController.animateToPage(
        2,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      context.read<HighlightBloc>().add(
        CreateHighlight(
          statusIds: _selectedStatuses.map((s) => s.id).toList(),
          text: _textController.text.trim(),
          cover: _coverImage,
        ),
      );
      _simulateUpload();
    }
  }

  void _simulateUpload() async {
    for (int i = 0; i < 100; i += 10) {
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        setState(() {
          _uploadProgress = i / 100;
        });
      } else {
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    if (_selectedFilter.isEmpty) {
      _selectedFilter = localizations.thisWeek;
    }

    return BlocListener<HighlightBloc, HighlightState>(
      listener: (context, state) {
        if (state is HighlightCreated && mounted) {
          setState(() {
            _uploadProgress = 1.0;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations.highlightCreatedSuccessfully),
              backgroundColor: Colors.green,
            ),
          );
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              Navigator.pop(context, true);
            }
          });
        } else if (state is HighlightFailure) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${localizations.failedToCreateHighlight}: ${state.message}',
              ),
            ),
          );
          _pageController.animateToPage(
            1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.isAddToHighlightMode
                ? localizations.addToHighlight
                : localizations.archivedStatuses,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (_pageController.hasClients &&
                  (_pageController.page ?? 0) != 0) {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                Navigator.pop(context, false);
              }
            },
          ),
          actions: [
            if (_selectedStatuses.isNotEmpty &&
                !widget.isAddToHighlightMode &&
                _pageController.hasClients &&
                (_pageController.page ?? 0) == 0)
              IconButton(
                icon: const Icon(Icons.highlight_alt_rounded),
                onPressed: () {
                  _pageController.animateToPage(
                    1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
          ],
        ),
        body: BlocListener<StatusBloc, StatusState>(
          listener: (context, state) {
            if (state is ArchivedStatusLoaded && mounted) {
              setState(() {
                _allStatuses = state.statuses;
                _filterStatuses(localizations);
              });
            } else if (state is StatusDeleted && mounted) {
              context.read<StatusBloc>().add(GetArchivedStatusesEvent());
            }
          },
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildStatusSelectionPage(localizations),
              _buildHighlightDetailsPage(localizations),
              _buildUploadingPage(localizations),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusSelectionPage(AppLocalizations localizations) {
    return BlocBuilder<StatusBloc, StatusState>(
      builder: (context, state) {
        if (state is StatusLoading && _allStatuses.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_allStatuses.isEmpty) {
          return Center(child: Text(localizations.noArchivedStatuses));
        }

        final groupedStatuses = _groupStatuses(
          _filteredStatuses,
          localizations,
        );

        return Column(
          children: [
            _buildFilterChips(localizations),
            if (_filteredStatuses.isEmpty && _selectedFilter.isNotEmpty)
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      localizations.noStatusesMatchFilter,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: groupedStatuses.entries.length,
                  itemBuilder: (context, index) {
                    final entry = groupedStatuses.entries.elementAt(index);
                    final groupTitle = entry.key;
                    final statusesInGroup = entry.value;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                          child: Text(
                            groupTitle,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        ...statusesInGroup.map(
                          (status) =>
                              _buildStatusListItem(status, localizations),
                        ),
                      ],
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildStatusListItem(
    StatusEntity status,
    AppLocalizations localizations,
  ) {
    final isSelected =
        !widget.isAddToHighlightMode && _selectedStatuses.contains(status);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color:
              isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
          width: 2,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        onTap: () => _onStatusTap(status),
        onLongPress: () => _onStatusLongPress(status),
        leading: SizedBox(
          width: 60,
          height: 60,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child:
                status.media != null
                    ? CustomCachedNetworkImage(
                      imageUrl: status.media!.url,
                      isRounded: false,
                      radius: 10,
                    )
                    : Container(
                      color: Colors.grey.shade200,
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey.shade400,
                      ),
                    ),
          ),
        ),
        title: Text(
          status.text ?? localizations.noText,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            DateFormat.yMMMd().format(status.createdAt),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        selected: isSelected,
        selectedTileColor: Theme.of(context).colorScheme.primary.withAlpha(100),
        trailing:
            isSelected
                ? Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.secondary,
                )
                : null,
      ),
    );
  }

  Widget _buildFilterChips(AppLocalizations localizations) {
    final filters = [
      localizations.today,
      localizations.yesterday,
      localizations.thisWeek,
      localizations.thisMonth,
      localizations.thisYear,
    ];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 8.0,
        children:
            filters.map((filter) {
              return FilterChip(
                label: Text(filter),
                selected: _selectedFilter == filter,
                onSelected: (isSelected) {
                  setState(() {
                    if (isSelected) {
                      _selectedFilter = filter;
                    } else {
                      _selectedFilter = '';
                    }
                    _filterStatuses(localizations);
                  });
                },
              );
            }).toList(),
      ),
    );
  }

  Widget _buildHighlightDetailsPage(AppLocalizations localizations) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 200,
              ),
              child: Column(
                children: [
                  if (_selectedStatuses.isNotEmpty)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children:
                            _selectedStatuses.map((status) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: HighlightWidget(
                                  highlight: HighlightEntity(
                                    id: status.id,
                                    text: status.text,
                                    cover: status.media?.url,
                                    statusesCount: 1,
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        localizations.statusesSelectedForHighlight(0),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  const SizedBox(height: 24),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder:
                                  (context) => SafeArea(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading: const Icon(
                                            Icons.photo_library,
                                          ),
                                          title: Text(
                                            localizations.pickFromGallery,
                                          ),
                                          onTap: () {
                                            _pickImage(ImageSource.gallery);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(
                                            Icons.photo_camera,
                                          ),
                                          title: Text(localizations.takeAPhoto),
                                          onTap: () {
                                            _pickImage(ImageSource.camera);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                            );
                          },
                          child: Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child:
                                _coverImage != null
                                    ? Image.file(
                                      _coverImage!,
                                      fit: BoxFit.cover,
                                    )
                                    : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.add_a_photo, size: 50),
                                        const SizedBox(height: 8),
                                        Text(localizations.addCoverImage),
                                      ],
                                    ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _textController,
                          decoration: InputDecoration(
                            labelText: localizations.highlightTitle,
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return localizations.pleaseEnterAtitle;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AppButton(
          onPressed: _submitHighlight,
          child: Text(localizations.createHighlight),
        ),
      ],
    );
  }

  Widget _buildUploadingPage(AppLocalizations localizations) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(value: _uploadProgress),
          const SizedBox(height: 16),
          Text(
            localizations.uploading(_uploadProgress * 100),
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}

class HighlightWidget extends StatelessWidget {
  final HighlightEntity highlight;

  const HighlightWidget({super.key, required this.highlight});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildImageContainer(context),
          const SizedBox(height: 8),
          _buildTextLabel(),
        ],
      ),
    );
  }

  Widget _buildImageContainer(BuildContext context) {
    return SizedBox(
      height: 0.2 * getHeight(context),
      child: AspectRatio(
        aspectRatio: 3 / 5,
        child: Container(
          decoration: _getContainerDecoration(context),
          child:
              highlight.cover == null ? _buildTextChild() : _buildCachedImage(),
        ),
      ),
    );
  }

  BoxDecoration _getContainerDecoration(BuildContext context) {
    return BoxDecoration(
      border: Border.all(color: Theme.of(context).colorScheme.onPrimary),
      borderRadius: BorderRadius.circular(8),
    );
  }

  Widget _buildCachedImage() {
    return CachedNetworkImage(
      imageUrl: highlight.cover!,
      imageBuilder:
          (context, imageProvider) => ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image(image: imageProvider, fit: BoxFit.cover),
          ),
      placeholder:
          (context, url) => SizedBox(
            height: 100,
            width: 100,
            child: Center(child: CircularProgressIndicator(strokeWidth: 4)),
          ),
      errorWidget:
          (context, url, error) => SizedBox(
            height: 100,
            width: 100,
            child: Center(child: Icon(Icons.error)),
          ),
    );
  }

  Widget _buildTextLabel() {
    return SizedBox(
      width: 70,
      child: Text(
        highlight.text ?? '',
        style: const TextStyle(fontWeight: FontWeight.bold),
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTextChild() {
    return Center(
      child: Text(highlight.text ?? '', overflow: TextOverflow.ellipsis),
    );
  }
}
