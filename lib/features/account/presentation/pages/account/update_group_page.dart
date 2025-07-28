import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:prism/core/util/widgets/app_button.dart';
import 'package:prism/core/util/widgets/custom_text_form_field.dart';
import 'package:prism/features/account/domain/enitities/account/main/group_entity.dart';
import 'package:prism/features/account/presentation/bloc/account/group_bloc/group_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UpdateGroupPage extends StatefulWidget {
  final GroupEntity? group;
  final int? groupId;
  const UpdateGroupPage({super.key, this.group, this.groupId});

  @override
  UpdateGroupPageState createState() => UpdateGroupPageState();
}

class UpdateGroupPageState extends State<UpdateGroupPage> {
  File? _selectedMedia;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _nameFieldKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _bioFieldKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  String _privacy = 'public';
  GroupEntity? _fetchedGroup;

  @override
  void initState() {
    super.initState();
    if (widget.group != null) {
      _nameController.text = widget.group!.name;
      _bioController.text = widget.group!.bio ?? '';
      _privacy = widget.group!.privacy;
      _fetchedGroup = widget.group;
    } else if (widget.groupId != null) {
      context.read<GroupBloc>().add(GetGroupEvent(groupId: widget.groupId!));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final cameraStatus = await Permission.camera.request();
    if (cameraStatus.isPermanentlyDenied) {
      openAppSettings();
      return;
    }
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null && mounted) {
      setState(() {
        _selectedMedia = File(pickedFile.path);
      });
    } else if (!cameraStatus.isGranted && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.cameraAccessDenied),
        ),
      );
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() == true) {
      context.read<GroupBloc>().add(
        UpdateGroupEvent(
          groupId: _fetchedGroup?.id ?? widget.groupId!,
          name: _nameController.text.trim(),
          bio: _bioController.text.trim(),
          privacy: _privacy,
          avatar: _selectedMedia,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.updateGroup)),
      body: BlocListener<GroupBloc, GroupState>(
        listener: (context, state) {
          if (state is GroupUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context)!.groupUpdatedSuccessfully,
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop(true);
          } else if (state is GroupUpdateFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is GroupLoaded && widget.group == null) {
            setState(() {
              _fetchedGroup = state.group;
              _nameController.text = state.group.name;
              _bioController.text = state.group.bio ?? '';
              _privacy = state.group.privacy;
            });
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: AspectRatio(
                        aspectRatio: 16 / 7,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimary.withAlpha(50),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          child:
                              _selectedMedia != null
                                  ? ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                    child: Image.file(
                                      _selectedMedia!,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                  : (_fetchedGroup?.avatar != null ||
                                      widget.group?.avatar != null)
                                  ? ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                    child: Image.network(
                                      _fetchedGroup?.avatar ??
                                          widget.group!.avatar!,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                  : Icon(
                                    Icons.add_a_photo,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    size: 50,
                                  ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    formkey: _nameFieldKey,
                    errorMessage:
                        AppLocalizations.of(context)!.pleaseEnterGroupName,
                    obsecure: false,
                    textEditingController: _nameController,
                    hintText: AppLocalizations.of(context)!.groupName,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(
                          context,
                        )!.pleaseEnterGroupName;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    formkey: _bioFieldKey,
                    errorMessage: AppLocalizations.of(context)!.addExtraDetails,
                    obsecure: false,
                    textEditingController: _bioController,
                    hintText: AppLocalizations.of(context)!.groupBio,
                    maxLines: 3,
                    validator: (value) => null,
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _privacy,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.privacy,
                      border: const OutlineInputBorder(),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'public',
                        child: Text(AppLocalizations.of(context)!.public),
                      ),
                      DropdownMenuItem(
                        value: 'private',
                        child: Text(AppLocalizations.of(context)!.private),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null && mounted) {
                        setState(() {
                          _privacy = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 30),
                  BlocBuilder<GroupBloc, GroupState>(
                    builder: (context, state) {
                      return AppButton(
                        onPressed: state is GroupLoading ? () {} : _submit,
                        child:
                            state is GroupLoading
                                ? const CircularProgressIndicator()
                                : Text(
                                  AppLocalizations.of(context)!.updateGroup,
                                ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
