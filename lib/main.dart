import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_app_sql_database/pages/create_update/provider.dart';
import 'package:note_app_sql_database/pages/detail/provider.dart';
import 'package:note_app_sql_database/pages/home/provider.dart';
import 'package:note_app_sql_database/pages/home/view.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // #StatusBar & NavigationBar Color
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xff00000f),
      systemNavigationBarColor: Color(0xff00000f),
    ),
  );
  // #Orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);


  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => HomeProvider()),
          ChangeNotifierProvider(create: (_) => CreateUpdateProvider()),
          ChangeNotifierProvider(create: (_) => DetailProvider()),
        ],
        child: const MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Notes App',
    themeMode: ThemeMode.dark,
    theme: ThemeData(
      primaryColor: Colors.black,
      scaffoldBackgroundColor: const Color(0xff00000f),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xff00000f),
        elevation: 0,
      ),
    ),
    home: const HomePage(),
  );
}