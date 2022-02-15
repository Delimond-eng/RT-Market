import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rt_market/controllers/db_manager_controller.dart';
import 'package:rt_market/controllers/inventory_controller.dart';
import 'package:rt_market/controllers/vente_controller.dart';
import 'controllers/sql_manager_controller.dart';
import 'index.dart';
import 'package:window_size/window_size.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux) {
    setWindowTitle("HITECH sarl");
    //setWindowMinSize(const Size(1900, 900));
  }
  await DbManager.createTables();
  await GetStorage.init();
  Get.put(SqlManagerController());
  Get.put(InventoryController());
  Get.put(GlobalController());
  Get.put(DBManagerController());
  Get.put(VenteController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Hitech SARL',
      // ignore: prefer_const_literals_to_create_immutables
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // ignore: prefer_const_literals_to_create_immutables
      supportedLocales: [
        const Locale('fr'),
        const Locale('en'),
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        primaryColor: Colors.purple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      home: const AuthScreen(),
    );
  }
}
