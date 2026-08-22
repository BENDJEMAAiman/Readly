import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/features/auth/business_logic/auth_cubit.dart';
import 'package:readly/features/auth/business_logic/auth_state.dart';
import 'package:readly/features/readly/home/presentation/widgets/currently_reading_header.dart';
import 'package:readly/features/readly/home/presentation/widgets/currently_reading_section.dart';
import 'package:readly/features/readly/home/presentation/widgets/home_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, authState) {
                  ImageProvider? profileImage;

                  if (authState is Authenticated) {
                    final photoUrl = authState.user.photoUrl;

                    if (photoUrl != null && photoUrl.isNotEmpty) {
                      profileImage = NetworkImage(photoUrl);
                    }
                  }

                  return HomeHeader(profileImage: profileImage);
                },
              ),

              SizedBox(height: 20.h),

              const CurrentlyReadingHeader(),
              SizedBox(height: 16.h),

              const CurrentlyReadingSection(),
            ],
          ),
        ),
      ),
    );
  }
}
