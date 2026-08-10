import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorageTest {
  static final SupabaseClient supabase = Supabase.instance.client;

  static Future<void> uploadTestFile(File file) async {
    const bucketName = 'book-covers';
    const filePath = 'test/test-cover.jpg';

    await supabase.storage
        .from(bucketName)
        .upload(
          filePath,
          file,
        );
  }
}