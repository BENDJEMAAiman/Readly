import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/features/auth/business_logic/auth_cubit.dart';
import 'package:readly/features/auth/presentation/widgets%20/auth_header.dart';
import 'package:readly/features/auth/presentation/widgets%20/auth_scaffold.dart';
import 'package:readly/features/auth/presentation/widgets%20/auth_switch_text.dart';

class CheckEmailPassword extends StatefulWidget {
  final String email;

  const CheckEmailPassword({
    super.key,
    required this.email,
  });

  @override
  State<CheckEmailPassword> createState() => _CheckEmailPasswordState();
}

class _CheckEmailPasswordState extends State<CheckEmailPassword> {
  
  

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// Header
          AuthHeader(
            title: 'Check Your Email',
            subtitle: 'We sent a password reset link to\n${widget.email}',
          ),

          SizedBox(height: 20.h),

              /// Switch to signup
              AuthSwitchText(
                text: "if you didn't receive an email ",
                actionText: "Resend",
                onTap: () {
                  context.read<AuthCubit>().resetPassword(widget.email);
                },
              ),
      
          
    
        ],
      ),
    );
  }
}
