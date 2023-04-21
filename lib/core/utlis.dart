import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
}

Future<FilePickerResult?> pickImage() async {
  final image = await FilePicker.platform.pickFiles(
    type: FileType.image,
    allowCompression: true,
    dialogTitle: "Select Image",
    withData: true,
    lockParentWindow: true,
    onFileLoading: (p0) {
      const ActionChip(
        label: Text('Loading...'),
        backgroundColor: Colors.grey,
      );
    },
  );

  return image;
}

Future<FilePickerResult?> CaptureImage() async {
  final image = await FilePicker.platform.pickFiles(
    type: FileType.media,
    allowCompression: true,
    withData: true,
    lockParentWindow: true,
    onFileLoading: (p0) {
      const ActionChip(
        label: Text('Loading...'),
        // backgroundColor: Colors.grey,
      );
    },
  );

  return image;
}
