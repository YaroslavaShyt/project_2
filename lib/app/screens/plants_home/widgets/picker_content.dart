import 'package:flutter/material.dart';

class PickerContent extends StatelessWidget {
  final Function() onGalleryTap;
  final Function() onCameraTap;
  const PickerContent(
      {super.key, required this.onCameraTap, required this.onGalleryTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      child: Column(
        children: [
          ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('З галереї'),
              onTap: onGalleryTap),
          ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('З камери'),
              onTap: onCameraTap),
        ],
      ),
    );
  }
}
