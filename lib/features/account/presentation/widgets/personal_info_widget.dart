import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PersonalInfoWidget extends StatefulWidget {
  final String userName;
  final Map<String, List<String>> personalInfo;
  final void Function() onToggleExpand;

  const PersonalInfoWidget({
    super.key,
    required this.userName,
    required this.personalInfo,
    required this.onToggleExpand,
  });

  @override
  State<PersonalInfoWidget> createState() => _PersonalInfoWidgetState();
}

class _PersonalInfoWidgetState extends State<PersonalInfoWidget> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.personalInfoTitle(widget.userName),
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            _buildExpandBtn(),
          ],
        ),
        if (expanded) ..._showPersonalInfo(),
      ],
    );
  }

  Widget _buildExpandBtn() {
    return IconButton(
      iconSize: 32,
      onPressed: () {
        expanded = !expanded;
        widget.onToggleExpand();
      },
      icon: Icon(
        expanded
            ? Icons.keyboard_arrow_up_outlined
            : Icons.keyboard_arrow_down_outlined,
      ),
    );
  }

  List<Widget> _showPersonalInfo() {
    final pi = widget.personalInfo;
    return List.generate(pi.keys.length, (index) {
      final title = pi.keys.elementAt(index);
      final details = pi[title] ?? []; // Safe access with empty list fallback
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.all(8),
              child: Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(details.length, (detailIndex) {
                return Container(
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  child: Text(
                    details[detailIndex],
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                );
              }),
            ),
          ],
        ),
      );
    });
  }
}
