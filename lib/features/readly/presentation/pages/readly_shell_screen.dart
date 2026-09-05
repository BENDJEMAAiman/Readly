import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:readly/core/routing/routes.dart';
import 'package:readly/features/readly/presentation/widgets/readly_bottom_navigation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readly/features/readly/library/library/business_logic/library_cubit.dart';

class ReadlyShellScreen extends StatelessWidget {
  const ReadlyShellScreen({
    super.key,
    required this.child,
    required this.location,
  });

  final Widget child;
  final String location;

  int _getSelectedIndex() {
    if (location.startsWith(Routes.library) ||
        location.startsWith(Routes.search) ||
        location.startsWith(Routes.searchDetails) ||
        location.startsWith(Routes.addBookManually) ||
        location.startsWith(Routes.viewBook)) {
      return 1;
    }

    if (location.startsWith(Routes.notes)) {
      return 2;
    }

    if (location.startsWith(Routes.profile)) {
      return 3;
    }

    return 0;
  }

  Future<void> _onItemTapped(BuildContext context, int index) async {
    switch (index) {
      case 0:
        context.go(Routes.home);
        break;

      case 1:
        final libraryCubit = context.read<LibraryCubit>();
        final pendingBook = libraryCubit.pendingBookToAdd;

        if (pendingBook != null) {
          debugPrint('========== BOTTOM NAV LIBRARY ==========');
          debugPrint('Pending book: ${pendingBook.title}');
          debugPrint('Pending book ID: ${pendingBook.id}');
          debugPrint('Saving pending book...');
          debugPrint('=========================================');

          await libraryCubit.addBook(pendingBook);

          libraryCubit.clearPendingBook();
        }

        context.go(Routes.library);
        break;

      case 2:
        context.go(Routes.notes);
        break;

      case 3:
        context.go(Routes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _getSelectedIndex();

    return Scaffold(
      body: child,

      bottomNavigationBar: ReadlyBottomNavigation(
        selectedIndex: selectedIndex,
        onItemTapped: (index) {
          _onItemTapped(context, index);
        },
      ),
    );
  }
}
