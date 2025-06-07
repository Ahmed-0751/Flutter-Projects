import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoist/data/add_task_provider.dart';
import 'package:todoist/data/db_provider.dart';

import 'data/db_helper.dart';
import 'view/homepage.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DBProvider(dbRef: DBHelper.getInstance)),
        ChangeNotifierProvider(create: (context) => AddTaskProvider()),
      ],
      child: MyApp(),
    ),

  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      theme: ThemeData(
        colorScheme: ColorScheme.light(),
      ),
    );
  }
}
