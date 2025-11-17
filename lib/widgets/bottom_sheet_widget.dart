import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';

class CustomBottomSheet {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
    double? height,
  }) async {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: height,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Content
            Flexible(child: child),
          ],
        ),
      ),
    );
  }

  static Future<void> showImagePickerOptions(
    BuildContext context, {
    required VoidCallback onCamera,
    required VoidCallback onGallery,
  }) async {
    show(
      context: context,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Choose Image Source',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(
                Icons.camera_alt,
                color: AppConstants.primaryColor,
              ),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                onCamera();
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: AppConstants.primaryColor,
              ),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                onGallery();
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  static Future<void> showFilterOptions(
    BuildContext context, {
    required List<String> options,
    required Function(String) onSelected,
    String? selectedOption,
  }) async {
    show(
      context: context,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter Options',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...options.map((option) {
              bool isSelected = option == selectedOption;
              return ListTile(
                title: Text(option),
                trailing: isSelected
                    ? const Icon(Icons.check, color: AppConstants.primaryColor)
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  onSelected(option);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  static Future<void> showSortOptions(
    BuildContext context, {
    required List<Map<String, dynamic>> options,
    required Function(String) onSelected,
  }) async {
    show(
      context: context,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sort By',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...options.map((option) {
              return ListTile(
                leading: Icon(option['icon'], color: AppConstants.primaryColor),
                title: Text(option['label']),
                onTap: () {
                  Navigator.pop(context);
                  onSelected(option['value']);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
