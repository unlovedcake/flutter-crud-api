import 'package:crud_api/animate_fade_route.dart';
import 'package:crud_api/animate_route_slide_left.dart';
import 'package:crud_api/animate_route_zoom_in.dart';
import 'package:crud_api/app_bloc_pages.dart';
import 'package:crud_api/bloc/home_bloc.dart';
import 'package:crud_api/bloc/todo_bloc.dart';
import 'package:crud_api/pages/google_map.dart';
import 'package:crud_api/pages/home.dart';
import 'package:crud_api/pages/settings_page.dart';
import 'package:crud_api/pages/todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'CRUD TASK',
  //     theme: ThemeData(
  //       primarySwatch: Colors.blue,
  //     ),
  //     home: const Home(),
  //   );
  // }


  Widget build(BuildContext context) {
        return MultiBlocProvider(
          providers: AppBlocPages.blocProviders,
          // providers: [
          //  //BlocProvider(
          //  //  create: (context) =>   AuthenticationBloc(AuthenticationRepositoryImpl())
          //  //   ..add(AuthenticationStarted()),
          //  // ),
          //   BlocProvider<TodoBloc>(
          //     create: (context) => TodoBloc()..add(GetTodoEvent()),
          //   ),
          // ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.blueAccent
              )
            ),
             initialRoute: '/',
             
             onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;

        switch (settings.name) {
          case '/':
            builder = (BuildContext _) => Home();
            break;
          case '/todo':
            builder = (BuildContext _) => TodoPage();
            break;
          case '/settings':
            builder = (BuildContext _) => SettingsPage();
            break;
           case '/googlemap':
            builder = (BuildContext _) => PolylineAnimationExample();
            break;  
          default:
            throw Exception('Invalid route: ${settings.name}');
        }

        return ZoomInRoute(page: builder(context));
      },
              // routes: AppBlocPages.appRoutes,
          )
        );
  }
}
