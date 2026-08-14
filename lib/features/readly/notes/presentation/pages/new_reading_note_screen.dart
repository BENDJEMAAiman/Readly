import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/core/theme/app_text_styles.dart';
import 'package:readly/features/readly/library/library/model/library_book.dart';
import 'package:readly/features/readly/notes/business_logic/notes_cubit.dart';
import 'package:readly/features/readly/notes/business_logic/notes_state.dart';
import 'package:readly/features/readly/notes/presentation/widgets/new_note_book_card.dart';
import 'package:readly/features/readly/notes/presentation/widgets/new_note_top_bar.dart';
import 'package:readly/features/readly/notes/presentation/widgets/note_content_field.dart';
import 'package:readly/features/readly/notes/presentation/widgets/note_editor_toolbar.dart';
import 'package:readly/features/readly/notes/presentation/widgets/note_title_field.dart';

class NewReadingNoteScreen extends StatefulWidget {
  const NewReadingNoteScreen({super.key, required this.book});

  final LibraryBook book;

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

    _titleController = TextEditingController();
    _contentController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _contentFocusNode.dispose();
    super.dispose();
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

    await context.read<NotesCubit>().addNote(
      bookId: widget.book.id!,
      title: title,
      content: content,
      pageNumber: widget.book.currentPage,
    );

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

    context.pop();
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

  void _close() {
    if (_isSaving) {
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

              const NoteEditorToolbar(),
            ],
          ),
        ),
      ),
    );
  }
}
