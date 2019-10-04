import Flutter
import UIKit
import GameController

public class SwiftFlameGamepadPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flame_gamepad", binaryMessenger: registrar.messenger())
    let instance = SwiftFlameGamepadPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if (call.method == "isGamepadConnected") {
        GCController.controllers().forEach({ controller in
            result(true);
        })
        
        result(false);
    }
  }
}
