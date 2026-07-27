import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readly/core/dependency_injection.dart';
import 'package:readly/features/search_book_api/business_logic/search_cubit.dart';
import 'package:readly/features/search_book_api/presentation/search_screen.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "Baloo2",
      ),
      home: BlocProvider(
        create: (context) => SearchCubit(searchRepository),
        child: SearchScreen(),
      )
    );
  }
}
