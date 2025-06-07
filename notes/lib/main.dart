import 'package:flutter/material.dart';
import 'package:notes/data/local/db_helper.dart';
import 'package:notes/data/local/db_provider.dart';
import 'package:notes/homepage.dart';
import 'package:notes/data/local/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => DBProvider(dbRef: DBHelper.getInstance),),
      ChangeNotifierProvider(
          create: (_) => ThemeProvider())
    ],
    child: MyApp(),));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: context.watch<ThemeProvider>().getThemeValue() ? ThemeMode.dark : ThemeMode.light,
      darkTheme: ThemeData(
        brightness: Brightness.dark
      ),
      theme: ThemeData(
        brightness: Brightness.light
      ),
      title: 'Flutter SQL',
      home: HomePage(),
    );
  }
}
