import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:hive_example_khatabook/constant/app_colors.dart';
import 'package:hive_example_khatabook/constant/app_text.dart';
import 'package:hive_example_khatabook/constant/route_name.dart';
import 'package:hive_example_khatabook/screens/add_client_screen.dart';
import 'package:hive_example_khatabook/screens/dashboard.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var path = await getApplicationDocumentsDirectory();
  Hive.init(path.path);
  await Hive.openBox(AppText.hiveBox);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: AppColors.primaryColor,
      ),
      home: DashBoardScreen(),
    );
  }
}
