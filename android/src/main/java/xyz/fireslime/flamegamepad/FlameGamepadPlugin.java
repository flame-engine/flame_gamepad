package xyz.fireslime.flamegamepad;

import android.view.InputDevice;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlameGamepadPlugin */
public class FlameGamepadPlugin implements MethodCallHandler {
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flame_gamepad");
    channel.setMethodCallHandler(new FlameGamepadPlugin());
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("isGamepadConnected")) {
      int[] ids = InputDevice.getDeviceIds();

      for (int id : ids) {
        InputDevice device = InputDevice.getDevice(id);
        int sources = device.getSources();

        if (((sources & InputDevice.SOURCE_GAMEPAD) == InputDevice.SOURCE_GAMEPAD)) {
          result.success(true);
          return;
        }
      }

      result.success(false);
    } else {
      result.notImplemented();
    }
  }
}
