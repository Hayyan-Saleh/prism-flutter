import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prism/core/util/functions/functions.dart';
import 'package:prism/core/util/widgets/app_button.dart';
import 'package:prism/core/util/widgets/custom_cached_network_image.dart';
import 'package:prism/features/account/presentation/bloc/account/highlight_bloc/highlight_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UpdateHighlightCoverPage extends StatefulWidget {
  final int highlightId;
  final String? coverUrl;

  const UpdateHighlightCoverPage({
    super.key,
    required this.highlightId,
    this.coverUrl,
  });

  @override
  State<UpdateHighlightCoverPage> createState() =>
      _UpdateHighlightCoverPageState();
}

class _UpdateHighlightCoverPageState extends State<UpdateHighlightCoverPage> {
  File? _newCoverImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _newCoverImage = File(pickedFile.path);
      });
    }
  }

  void _submit() {
    if (_newCoverImage != null) {
      context.read<HighlightBloc>().add(
        UpdateHighlightCover(
          highlightId: widget.highlightId,
          cover: _newCoverImage!,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.pleaseSelectAnImage),
        ),
      );
    }
  }

  Widget _buildImagePicker() {
    final boxSize = getWidth(context);
    return GestureDetector(
      onTap: _pickImage,
      child: SizedBox(
        height: boxSize,
        width: boxSize,
        child:
            _newCoverImage != null
                ? Image.file(_newCoverImage!, fit: BoxFit.cover)
                : _buildImagePlaceholder(),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return widget.coverUrl != null
        ? CustomCachedNetworkImage(
          imageUrl: widget.coverUrl!,
          isRounded: false,
          radius: 0,
        )
        : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_a_photo, size: 50),
            const SizedBox(height: 8),
            Text(AppLocalizations.of(context)!.selectAnImageFromGallery),
          ],
        );
  }

  Widget _buildActionButton(HighlightState state) {
    return state is HighlightLoading
        ? const CircularProgressIndicator()
        : AppButton(
          onPressed: _submit,
          child: Text(AppLocalizations.of(context)!.save),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.updateCover)),
      body: BlocConsumer<HighlightBloc, HighlightState>(
        listener: (context, state) {
          if (state is HighlightCoverUpdated) {
            Navigator.pop(context, true);
          } else if (state is HighlightFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildImagePicker(),
              const SizedBox(height: 24),
              _buildActionButton(state),
            ],
          );
        },
      ),
    );
  }
}
