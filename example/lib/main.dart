import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flame_gamepad/flame_gamepad.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isConnected = false;
  String _lastEvent = 'None';

  @override
  void initState() {
    super.initState();
    initPlatformState();

    FlameGamepad.setListener((String evtType, String key) {
      setState(() {
        _lastEvent = evtType + " " + key;
      });
    });
  }

  Future<void> initPlatformState() async {
    bool isConnected;
    try {
      isConnected = await FlameGamepad.isGamepadConnected;
    } on PlatformException {
      isConnected = false;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _isConnected = isConnected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('Is connected on: $_isConnected\n'),
              Text(_lastEvent),
            ]
          )
        ),
      ),
    );
  }
}
