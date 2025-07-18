import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:prism/core/util/widgets/app_button.dart';
import 'package:prism/features/account/domain/enitities/account/status/status_entity.dart';
import 'package:prism/features/account/presentation/bloc/account/status_bloc/status_bloc.dart';
import 'package:prism/features/account/presentation/bloc/highlight_bloc/highlight_bloc.dart';
import 'package:prism/features/account/presentation/pages/account/single_status_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ArchivedStatusesPage extends StatefulWidget {
  const ArchivedStatusesPage({super.key});

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
    _coverImage = null; // Clear file reference
    super.dispose();
  }

  void _filterStatuses(AppLocalizations localizations) {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    setState(() {
      if (_selectedFilter == localizations.yesterday) {
        _filteredStatuses =
            _allStatuses.where((s) {
              return s.createdAt.year == yesterday.year &&
                  s.createdAt.month == yesterday.month &&
                  s.createdAt.day == yesterday.day;
            }).toList();
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
      localizations.yesterday: [],
      localizations.thisWeek: [],
      localizations.thisMonth: [],
      localizations.thisYear: [],
      localizations.older: [],
    };

    for (var status in statuses) {
      if (status.createdAt.year == yesterday.year &&
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
    if (_selectedStatuses.isNotEmpty) {
      _onStatusLongPress(status);
    } else {
      final result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => SingleStatusPage(status: status, isArchived: true),
        ),
      );

      if (result == true && mounted) {
        context.read<StatusBloc>().add(GetArchivedStatusesEvent());
      }
    }
  }

  void _onStatusLongPress(StatusEntity status) {
    setState(() {
      if (_selectedStatuses.contains(status)) {
        _selectedStatuses.remove(status);
      } else {
        _selectedStatuses.add(status);
      }
    });
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
            SnackBar(content: Text(localizations.highlightCreatedSuccessfully)),
          );
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              Navigator.of(context).pop();
            }
          });
        } else if (state is HighlightFailure) {
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
          title: Text(localizations.archivedStatuses),
          leading:
              _pageController.hasClients && (_pageController.page ?? 0) != 0
                  ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  )
                  : null,
          actions: [
            if (_selectedStatuses.isNotEmpty &&
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
        if (state is StatusLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ArchivedStatusLoaded) {
          if (state.statuses.isEmpty) {
            return Center(child: Text(localizations.noArchivedStatuses));
          }

          final groupedStatuses = _groupStatuses(
            _filteredStatuses,
            localizations,
          );
          final items = [];
          groupedStatuses.forEach((groupTitle, statusesInGroup) {
            items.add(groupTitle);
            items.addAll(statusesInGroup);
          });

          return Column(
            children: [
              _buildFilterChips(localizations),
              Expanded(
                child:
                    _filteredStatuses.isEmpty
                        ? Center(
                          child: Text(localizations.noStatusesMatchFilter),
                        )
                        : ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            if (item is String) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 16.0,
                                ),
                                child: Text(
                                  item,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              );
                            } else if (item is StatusEntity) {
                              final status = item;
                              final isSelected = _selectedStatuses.contains(
                                status,
                              );
                              return ListTile(
                                onTap: () => _onStatusTap(status),
                                onLongPress: () => _onStatusLongPress(status),
                                selected: isSelected,
                                selectedTileColor: Theme.of(
                                  context,
                                ).colorScheme.onPrimary.withAlpha(30),
                                leading:
                                    isSelected
                                        ? Icon(
                                          Icons.check_circle,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.secondary,
                                        )
                                        : const Icon(
                                          Icons.radio_button_unchecked,
                                        ),
                                title: Text(
                                  status.text ?? localizations.noText,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                                subtitle: Text(
                                  DateFormat.yMMMd().add_jm().format(
                                    status.createdAt,
                                  ),
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
              ),
            ],
          );
        } else if (state is StatusFailure) {
          return Center(child: Text(state.error));
        }
        return Center(child: Text(localizations.somethingWentWrong));
      },
    );
  }

  Widget _buildFilterChips(AppLocalizations localizations) {
    final filters = [
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
                  if (isSelected) {
                    setState(() {
                      _selectedFilter = filter;
                      _filterStatuses(localizations);
                    });
                  }
                },
              );
            }).toList(),
      ),
    );
  }

  Widget _buildHighlightDetailsPage(AppLocalizations localizations) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
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
                              leading: const Icon(Icons.photo_library),
                              title: Text(localizations.pickFromGallery),
                              onTap: () {
                                _pickImage(ImageSource.gallery);
                                Navigator.of(context).pop();
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.photo_camera),
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
                        ? Image.file(_coverImage!, fit: BoxFit.cover)
                        : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
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
            AppButton(
              onPressed: _submitHighlight,
              child: Text(localizations.createHighlight),
            ),
          ],
        ),
      ),
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
