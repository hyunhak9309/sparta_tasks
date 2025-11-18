import 'package:go_router/go_router.dart';
import 'package:tasks/ui/detail_page/view/detail_page.dart';
import 'package:tasks/ui/home_page/view/home_page.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomePage(title: '스파르타`s Tasks'),
    ),
      GoRoute(
      path: '/detail/:id',
      builder: (context, state) => DetailPage(toDoId: state.pathParameters['id']!),
    ),
  ],
);