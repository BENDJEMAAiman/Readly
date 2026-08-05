import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_api/model/search_model.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_details_api/business%20logic/search_details_cubit.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_details_api/presentation/widgets/search_details_body.dart';

class SearchDetailsScreen extends StatefulWidget {
  final SearchModel basicInfo;

  const SearchDetailsScreen({
    super.key,
    required this.basicInfo,
  });

  @override
  State<SearchDetailsScreen> createState() =>
      _SearchDetailsScreenState();
}

class _SearchDetailsScreenState
    extends State<SearchDetailsScreen> {

  @override
  void initState() {
    super.initState();

    context
        .read<SearchDetailsCubit>()
        .getBookDetails(widget.basicInfo);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SearchDetailsBody(),
      ),
    );
  }
}