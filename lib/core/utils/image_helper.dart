// image_helper.dart
import 'dart:io';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:image/image.dart' as img;
// import 'dart:typed_data';

class ImageHelper {
  /// Processes an image file by fixing rotation and optionally compressing it.
  /// Returns a new File with corrected orientation and compression applied.
  static Future<File> processImage(
    File imageFile, {
    bool fixRotation = true,
    bool compress = true,
    int quality = 85,
    int maxWidth = 1920,
    int maxHeight = 1920,
  }) async {
    try {
      File processedFile = imageFile;

      // Step 1: Fix rotation using EXIF data
      if (fixRotation) {
        processedFile = await FlutterExifRotation.rotateImage(
          path: imageFile.path,
        );
      }

      // Step 2: Compress and resize if needed
      if (compress) {
        final bytes = await processedFile.readAsBytes();
        img.Image? originalImage = img.decodeImage(bytes);

        if (originalImage != null) {
          img.Image processedImage = originalImage;

          // Resize if image is larger than max dimensions
          if (originalImage.width > maxWidth ||
              originalImage.height > maxHeight) {
            processedImage = img.copyResize(
              originalImage,
              width: originalImage.width > maxWidth ? maxWidth : null,
              height: originalImage.height > maxHeight ? maxHeight : null,
              interpolation: img.Interpolation.average,
            );
          }

          // Encode to JPEG with quality
          final compressedBytes = img.encodeJpg(
            processedImage,
            quality: quality,
          );

          // Create a new file with timestamp to avoid conflicts
          final directory = processedFile.parent;
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          final newFile = File('${directory.path}/processed_$timestamp.jpg');

          await newFile.writeAsBytes(compressedBytes);

          // Clean up the temporary rotated file if it's different from original
          if (processedFile.path != imageFile.path) {
            try {
              await processedFile.delete();
            } catch (e) {
              // Ignore delete errors
            }
          }

          return newFile;
        }
      }

      // If compression is disabled or failed, return the rotated file
      return processedFile;
    } catch (e) {
      print('Error processing image: $e');
      // Return original file as fallback
      return imageFile;
    }
  }

  /// Legacy method for backward compatibility - just calls processImage
  static Future<File> fixImageRotation(File imageFile) async {
    return await processImage(imageFile, fixRotation: true, compress: false);
  }

  /// Checks if a file is a valid, readable image
  static Future<bool> isValidImageFile(File file) async {
    try {
      if (!await file.exists()) return false;

      final bytes = await file.readAsBytes();
      if (bytes.isEmpty) return false;

      final image = img.decodeImage(bytes);
      return image != null;
    } catch (e) {
      print('Error validating image file: $e');
      return false;
    }
  }

  /// Get image dimensions without fully loading the image
  static Future<Map<String, int>?> getImageDimensions(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image != null) {
        return {'width': image.width, 'height': image.height};
      }
    } catch (e) {
      print('Error getting image dimensions: $e');
    }
    return null;
  }

  /// Compress image to specific file size (approximate)
  static Future<File> compressToSize(
    File imageFile, {
    int targetSizeKB = 500,
    int minQuality = 20,
  }) async {
    int quality = 90;
    File processedFile = imageFile;

    while (quality >= minQuality) {
      processedFile = await processImage(
        imageFile,
        compress: true,
        quality: quality,
      );

      final fileSizeKB = (await processedFile.length()) / 1024;
      if (fileSizeKB <= targetSizeKB) {
        break;
      }

      quality -= 10;
    }

    return processedFile;
  }
}
