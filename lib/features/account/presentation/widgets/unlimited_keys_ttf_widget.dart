import 'package:flutter/material.dart';
import 'package:prism/core/util/widgets/app_button.dart';

class UnlimitedKeysTtfWidget extends StatefulWidget {
  final GlobalKey<FormState> formkey;
  final TextEditingController textEditingController;
  final String hintText;
  final bool allowDelete;
  final Widget child;
  final void Function() onDelete;
  final void Function() onAdd;
  const UnlimitedKeysTtfWidget({
    required this.formkey,
    required this.textEditingController,
    required this.hintText,
    required this.onDelete,
    required this.onAdd,
    required this.allowDelete,
    required this.child,
    super.key,
  });

  @override
  State<UnlimitedKeysTtfWidget> createState() => _UnlimitedKeysTtfWidgetState();
}

class _UnlimitedKeysTtfWidgetState extends State<UnlimitedKeysTtfWidget> {
  Widget _buildTextFormField() {
    return Form(
      key: widget.formkey,
      child: TextFormField(
        cursorColor: Theme.of(context).colorScheme.secondary,
        autocorrect: false,
        controller: widget.textEditingController,
        validator:
            (val) =>
                // TODO: LOCALIZE
                val == null || val.isEmpty ? "This Field is Required!" : null,
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        decoration: InputDecoration(
          errorStyle: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.red),
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
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
              color: Theme.of(context).colorScheme.onPrimary,
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
            bgColor: Color.fromARGB(250, 250, 0, 100),
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
            bgColor: Colors.purple,
            fgColor: Colors.white,
            onPressed: widget.onAdd,
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  Widget _buildKeyTFF() {
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

  @override
  Widget build(BuildContext context) {
    return Column(spacing: 10, children: [_buildKeyTFF(), widget.child]);
  }
}
