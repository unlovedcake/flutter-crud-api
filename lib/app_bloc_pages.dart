import 'package:crud_api/bloc/home_bloc.dart';
import 'package:crud_api/bloc/todo_bloc.dart';
import 'package:crud_api/pages/google_map.dart';
import 'package:crud_api/pages/home.dart';
import 'package:crud_api/pages/settings_page.dart';
import 'package:crud_api/pages/todo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocPages {

      static final List<BlocProvider> blocProviders = [
  BlocProvider<TodoBloc>(
    create: (context) => TodoBloc()..add(GetTodoEvent()),
  ),
  BlocProvider<HomeBloc>(
    create: (context) => HomeBloc(),
  ),
  // Add more BlocProviders here
];

static final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const Home(),
  '/todo': (context) => const TodoPage(),
  '/settings': (context) => const SettingsPage(),
  '/googlemap': (context) =>  PolylineAnimationExample(),
  // Add more routes here if needed
};
}