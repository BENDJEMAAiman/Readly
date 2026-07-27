import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:readly/core/dependency_injection/repositories.dart';
import 'package:readly/core/routing/routes.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_api/business_logic/search_cubit.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_api/model/search_model.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_api/presentation/search_screen.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_details_api/business%20logic/search_details_cubit.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_details_api/presentation/search_details_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: Routes.search,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => SearchCubit(searchRepository),
          child: const SearchScreen(),
        );
      },
    ),

    GoRoute(
      path: Routes.searchDetails,
      builder: (context, state) {
        final basicInfo = state.extra as SearchModel;

        return BlocProvider(
          create: (_) => SearchDetailsCubit(searchDetailsRepository),
          child: SearchDetailsScreen(basicInfo: basicInfo),
        );
      },
    ),
  ],
);
