import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorageService {
  final SupabaseClient supabase;

  SupabaseStorageService(this.supabase);

  static const String _bucketName = 'book-covers';

  Future<String> uploadBookCover({
    required File file,
    required String userId,
    required String bookId,
  }) async {
    try {
      final filePath = 'users/$userId/books/$bookId/cover.jpg';

      await supabase.storage.from(_bucketName).upload(
            filePath,
            file,
            fileOptions: const FileOptions(
              upsert: true,
            ),
          );

      return supabase.storage
          .from(_bucketName)
          .getPublicUrl(filePath);
    } catch (e) {
      throw Exception('Failed to upload book cover: $e');
    }
  }

  Future<void> deleteBookCover({
    required String userId,
    required String bookId,
  }) async {
    try {
      final filePath = 'users/$userId/books/$bookId/cover.jpg';

      await supabase.storage.from(_bucketName).remove([
        filePath,
      ]);
    } catch (e) {
      throw Exception('Failed to delete book cover: $e');
    }
  }
}