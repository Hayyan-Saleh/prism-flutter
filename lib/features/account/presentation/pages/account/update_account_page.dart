import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/core/util/functions/functions.dart';
import 'package:prism/core/util/sevices/app_routes.dart';
import 'package:prism/core/util/widgets/app_button.dart';
import 'package:prism/core/util/widgets/custom_text_form_field.dart';
import 'package:prism/features/account/domain/enitities/account/main/personal_account_entity.dart';
import 'package:prism/features/account/presentation/bloc/account/personal_account_bloc/personal_account_bloc.dart';
import 'package:prism/features/account/presentation/widgets/account_name_tff.dart';
import 'package:prism/features/account/presentation/widgets/unlimited_details__ttf_widget.dart';
import 'package:prism/features/account/presentation/widgets/unlimited_keys_ttf_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UpdateAccountPage extends StatefulWidget {
  final PersonalAccountEntity? pAccount;
  const UpdateAccountPage({super.key, this.pAccount});

  @override
  State<UpdateAccountPage> createState() => _UpdateAccountPageState();
}

class _UpdateAccountPageState extends State<UpdateAccountPage> {
  File? selectedProfilePic;
  String? profilePicLink;

  bool isPrivate = false;
  bool initialized = false;
  bool editProfile = false;

  final GlobalKey<FormState> _bioFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _fullNameFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _accountNameFormKey = GlobalKey<FormState>();

  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _accountNameController = TextEditingController();

  final Map<GlobalKey<FormState>, List<GlobalKey<FormState>>>
  personalInfoFormKeys = {};
  final Map<TextEditingController, List<TextEditingController>>
  personalInfoTECs = {};

  @override
  void initState() {
    super.initState();

    final initialParentKey = GlobalKey<FormState>();
    final initialParentController = TextEditingController();
    final initialNestedKey = GlobalKey<FormState>();
    final initialNestedController = TextEditingController();

    personalInfoFormKeys[initialParentKey] = [initialNestedKey];
    personalInfoTECs[initialParentController] = [initialNestedController];
    if (widget.pAccount != null) {
      editProfile = true;
      _initializeData(widget.pAccount!);
    }
  }

  @override
  void dispose() {
    _bioController.dispose();
    _fullNameController.dispose();
    _accountNameController.dispose();

    for (var key in personalInfoTECs.keys) {
      final values = personalInfoTECs[key];
      if (values != null) {
        for (var value in values) {
          value.dispose();
        }
        key.dispose();
      }
    }

    super.dispose();
  }

  Future<void> _pickImage() async {
    final image = await getGalleryImage();
    if (image != null) {
      selectedProfilePic = image;
      setState(() {});
    }
  }

  bool _validatePersonalInfoFormKeys() {
    if (personalInfoTECs.keys.first.text.trim().isNotEmpty) {
      for (var entry in personalInfoFormKeys.entries) {
        final parentKey = entry.key;
        final nestedKeys = entry.value;

        if (parentKey.currentState?.validate() == false) {
          return false;
        }

        for (var nestedKey in nestedKeys) {
          if (nestedKey.currentState?.validate() == false) {
            return false;
          }
        }
      }
    }
    return true;
  }

  void _initializeData(PersonalAccountEntity pAccount) {
    // Initialize main account data
    _bioController.text = pAccount.bio;
    _fullNameController.text = pAccount.fullName;
    _accountNameController.text = pAccount.accountName;
    profilePicLink =
        pAccount.picUrl == ''
            ? null
            : pAccount.picUrl; // Initialize profile picture link
    isPrivate = pAccount.isPrivate; // Initialize privacy setting

    // Initialize personal info sections
    if (pAccount.personalInfos.isNotEmpty &&
        pAccount.personalInfos.keys.first.isNotEmpty) {
      personalInfoFormKeys.clear();
      personalInfoTECs.clear();

      pAccount.personalInfos.forEach((key, values) {
        final parentKey = GlobalKey<FormState>();
        final parentController = TextEditingController(text: key);

        final nestedKeys = <GlobalKey<FormState>>[];
        final nestedControllers = <TextEditingController>[];

        for (var value in values) {
          nestedKeys.add(GlobalKey<FormState>());
          nestedControllers.add(TextEditingController(text: value));
        }

        personalInfoFormKeys[parentKey] = nestedKeys;
        personalInfoTECs[parentController] = nestedControllers;
      });
    }

    setState(() {
      initialized = true;
    });
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Text(
        AppLocalizations.of(context)!.profileDetails,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      centerTitle: true,
    );
  }

  Widget _buildProfilePic() {
    return GestureDetector(
      onTap: _pickImage,
      child: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.secondary.withAlpha(50),
        radius: 66,
        child: ClipOval(
          child: Container(
            width: 126,
            height: 126,
            color: Theme.of(context).colorScheme.primary,
            child:
                selectedProfilePic != null
                    ? Image.file(selectedProfilePic!, fit: BoxFit.cover)
                    : profilePicLink != null
                    ? CachedNetworkImage(
                      imageUrl: profilePicLink!,
                      fit: BoxFit.cover,
                      placeholder:
                          (context, url) => const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                      errorWidget:
                          (context, url, error) => Icon(
                            Icons.error,
                            color: Theme.of(context).colorScheme.error,
                            size: 50,
                          ),
                    )
                    : Icon(
                      Icons.add_a_photo,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 50,
                    ),
          ),
        ),
      ),
    );
  }

  Widget _buildFirstSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProfilePic(),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPrivacyToggle(),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Form(
                  key: _bioFormKey,
                  child: TextFormField(
                    controller: _bioController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.bio,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.pink),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrivacyToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      spacing: 20,
      children: [
        Text(
          AppLocalizations.of(context)!.privacy,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        SizedBox(
          height: 32,
          child: Switch(
            trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((
              Set<WidgetState> states,
            ) {
              return Theme.of(context).colorScheme.secondary.withAlpha(150);
            }),
            value: isPrivate,
            onChanged: (value) => setState(() => isPrivate = value),
          ),
        ),
      ],
    );
  }

  Widget _buildTitle(String text) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSubTitle(String text) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  List<Widget> _buildAccountNameTextField() {
    return [
      _buildTitle(AppLocalizations.of(context)!.enterAccountName),
      SizedBox(height: 16),
      AccountNameTFF(
        formkey: _accountNameFormKey,
        textEditingController: _accountNameController,
        errorMessage: AppLocalizations.of(context)!.enterUniqueAccountName,
      ),
    ];
  }

  List<Widget> _buildTextFields(double height) {
    return [
      _buildTitle(AppLocalizations.of(context)!.enterFullName),
      SizedBox(height: 16),
      CustomTextFormField(
        formkey: _fullNameFormKey,
        textEditingController: _fullNameController,
        hintText: AppLocalizations.of(context)!.fullNameExample,
        errorMessage: AppLocalizations.of(context)!.enterYourFullName,
        obsecure: false,
        validator:
            (value) =>
                value!.isEmpty
                    ? AppLocalizations.of(context)!.fullNameRequired
                    : null,
      ),
      const SizedBox(height: 16),

      if (!editProfile) ..._buildAccountNameTextField(),
      SizedBox(height: 16),
      Row(
        children: [
          _buildTitle(AppLocalizations.of(context)!.addExtraDetails),
          _buildSubTitle(AppLocalizations.of(context)!.optional),
        ],
      ),
      SizedBox(height: 16),
      _buildPersonalInfo(height),
    ];
  }

  Widget _buildPersonalInfo(double height) {
    return ListView.separated(
      shrinkWrap: true,

      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder:
          (context, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 96, vertical: 16),
            child: Divider(thickness: 3),
          ),
      itemCount: personalInfoTECs.length,
      itemBuilder: (context, parentIndex) {
        final parentKey = personalInfoFormKeys.keys.elementAt(parentIndex);
        final parentController = personalInfoTECs.keys.elementAt(parentIndex);
        final nestedItems = personalInfoTECs[parentController] ?? [];

        return UnlimitedKeysTtfWidget(
          formkey: parentKey,
          textEditingController: parentController,
          hintText: AppLocalizations.of(context)!.title(parentIndex),
          onDelete: () {
            // Dispose all nested controllers first
            for (TextEditingController controller in nestedItems) {
              controller.dispose();
            }
            parentController.dispose();

            // Remove from maps
            personalInfoFormKeys.remove(parentKey);
            personalInfoTECs.remove(parentController);

            setState(() {});
          },
          onAdd: () {
            final newParentKey = GlobalKey<FormState>();
            final newParentController = TextEditingController();
            final newNestedKey = GlobalKey<FormState>();
            final newNestedController = TextEditingController();

            personalInfoFormKeys[newParentKey] = [newNestedKey];
            personalInfoTECs[newParentController] = [newNestedController];

            setState(() {});
          },
          allowDelete: parentIndex != 0,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: nestedItems.length,
            separatorBuilder: (context, index) => SizedBox(height: 8),
            itemBuilder: (context, nestedIndex) {
              return UnlimitedDetailsTTFWidget(
                formkey: personalInfoFormKeys[parentKey]![nestedIndex],
                textEditingController: nestedItems[nestedIndex],
                hintText: AppLocalizations.of(context)!.detail(nestedIndex),
                onDelete: () {
                  // Dispose the nested controller
                  nestedItems[nestedIndex].dispose();

                  // Remove from both maps
                  personalInfoFormKeys[parentKey]!.removeAt(nestedIndex);
                  personalInfoTECs[parentController]!.removeAt(nestedIndex);

                  setState(() {});
                },
                onAdd: () {
                  final newNestedKey = GlobalKey<FormState>();
                  final newNestedController = TextEditingController();

                  personalInfoFormKeys[parentKey]!.add(newNestedKey);
                  personalInfoTECs[parentController]!.add(newNestedController);

                  setState(() {});
                },
                allowDelete: nestedIndex != 0,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSaveBtn() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 50,
            child: BlocBuilder<PAccountBloc, PAccountState>(
              builder: (context, state) {
                final bool isLoading = state is LoadingPAccountState;
                return AppButton(
                  onPressed:
                      isLoading
                          ? () {}
                          : () {
                            final bool accountNameValidation =
                                editProfile == true
                                    ? true
                                    : _accountNameFormKey.currentState
                                            ?.validate() ==
                                        true;
                            if (_bioFormKey.currentState?.validate() == true &&
                                _fullNameFormKey.currentState?.validate() ==
                                    true &&
                                accountNameValidation &&
                                _validatePersonalInfoFormKeys()) {
                              final String bio = _bioController.text.trim();
                              final String fullName =
                                  _fullNameController.text.trim();
                              final String accountName =
                                  _accountNameController.text.trim();

                              if (personalInfoTECs.keys.first.text.trim() !=
                                  '') {
                                final Map<String, List<String>>
                                personalInfoString = personalInfoTECs.map((
                                  title,
                                  details,
                                ) {
                                  final String titleString = title.text.trim();
                                  final List<String> detailsString =
                                      details
                                          .map((detail) => detail.text.trim())
                                          .toList();
                                  return MapEntry(titleString, detailsString);
                                });
                                context.read<PAccountBloc>().add(
                                  UpdatePAccountEvent(
                                    personalAccount:
                                        PersonalAccountEntity.fromScratch(
                                          fullName: fullName,
                                          bio: bio,
                                          isPrivate: isPrivate,
                                          personalInfos: personalInfoString,
                                          accountName: accountName,
                                        ),
                                    profilePic: selectedProfilePic,
                                  ),
                                );
                              } else {
                                context.read<PAccountBloc>().add(
                                  UpdatePAccountEvent(
                                    personalAccount:
                                        PersonalAccountEntity.fromScratch(
                                          fullName: fullName,
                                          bio: bio,
                                          isPrivate: isPrivate,
                                          personalInfos: {},
                                          accountName: accountName,
                                        ),
                                    profilePic: selectedProfilePic,
                                  ),
                                );
                              }
                            }
                          },
                  child:
                      isLoading
                          ? SizedBox(
                            height: 32,
                            child: Center(
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          )
                          : Text(
                            AppLocalizations.of(context)!.saveProfile,
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _wrapWithAccountBloc({required Widget child}) {
    return BlocListener<PAccountBloc, PAccountState>(
      listener: (context, state) {
        if (state is DoneUpdatePAccountState) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.home,
            ModalRoute.withName(AppRoutes.myApp),
          );
        } else if (state is FailedPAccountState) {
          showCustomAboutDialog(
            context,
            AppLocalizations.of(context)!.error,
            state.failure.message,
            null,
            true,
          );
        }
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = getHeight(context);
    return _wrapWithAccountBloc(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: _buildAppBar(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

            children: [
              Expanded(
                child: ListView(
                  children: [
                    _buildFirstSection(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 96,
                        vertical: 16,
                      ),
                      child: Divider(thickness: 3),
                    ),
                    ..._buildTextFields(height),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 96),
                      child: Divider(thickness: 3),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 0.08 * height, child: _buildSaveBtn()),
            ],
          ),
        ),
      ),
    );
  }
}
