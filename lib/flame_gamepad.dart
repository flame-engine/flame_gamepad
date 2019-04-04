import 'dart:async';
import 'package:flutter/services.dart';

const GAMEPAD_BUTTON_UP = "UP";
const GAMEPAD_BUTTON_DOWN = "DOWN";

const GAMEPAD_DPAD_UP = "UP";
const GAMEPAD_DPAD_DOWN = "DOWN";
const GAMEPAD_DPAD_LEFT = "LEFT";
const GAMEPAD_DPAD_RIGHT = "RIGHT";

const GAMEPAD_BUTTON_A = "A";
const GAMEPAD_BUTTON_B = "B";
const GAMEPAD_BUTTON_X = "X";
const GAMEPAD_BUTTON_Y = "Y";

const GAMEPAD_BUTTON_L1 = "L1";
const GAMEPAD_BUTTON_L2 = "L2";

const GAMEPAD_BUTTON_R1 = "R1";
const GAMEPAD_BUTTON_R2 = "R2";

const GAMEPAD_BUTTON_START = "START";
const GAMEPAD_BUTTON_SELECT = "SELECT";

typedef void KeyListener(RawKeyEvent event);
typedef void GamepadListener(String evtType, String key);

const ANDROID_MAPPING = {
  19: GAMEPAD_DPAD_UP,
  20: GAMEPAD_DPAD_DOWN,
  21: GAMEPAD_DPAD_LEFT,
  22: GAMEPAD_DPAD_RIGHT,
  96: GAMEPAD_BUTTON_A,
  97: GAMEPAD_BUTTON_B,
  99: GAMEPAD_BUTTON_X,
  100: GAMEPAD_BUTTON_Y,
  102: GAMEPAD_BUTTON_L1,
  103: GAMEPAD_BUTTON_R1,
  104: GAMEPAD_BUTTON_L2,
  105: GAMEPAD_BUTTON_R2,
  108: GAMEPAD_BUTTON_START,
  109: GAMEPAD_BUTTON_SELECT
};

/// Gamepad functionalities
///
class FlameGamepad {
  static KeyListener _listener;
  static GamepadListener _gamepadListener;

  static final MethodChannel _channel = const MethodChannel('xyz.fireslime/flame_gamepad');

  static Future<bool> get isGamepadConnected async {
    final bool isConnected = await _channel.invokeMethod('isGamepadConnected');
    return isConnected;
  }

  static final String lowercaseAlphabet = 'abcdefghijklmnopqrstuvwxyz';
  static final String uppercaseAlphabet = lowercaseAlphabet.toUpperCase();
  static final Map<String, int> lowercaseLettersFrom = _processAlphabet(lowercaseAlphabet, 29);
  static final Map<String, int> uppercaseLettersFrom = _processAlphabet(uppercaseAlphabet, 54);
  static final Map<String, int> lettersFrom = {}..addAll(lowercaseLettersFrom)..addAll(uppercaseLettersFrom);
  static final Map<int, String> lettersTo = Map.fromEntries(lettersFrom.entries.map((e) => MapEntry(e.value, e.key)));

  static Map<String, int> _processAlphabet(String alphabet, int start) {
    return Map.fromEntries(alphabet.split('').asMap().entries.map((e) => MapEntry(e.value, e.key + start)));
  }

  static int keyCodeForChar(String char) => lettersFrom[char];

  static String charForKeyCode(int keyCode) => lettersTo[keyCode];
 
  static void setListener(GamepadListener gamepadListener) {
    _channel.setMethodCallHandler(platformCallHandler);

    _gamepadListener = gamepadListener;
    _listener = (RawKeyEvent e) {
      String evtType =
          e is RawKeyDownEvent ? GAMEPAD_BUTTON_DOWN : GAMEPAD_BUTTON_UP;

      if (e.data is RawKeyEventDataAndroid) {
        RawKeyEventDataAndroid androidEvent = e.data as RawKeyEventDataAndroid;

        String key = ANDROID_MAPPING[androidEvent.keyCode];
        if (key != null) {
          gamepadListener(evtType, key);
        }
      }
    };

    RawKeyboard.instance.addListener(_listener);
  }

  void removeListener() {
    RawKeyboard.instance.removeListener(_listener);
  }

  static void handleKeyPress(String eventType, int keyCode) {
    _gamepadListener(eventType, charForKeyCode(keyCode));
  }

  static Future<void> platformCallHandler(MethodCall call) async {
    switch (call.method) {
      case 'flame_gamepad.key_event':
        String eventType = (call.arguments as Map)['eventType'];
        int keyCode = (call.arguments as Map)['keyCode'];
        handleKeyPress(eventType, keyCode);
      break;
      default:
        print('Unknown method: ${call.method}');
        break;
    }
  }
}