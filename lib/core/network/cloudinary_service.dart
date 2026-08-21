import 'dart:io';

import 'package:cloudinary/cloudinary.dart';

class CloudinaryService {
  final Cloudinary cloudinary;

  CloudinaryService()
    : cloudinary = Cloudinary.unsignedConfig(cloudName: 'k72ctjxe');

  Future<String> uploadBookCover({
    required File file,
    required String userId,
    required String bookId,
  }) async {
    try {
      final response = await cloudinary.unsignedUpload(
        file: file.path,
        uploadPreset: 'readly_book_covers',
        resourceType: CloudinaryResourceType.image,
        folder: 'readly/book-covers/$userId/$bookId',
        fileName: 'cover',
      );

      if (!response.isSuccessful || response.secureUrl == null) {
        throw Exception(response.error ?? 'Cloudinary upload failed.');
      }

      return response.secureUrl!;
    } catch (e) {
      throw Exception('Failed to upload book cover to Cloudinary: $e');
    }
  }

  Future<String> uploadProfilePicture({
    required File file,
    required String userId,
  }) async {
    try {
      final response = await cloudinary.unsignedUpload(
        file: file.path,
        uploadPreset: 'readly_book_covers',
        resourceType: CloudinaryResourceType.image,
        folder: 'readly/profile-pictures/$userId',
        fileName: 'profile',
      );

      if (!response.isSuccessful || response.secureUrl == null) {
        throw Exception(response.error ?? 'Profile picture upload failed.');
      }

      return response.secureUrl!;
    } catch (e) {
      throw Exception('Failed to upload profile picture to Cloudinary: $e');
    }
  }
}
