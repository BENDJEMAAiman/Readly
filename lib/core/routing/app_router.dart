import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:readly/core/dependency_injection/repositories.dart';
import 'package:readly/core/routing/routes.dart';
import 'package:readly/features/auth/business_logic/auth_cubit.dart';
import 'package:readly/features/auth/presentation/pages/check_email_password.dart';
import 'package:readly/features/auth/presentation/pages/check_email_verification.dart';
import 'package:readly/features/auth/presentation/pages/congratulation.dart';
import 'package:readly/features/auth/presentation/pages/login_page.dart';
import 'package:readly/features/auth/presentation/pages/sign_up_page.dart';
import 'package:readly/features/auth/presentation/pages/forgot_password.dart';
import 'package:readly/features/reading_session/business_logic/reading_session_cubit.dart';
import 'package:readly/features/reading_session/presentation/pages/reading_session_screen.dart';
import 'package:readly/features/readly/home/presentation/home_screen.dart';
import 'package:readly/features/readly/library/add_manually/business_logic/book_form_cubit.dart';
import 'package:readly/features/readly/library/add_manually/presentation/pages/add_book_manually_screen.dart';
import 'package:readly/features/readly/library/library/business_logic/library_cubit.dart';
import 'package:readly/features/readly/library/library/model/library_book.dart';
import 'package:readly/features/readly/library/library/presentation/book_view/pages/view_book_screen.dart';
import 'package:readly/features/readly/library/library/presentation/pages/library_screen.dart';
import 'package:readly/features/readly/library/search_book_api/business_logic/search_cubit.dart';
import 'package:readly/features/readly/library/search_book_api/model/search_model.dart';
import 'package:readly/features/readly/library/search_book_api/presentation/pages/search_screen.dart';
import 'package:readly/features/readly/library/search_book_details_api/business%20logic/search_details_cubit.dart';
import 'package:readly/features/readly/library/search_book_details_api/presentation/pages/search_details_screen.dart';
import 'package:readly/features/onboarding/business_logic/onboarding_cubit.dart';
import 'package:readly/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:readly/features/readly/notes/business_logic/notes_cubit.dart';
import 'package:readly/features/readly/notes/presentation/new_reading_note_args.dart';
import 'package:readly/features/readly/notes/presentation/pages/new_reading_note_screen.dart';
import 'package:readly/features/readly/notes/presentation/pages/notes_screen.dart';
import 'package:readly/features/readly/profile/presentation/pages/profile_screen.dart';
import 'package:readly/features/splash/business_logic/splash_cubit.dart';
import 'package:readly/features/splash/presentation/splash_page.dart';
import 'package:readly/features/readly/presentation/pages/readly_shell_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return ReadlyShellScreen(child: child, location: state.uri.path);
      },
      routes: [
        GoRoute(
          path: Routes.home,
          builder: (context, state) {
            return const HomeScreen();
          },
        ),

        ShellRoute(
          builder: (context, state, child) {
            return BlocProvider(
              create: (_) => LibraryCubit(libraryRepository)..fetchUserBooks(),
              child: child,
            );
          },
          routes: [
            GoRoute(
              path: Routes.library,
              builder: (context, state) {
                return const LibraryScreen();
              },
            ),

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

            GoRoute(
              path: Routes.addBookManually,
              builder: (context, state) {
                return BlocProvider(
                  create: (_) => BookFormCubit(),
                  child: const AddBookManuallyScreen(),
                );
              },
            ),

            GoRoute(
              path: Routes.viewBook,
              builder: (context, state) {
                final book = state.extra as LibraryBook;

                return BookViewScreen(book: book);
              },
            ),
          ],
        ),

        GoRoute(
          path: Routes.notes,
          builder: (context, state) {
            return BlocProvider(
              create: (_) => NotesCubit(notesRepository, libraryRepository),
              child: const NotesScreen(),
            );
          },
        ),

        GoRoute(
          path: Routes.profile,
          builder: (context, state) {
            return const ProfileScreen();
          },
        ),
      ],
    ),

    GoRoute(
      path: Routes.login,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => AuthCubit(authRepository),
          child: const LoginPage(),
        );
      },
    ),

    GoRoute(
      path: Routes.signup,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => AuthCubit(authRepository),
          child: const SignupPage(),
        );
      },
    ),

    GoRoute(
      path: Routes.forgotPassword,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => AuthCubit(authRepository),
          child: const ForgotPassword(),
        );
      },
    ),

    GoRoute(
      path: Routes.checkEmailPassword,
      builder: (context, state) {
        final email = state.extra as String;

        return BlocProvider(
          create: (_) => AuthCubit(authRepository),
          child: CheckEmailPassword(email: email),
        );
      },
    ),

    GoRoute(
      path: Routes.checkEmailVerification,
      builder: (context, state) {
        final email = state.extra as String;

        return BlocProvider(
          create: (_) => AuthCubit(authRepository),
          child: CheckEmailVerification(email: email),
        );
      },
    ),

    GoRoute(
      path: Routes.congratulation,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => AuthCubit(authRepository),
          child: const Congratulation(),
        );
      },
    ),

    // ---------------------------------------------------------
    // SPLASH
    // ---------------------------------------------------------
    GoRoute(
      path: Routes.splash,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => SplashCubit(splashRepository),
          child: const SplashPage(),
        );
      },
    ),

    // ---------------------------------------------------------
    // ONBOARDING
    // ---------------------------------------------------------
    GoRoute(
      path: Routes.onboarding,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => OnboardingCubit(onboardingRepository),
          child: const OnboardingPage(),
        );
      },
    ),

    GoRoute(
      path: Routes.newReadingNote,
      builder: (context, state) {
        final args = state.extra as NewReadingNoteArgs;

        return BlocProvider(
          create: (context) => NotesCubit(notesRepository, libraryRepository),
          child: NewReadingNoteScreen(book: args.book, note: args.note),
        );
      },
    ),

    GoRoute(
      path: Routes.readingSession,
      builder: (context, state) {
        final book = state.extra as LibraryBook;

        return BlocProvider(
          create: (context) =>
              ReadingSessionCubit(readingSessionRepository, libraryRepository),
          child: ReadingSessionScreen(book: book),
        );
      },
    ),
  ],
);
