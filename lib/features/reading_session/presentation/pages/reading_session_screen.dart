import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/features/reading_session/business_logic/reading_session_cubit.dart';
import 'package:readly/features/reading_session/business_logic/reading_session_state.dart';
import 'package:readly/features/reading_session/presentation/widgets/book_completed_dialog.dart';
import 'package:readly/features/reading_session/presentation/widgets/discard_session_dialog.dart';
import 'package:readly/features/reading_session/presentation/widgets/pages_read_bottom_sheet.dart';
import 'package:readly/features/reading_session/presentation/widgets/reading_session_top_bar.dart';
import 'package:readly/features/reading_session/presentation/widgets/session_book_card.dart';
import 'package:readly/features/reading_session/presentation/widgets/session_control_button.dart';
import 'package:readly/features/reading_session/presentation/widgets/stopwatch_display.dart';
import 'package:readly/features/readly/library/library/model/library_book.dart';
import 'package:readly/core/routing/routes.dart';
import 'package:readly/features/readly/notes/presentation/new_reading_note_args.dart';

class ReadingSessionScreen extends StatefulWidget {
  const ReadingSessionScreen({super.key, required this.book});

  final LibraryBook book;

  @override
  State<ReadingSessionScreen> createState() => _ReadingSessionScreenState();
}

class _ReadingSessionScreenState extends State<ReadingSessionScreen> {
  @override
  void initState() {
    super.initState();

    context.read<ReadingSessionCubit>().startSession(widget.book);
  }

  void _handleControlButton(BuildContext context, ReadingSessionState state) {
    final cubit = context.read<ReadingSessionCubit>();

    if (state is SessionActive) {
      cubit.pauseSession();
    } else if (state is SessionPaused) {
      cubit.resumeSession();
    }
  }

  Future<void> _finishSession() async {
    final cubit = context.read<ReadingSessionCubit>();
    final state = cubit.state;

    if (state is! SessionActive && state is! SessionPaused) {
      return;
    }

    // Pause the stopwatch first so the duration stops increasing
    // while the user is entering the pages read.
    if (state is SessionActive) {
      cubit.pauseSession();
    }

    final currentState = cubit.state;

    if (currentState is! SessionPaused) {
      return;
    }

    final pagesRead = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      builder: (context) {
        return PagesReadBottomSheet(
          currentPage: currentState.book.currentPage,
          totalPages: currentState.book.pages ?? 0,
        );
      },
    );

    if (!mounted || pagesRead == null) {
      return;
    }

    // For now, just verify that the value came back correctly.
    debugPrint('Pages read: $pagesRead');
    await cubit.stopAndSaveSession(pagesRead: pagesRead);
  }

  Future<void> _handleClose() async {
    final cubit = context.read<ReadingSessionCubit>();

    final state = cubit.state;

    // No session has started yet.
    if (state is SessionIdle) {
      context.pop();
      return;
    }

    // Don't allow closing while the session is being saved.
    if (state is SessionSaving) {
      return;
    }

    final shouldDiscard = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const DiscardSessionDialog();
      },
    );

    if (!mounted) {
      return;
    }

    if (shouldDiscard == true) {
      cubit.discardSession();
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReadingSessionCubit, ReadingSessionState>(
      listener: (context, state) async {
        if (state is SessionCompleted) {
          if (state.bookCompleted) {
            await showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return BookCompletedDialog(bookTitle: state.book.title);
              },
            );

            if (!context.mounted) {
              return;
            }

            context.pop(state.book);
            return;
          }

          context.pop(state.book);
        }

        if (state is SessionError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },

      child: BlocBuilder<ReadingSessionCubit, ReadingSessionState>(
        builder: (context, state) {
          final durationSeconds = _getDurationSeconds(state);
          final isActive = state is SessionActive;
          final isSaving = state is SessionSaving;

          final foregroundColor = isActive
              ? AppColors.white
              : AppColors.grey600;

          final stopwatchTextColor = isActive
              ? AppColors.white
              : AppColors.buttonBlueDark;

          final finishBackgroundColor = isActive
              ? AppColors.white.withValues(alpha: 0.25)
              : AppColors.secondaryLight;

          return Scaffold(
            body: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              color: isActive
                  ? const Color(0xFF7FABD8)
                  : const Color(0xFFF8F5EF),
              child: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      child: ReadingSessionTopBar(
                        onClose: _handleClose,
                        onFinish: _finishSession,
                        foregroundColor: foregroundColor,
                        finishBackgroundColor: finishBackgroundColor,
                        isSaving: isSaving,
                      ),
                    ),

                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          children: [
                            SizedBox(height: 30.h),

                            StopwatchDisplay(
                              durationSeconds: durationSeconds,
                              isActive: isActive,
                              textColor: stopwatchTextColor,
                            ),

                            SizedBox(height: 6.h),

                            SessionControlButton(
                              isActive: isActive,
                              onPressed: () {
                                _handleControlButton(context, state);
                              },
                            ),

                            SizedBox(height: 140.h),

                            SessionBookCard(
                              book: widget.book,
                              isActive: isActive,
                              onNotesPressed: () async {
                                await context.push(
                                  Routes.newReadingNote,
                                  extra: NewReadingNoteArgs(book: widget.book),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  int _getDurationSeconds(ReadingSessionState state) {
    if (state is SessionActive) {
      return state.durationSeconds;
    }

    if (state is SessionPaused) {
      return state.durationSeconds;
    }

    return 0;
  }
}
