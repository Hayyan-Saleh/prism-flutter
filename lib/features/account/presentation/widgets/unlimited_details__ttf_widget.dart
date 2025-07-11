import 'package:flutter/material.dart';
import 'package:prism/core/util/widgets/app_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UnlimitedDetailsTTFWidget extends StatefulWidget {
  final GlobalKey<FormState> formkey;
  final TextEditingController textEditingController;
  final String hintText;
  final bool allowDelete;
  final void Function() onDelete;
  final void Function() onAdd;
  const UnlimitedDetailsTTFWidget({
    required this.formkey,
    required this.textEditingController,
    required this.hintText,
    required this.onDelete,
    required this.onAdd,
    required this.allowDelete,
    super.key,
  });

  @override
  State<UnlimitedDetailsTTFWidget> createState() =>
      _UnlimitedDetailsTTFWidgetState();
}

class _UnlimitedDetailsTTFWidgetState extends State<UnlimitedDetailsTTFWidget> {
  Widget _buildTextFormField() {
    return Form(
      key: widget.formkey,
      child: TextFormField(
        cursorColor: Theme.of(context).colorScheme.secondary,
        autocorrect: false,
        controller: widget.textEditingController,
        validator:
            (val) =>
                val == null || val.isEmpty ? AppLocalizations.of(context)!.fieldRequired : null,
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        decoration: InputDecoration(
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

  Widget _buildDeleter() {
    return Column(
      children: [
        Expanded(
          child: AppButton(
            bgColor: Colors.red,
            fgColor: Colors.white,
            onPressed: widget.onDelete,
            child: Icon(Icons.delete_outline_outlined),
          ),
        ),
      ],
    );
  }

  Widget _buildAdder() {
    return Column(
      children: [
        Expanded(
          child: AppButton(
            bgColor: Colors.cyan,
            fgColor: Colors.white,
            onPressed: widget.onAdd,
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        spacing: 8,
        children: [
          Expanded(child: _buildTextFormField()),
          widget.allowDelete ? _buildDeleter() : _buildAdder(),
        ],
      ),
    );
  }
}
