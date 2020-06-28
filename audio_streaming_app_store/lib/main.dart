import 'package:flutter/material.dart';
import 'package:audio_streaming_app_store/view/sign_in_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SharedPreferences.setMockInitialValues({});
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {

    @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Audio Streaming',
      theme: new ThemeData(
        brightness: Brightness.dark,
        primaryColorBrightness: Brightness.dark,
      ),
      home: new SignInScreen(),
    );
  }
}

