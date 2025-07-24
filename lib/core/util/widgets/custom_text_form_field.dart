import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final GlobalKey<FormState> formkey;
  final TextEditingController textEditingController;
  final String hintText, errorMessage;
  final bool obsecure;
  final int maxLines;
  final String? Function(String?)? validator;
  const CustomTextFormField({
    required this.formkey,
    required this.obsecure,
    required this.textEditingController,
    required this.errorMessage,
    required this.hintText,
    required this.validator,
    this.maxLines = 1,
    super.key,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formkey,
      child: TextFormField(
        maxLines: widget.maxLines,
        cursorColor: Theme.of(context).colorScheme.secondary,
        obscureText: widget.obsecure ? _isObscured : false,
        autocorrect: false,
        controller: widget.textEditingController,
        validator:
            widget.validator ??
            (val) => val == null || val.isEmpty ? widget.errorMessage : null,
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        decoration: InputDecoration(
          suffixIcon:
              widget.obsecure
                  ? IconButton(
                    icon: Icon(
                      _isObscured ? Icons.visibility_off : Icons.visibility,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: () => setState(() => _isObscured = !_isObscured),
                  )
                  : null,
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
          hintText: widget.hintText,
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
