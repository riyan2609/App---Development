import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerService {
  static final ImagePicker _picker = ImagePicker();

  // Pick image from gallery
  static Future<File?> pickImageFromGallery() async {
    try {
      // Request permission
      var status = await Permission.photos.request();

      if (status.isGranted) {
        final XFile? image = await _picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1920,
          maxHeight: 1080,
          imageQuality: 85,
        );

        if (image != null) {
          return File(image.path);
        }
      }
      return null;
    } catch (e) {
      print('Error picking image from gallery: $e');
      return null;
    }
  }

  // Pick image from camera
  static Future<File?> pickImageFromCamera() async {
    try {
      // Request permission
      var status = await Permission.camera.request();

      if (status.isGranted) {
        final XFile? image = await _picker.pickImage(
          source: ImageSource.camera,
          maxWidth: 1920,
          maxHeight: 1080,
          imageQuality: 85,
        );

        if (image != null) {
          return File(image.path);
        }
      }
      return null;
    } catch (e) {
      print('Error picking image from camera: $e');
      return null;
    }
  }

  // Pick multiple images
  static Future<List<File>> pickMultipleImages() async {
    try {
      var status = await Permission.photos.request();

      if (status.isGranted) {
        final List<XFile> images = await _picker.pickMultiImage(
          maxWidth: 1920,
          maxHeight: 1080,
          imageQuality: 85,
        );

        return images.map((image) => File(image.path)).toList();
      }
      return [];
    } catch (e) {
      print('Error picking multiple images: $e');
      return [];
    }
  }

  // Show image picker options dialog
  static Future<File?> showImagePickerOptions() async {
    // This should be called from a widget to show dialog
    return null;
  }
}
