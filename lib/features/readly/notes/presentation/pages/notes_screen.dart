import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/features/readly/notes/presentation/widgets/notes_header.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {


  



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.buttonBlue,
        foregroundColor: AppColors.white,
        elevation: 0,
        shape: const CircleBorder(),
        child: Icon(Icons.add, size: 25.sp),
      ),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const NotesHeader(),
              SizedBox(height: 24.h),
              
            ],
          ),
        ),
      ),
    );
  }
}
