import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/features/account/domain/enitities/account/highlight/highlight_entity.dart';
import 'package:prism/features/account/presentation/bloc/account/highlight_bloc/highlight_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:prism/features/account/presentation/widgets/highlight_widget.dart';

class SelectHighlightPage extends StatefulWidget {
  final int statusId;
  const SelectHighlightPage({super.key, required this.statusId});

  @override
  State<SelectHighlightPage> createState() => _SelectHighlightPageState();
}

class _SelectHighlightPageState extends State<SelectHighlightPage> {
  List<HighlightEntity> _highlights = [];
  List<HighlightEntity> _filteredHighlights = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeBloc();
    _setupSearchListener();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _initializeBloc() {
    context.read<HighlightBloc>().add(GetHighlights());
  }

  void _setupSearchListener() {
    _searchController.addListener(_filterHighlights);
  }

  void _filterHighlights() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredHighlights =
          _highlights
              .where((h) => h.text?.toLowerCase().contains(query) ?? false)
              .toList();
    });
  }

  void _handleBlocState(
    BuildContext context,
    HighlightState state,
    AppLocalizations localizations,
  ) {
    if (state is HighlightsLoaded) {
      _updateHighlights(state.highlights);
    } else if (state is HighlightAddedTo) {
      _showSuccessSnackBar(context, localizations);
      _navigateBack(context);
    } else if (state is HighlightFailure) {
      _showErrorSnackBar(context, localizations, state.message);
    }
  }

  void _updateHighlights(List<HighlightEntity> highlights) {
    setState(() {
      _highlights = highlights;
      _filteredHighlights = highlights;
    });
  }

  void _showSuccessSnackBar(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(localizations.statusAddedToHighlight)),
    );
  }

  void _showErrorSnackBar(
    BuildContext context,
    AppLocalizations localizations,
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${localizations.failedToAddToHighlight}: $message'),
      ),
    );
  }

  void _navigateBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  Widget _buildSearchField(AppLocalizations localizations) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          labelText: localizations.search,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildEmptyState(AppLocalizations localizations) {
    return Center(child: Text(localizations.noHighlightsFound));
  }

  Widget _buildHighlightGrid(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 0.6,
      ),
      itemCount: _filteredHighlights.length,
      itemBuilder: (context, index) => _buildHighlightItem(context, index),
    );
  }

  Widget _buildHighlightItem(BuildContext context, int index) {
    final highlight = _filteredHighlights[index];
    return GestureDetector(
      onTap: () => _addToHighlight(context, highlight.id),
      child: HighlightWidget(highlight: highlight),
    );
  }

  void _addToHighlight(BuildContext context, int highlightId) {
    context.read<HighlightBloc>().add(
      AddToHighlight(highlightId: highlightId, statusId: widget.statusId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(localizations.addToHighlight)),
      body: BlocConsumer<HighlightBloc, HighlightState>(
        listener:
            (context, state) => _handleBlocState(context, state, localizations),
        builder: (context, state) {
          if (state is HighlightLoading) {
            return _buildLoadingIndicator();
          }
          return Column(
            children: [
              _buildSearchField(localizations),
              Expanded(
                child:
                    _filteredHighlights.isEmpty
                        ? _buildEmptyState(localizations)
                        : _buildHighlightGrid(context),
              ),
            ],
          );
        },
      ),
    );
  }
}
