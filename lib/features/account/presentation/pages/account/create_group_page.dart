import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prism/core/util/widgets/app_button.dart';
import 'package:prism/core/util/widgets/custom_text_form_field.dart';
import 'package:prism/features/account/presentation/bloc/account/group_bloc/group_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _nameFieldKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _bioFieldKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  String _privacy = 'public';
  File? _avatar;

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null && mounted) {
      setState(() {
        _avatar = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.createGroup)),
      body: BlocListener<GroupBloc, GroupState>(
        listener: (context, state) {
          if (state is GroupCreateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context)!.groupCreatedSuccessfully,
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          } else if (state is GroupCreateFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.red,
              ),
            );
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
                              _avatar != null
                                  ? ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                    child: Image.file(
                                      _avatar!,
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
                    hintText: AppLocalizations.of(context)!.bio,
                    maxLines: 3,
                    validator: (value) {
                      return null; // Bio is optional
                    },
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
                        onPressed:
                            state is GroupCreateLoading
                                ? () {}
                                : () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<GroupBloc>().add(
                                      CreateGroupEvent(
                                        name: _nameController.text,
                                        privacy: _privacy,
                                        bio: _bioController.text,
                                        avatar: _avatar,
                                      ),
                                    );
                                  }
                                },
                        child:
                            state is GroupCreateLoading
                                ? const CircularProgressIndicator()
                                : Text(
                                  AppLocalizations.of(context)!.createGroup,
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
