import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/core/util/validators/account_name_validator.dart';
import 'package:prism/features/account/presentation/bloc/account/account_name_bloc/account_name_bloc.dart';

class AccountNameTFF extends StatefulWidget {
  final GlobalKey<FormState> formkey;
  final TextEditingController textEditingController;
  final String errorMessage;
  const AccountNameTFF({
    required this.formkey,
    required this.textEditingController,
    required this.errorMessage,
    super.key,
  });

  @override
  State<AccountNameTFF> createState() => _AccountNameTFFState();
}

class _AccountNameTFFState extends State<AccountNameTFF> {
  bool isAccountNameValid = false;

  Widget _buildSuffixBloc() {
    return BlocBuilder<AccountNameBloc, AccountNameState>(
      builder: (context, state) {
        switch (state) {
          case LoadingAccountNameState():
            return Container(
              padding: EdgeInsets.all(12),
              height: 10,
              width: 10,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.blue,
              ),
            );
          case AvailableAccountNameState():
            return Icon(Icons.done, size: 32, color: Colors.green);
          case UnavailableAccountNameState():
            return Icon(Icons.error_outline, color: Colors.red);
          default:
            return SizedBox();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formkey,
      child: TextFormField(
        cursorColor: Theme.of(context).colorScheme.secondary,
        autocorrect: false,
        controller: widget.textEditingController,
        validator: (val) {
          if (val == null || val.isEmpty) {
            return widget.errorMessage;
          } else if (!AccountNameValidator.isValid(val)) {
            // TODO: LOCALIZE
            return "This account name is NOT valid!";
          }
          return null;
        },
        onChanged: (accountName) {
          if (widget.formkey.currentState!.validate()) {
            if (accountName.isNotEmpty) {
              context.read<AccountNameBloc>().add(
                CheckAccountNameEvent(accountName: accountName),
              );
            }
          } else {
            context.read<AccountNameBloc>().add(ResetEvent());
          }
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        decoration: InputDecoration(
          suffixIcon: _buildSuffixBloc(),
          errorStyle: const TextStyle(color: Colors.red),
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary.withAlpha(150),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
              width: 2.5,
            ),
          ),
          hintText: 'john_doe123',
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary.withAlpha(200),
            ),
          ),
        ),
      ),
    );
  }
}
