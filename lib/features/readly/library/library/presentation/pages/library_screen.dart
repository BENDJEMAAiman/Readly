import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:readly/core/routing/routes.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/features/auth/business_logic/auth_cubit.dart';
import 'package:readly/features/auth/business_logic/auth_state.dart';
import 'package:readly/features/readly/library/library/business_logic/library_cubit.dart';
import 'package:readly/features/readly/library/library/business_logic/library_state.dart';
import 'package:readly/features/readly/library/library/model/library_book.dart';
import 'package:readly/features/readly/library/library/presentation/widgets/library_book_grid.dart';
import 'package:readly/features/readly/library/library/presentation/widgets/library_search_field.dart';
import 'package:readly/features/readly/library/library/presentation/widgets/library_header.dart';
import 'package:readly/features/readly/library/library/presentation/widgets/reading_status_filters.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late final TextEditingController _titleController;

  @override
  void initState() {
    super.initState();

    debugPrint('******** LIBRARY SCREEN INIT ********');

    _titleController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LibraryCubit>().fetchUserBooks();
    });
  }

  @override
  void dispose() {
    debugPrint('******** LIBRARY SCREEN DISPOSE ********');
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _addBook() async {
    try {
      debugPrint('========== ADD BOOK START ==========');

      final LibraryBook? book = await context.push<LibraryBook>(Routes.search);

      debugPrint('Returned from SearchScreen');
      debugPrint('Book returned: ${book?.title}');
      debugPrint('Book ID: ${book?.id}');
      debugPrint('Book status: ${book?.readingStatus}');

      if (book != null && mounted) {
        debugPrint('Calling LibraryCubit.addBook()');

        final libraryCubit = context.read<LibraryCubit>();

        await libraryCubit.addBook(book);

        // The book has now been saved through the Search -> Back flow.
        // We Clear it so Bottom Navigation does not save it again.
        libraryCubit.clearPendingBook();

        debugPrint('LibraryCubit.addBook() FINISHED');
        debugPrint('Pending book cleared');
      } else {
        debugPrint('NO BOOK RETURNED');
      }
      debugPrint('========== ADD BOOK END ==========');
    } catch (e) {
      debugPrint('Error while adding book: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      floatingActionButton: FloatingActionButton(
        onPressed: _addBook,
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
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, authState) {
                  ImageProvider? profileImage;

                  if (authState is Authenticated) {
                    final photoUrl = authState.user.photoUrl;

                    if (photoUrl != null && photoUrl.isNotEmpty) {
                      profileImage = NetworkImage(photoUrl);
                    }
                  }

                  return LibraryHeader(profileImage: profileImage);
                },
              ),
              SizedBox(height: 24.h),
              LibrarySearchField(
                controller: _titleController,
                onChanged: (value) {
                  context.read<LibraryCubit>().searchBooks(value);
                },
              ),

              SizedBox(height: 10.h),

              BlocBuilder<LibraryCubit, LibraryState>(
                buildWhen: (previous, current) {
                  if (previous is LibraryLoaded && current is LibraryLoaded) {
                    return previous.selectedStatus != current.selectedStatus;
                  }

                  return true;
                },
                builder: (context, state) {
                  ReadingStatus? selectedStatus;

                  if (state is LibraryLoaded) {
                    selectedStatus = state.selectedStatus;
                  }

                  return LibraryStatusFilter(
                    selectedStatus: selectedStatus,
                    onStatusChanged: (status) {
                      context.read<LibraryCubit>().changeStatusFilter(status);
                    },
                  );
                },
              ),

              SizedBox(height: 40.h),

              Expanded(
                child: BlocBuilder<LibraryCubit, LibraryState>(
                  builder: (context, state) {
                    if (state is LibraryLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.secondary,
                        ),
                      );
                    }

                    if (state is LibraryError) {
                      return Center(
                        child: Text(state.message, textAlign: TextAlign.center),
                      );
                    }

                    if (state is LibraryLoaded) {
                      return LibraryBooksGrid(
                        books: state.filteredBooks,
                        onBookTap: (book) async {
                          try {
                            await context.push(Routes.viewBook, extra: book);
                          } catch (e) {
                            debugPrint('Error opening book: $e');
                          }
                        },
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
