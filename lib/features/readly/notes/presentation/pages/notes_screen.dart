import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/features/readly/notes/business_logic/notes_cubit.dart';
import 'package:readly/features/readly/notes/business_logic/notes_state.dart';
import 'package:readly/features/readly/notes/presentation/widgets/notes_empty_state.dart';
import 'package:readly/features/readly/notes/presentation/widgets/notes_header.dart';
import 'package:readly/features/readly/notes/presentation/widgets/notes_list.dart';
import 'package:readly/features/readly/notes/presentation/widgets/notes_search_field.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({
    super.key,
  });

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController();

    context.read<NotesCubit>().fetchAllNotes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    // Search functionality will be implemented next.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 23.w,
            vertical: 16.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const NotesHeader(),

              SizedBox(height: 24.h),

              NotesSearchField(
                controller: _searchController,
                onChanged: _onSearchChanged,
              ),

              SizedBox(height: 24.h),

              Expanded(
                child: BlocBuilder<NotesCubit, NotesState>(
                  builder: (context, state) {
                    if (state is NotesLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (state is NotesError) {
                      return Center(
                        child: Text(
                          state.message,
                        ),
                      );
                    }

                    if (state is NotesLoaded) {
                      if (state.notes.isEmpty) {
                        return const NotesEmptyState();
                      }

                      return NotesList(
                        notes: state.notes,
                        books: state.books,
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}