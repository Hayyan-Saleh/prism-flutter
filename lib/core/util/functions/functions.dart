import 'package:flutter/material.dart';

double getHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double getWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

// FOR Account Feature ....
/*
Future<File?> getImage() async {
  File? file;
  final ImagePicker picker = ImagePicker();
  final XFile? image =
      await picker.pickImage(source: ImageSource.gallery); //pic from gallery

  if (image != null) {
    file = File(image.path);
  }
  return file;
}
 */
void showCustomAboutDialog(
  BuildContext context,
  String title,
  String content,
  List<Widget>? actions,
  bool barrierDissmisable,
) {
  showDialog(
    barrierDismissible: barrierDissmisable,
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          title,
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        content: Text(
          content,
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        actions:
            actions ??
            [
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                color: Theme.of(context).colorScheme.secondary,
                child: Text(
                  "ok",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
      );
    },
  );
}

void showSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}
