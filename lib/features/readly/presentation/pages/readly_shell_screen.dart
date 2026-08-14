import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:readly/core/routing/routes.dart';
import 'package:readly/features/readly/presentation/widgets/readly_bottom_navigation.dart';

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

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(Routes.home);
        break;

      case 1:
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