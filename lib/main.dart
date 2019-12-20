import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taksi_chofer/state/app_state.dart';

import 'main_screen.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tak-si',
      home: MyHomePage(),
    );
  }
}
