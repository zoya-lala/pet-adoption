import 'package:go_router/go_router.dart';

import '../model/pet_model.dart';
import '../pages/details_page.dart';
import '../pages/history_page.dart';
import '../pages/home_page.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/details',
      name: 'details',
      builder: (context, state) {
        final pet = state.extra as Pet;
        return DetailsPage(pet: pet);
      },
    ),
    GoRoute(
      path: '/history',
      name: 'history',
      builder: (context, state) => const HistoryPage(),
    ),
  ],
);
