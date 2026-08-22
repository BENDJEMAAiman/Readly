import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/core/theme/app_text_styles.dart';
import 'package:readly/features/readly/library/library/model/library_book.dart';
import 'package:readly/features/readly/notes/business_logic/notes_cubit.dart';
import 'package:readly/features/readly/notes/business_logic/notes_state.dart';
import 'package:readly/features/readly/notes/model/note_entity.dart';
import 'package:readly/features/readly/notes/presentation/widgets/new_note_book_card.dart';
import 'package:readly/features/readly/notes/presentation/widgets/new_note_top_bar.dart';
import 'package:readly/features/readly/notes/presentation/widgets/note_content_field.dart';
import 'package:readly/features/readly/notes/presentation/widgets/note_title_field.dart';

class NewReadingNoteScreen extends StatefulWidget {
  const NewReadingNoteScreen({super.key, required this.book, this.note});

  final LibraryBook book;
  final NoteEntity? note;

  @override
  State<NewReadingNoteScreen> createState() => _NewReadingNoteScreenState();
}

class _NewReadingNoteScreenState extends State<NewReadingNoteScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  final FocusNode _contentFocusNode = FocusNode();

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.note?.title ?? '');

    _contentController = TextEditingController(
      text: widget.note?.content ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _contentFocusNode.dispose();
    super.dispose();
  }

  bool _hasUnsavedChanges() {
    final currentTitle = _titleController.text.trim();
    final currentContent = _contentController.text.trim();

    // Creating a new note
    if (widget.note == null) {
      return currentTitle.isNotEmpty || currentContent.isNotEmpty;
    }

    // Editing an existing note
    return currentTitle != widget.note!.title ||
        currentContent != widget.note!.content;
  }

  Future<bool> _showDiscardDialog() async {
    final shouldLeave = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Text(
            'Leave without saving?',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.buttonBlueDark,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Do you want to leave without saving your note?',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.grey500,
              height: 1.5,
            ),
          ),
          actionsPadding: EdgeInsets.zero,
          actions: [
            SizedBox(
              height: 52.h,
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop(false);
                      },
                      child: Text(
                        'No',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.buttonBlueDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 1.w,
                    height: 52.h,
                    color: AppColors.buttonBlueDark.withValues(alpha: 0.25),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop(true);
                      },
                      child: Text(
                        'Yes',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.buttonBlueDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );

    return shouldLeave ?? false;
  }

  Future<void> _saveNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty) {
      _showMessage('Please enter a note title.');
      return;
    }

    if (content.isEmpty) {
      _showMessage('Please write something in your note.');
      return;
    }

    if (widget.book.id == null || widget.book.id!.isEmpty) {
      _showMessage('This book does not have a valid ID.');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final notesCubit = context.read<NotesCubit>();

    if (widget.note == null) {
      // CREATE NEW NOTE
      await notesCubit.addNote(
        bookId: widget.book.id!,
        title: title,
        content: content,
        pageNumber: widget.book.currentPage,
      );
    } else {
      // UPDATE EXISTING NOTE
      final updatedNote = widget.note!.copyWith(
        title: title,
        content: content,
        updatedAt: DateTime.now(),
      );

      await notesCubit.updateNote(updatedNote);
    }

    if (!mounted) {
      return;
    }

    final state = context.read<NotesCubit>().state;

    setState(() {
      _isSaving = false;
    });

    if (state is NotesError) {
      _showMessage(state.message);
      return;
    }

    context.pop(true);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white),
        ),
      ),
    );
  }

  Future<void> _close() async {
    if (_isSaving) {
      return;
    }

    if (!_hasUnsavedChanges()) {
      context.pop();
      return;
    }

    final shouldLeave = await _showDiscardDialog();

    if (!mounted || !shouldLeave) {
      return;
    }

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotesCubit, NotesState>(
      listener: (context, state) {
        if (state is NotesError && _isSaving) {
          if (mounted) {
            setState(() {
              _isSaving = false;
            });
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,

        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: NewNoteTopBar(
                  onClose: _close,
                  onSave: _saveNote,
                  isSaving: _isSaving,
                ),
              ),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 24.h),

                      NewNoteBookCard(book: widget.book),

                      SizedBox(height: 30.h),

                      NoteTitleField(controller: _titleController),

                      SizedBox(height: 4.h),

                      NoteContentField(
                        controller: _contentController,
                        focusNode: _contentFocusNode,
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
  }
}
