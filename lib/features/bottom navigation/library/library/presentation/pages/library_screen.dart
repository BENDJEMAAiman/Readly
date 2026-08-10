import 'package:flutter/material.dart';
import 'package:readly/features/auth/presentation/widgets%20/auth_header.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AuthHeader(title: "My library", subtitle: "Everything you're reading, in one place",),
        ],
      ),
    );
  }
}