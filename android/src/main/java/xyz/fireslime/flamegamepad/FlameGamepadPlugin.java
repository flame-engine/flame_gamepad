package xyz.fireslime.flamegamepad;

import android.view.InputDevice;
import android.view.KeyEvent;
import android.app.Activity;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import java.util.Map;
import java.util.HashMap;

public class FlameGamepadPlugin implements MethodCallHandler {

  private static MethodChannel channel;

  public static void registerWith(final Registrar registrar) {
    channel = new MethodChannel(registrar.messenger(), "xyz.fireslime/flame_gamepad");
    channel.setMethodCallHandler(new FlameGamepadPlugin());
  }

  public static boolean dispatchKeyEvent(KeyEvent event) {
    String eventType = parseAction(event.getAction());
    if (eventType == null) {
      return false;
    }

    Integer keyCode = event.getKeyCode();
    channel.invokeMethod("flame_gamepad.key_event", buildArguments(eventType, keyCode));
    return false;
  }

  private static String parseAction(int action) {
    switch (action) {
      case KeyEvent.ACTION_DOWN: return "DOWN";
      case KeyEvent.ACTION_UP: return "UP";
      default: return null;
    }
  }

  private static Map<String, Object> buildArguments(String eventType, Integer keyCode) {
    Map<String, Object> result = new HashMap<>();
    result.put("eventType", eventType);
    result.put("keyCode", keyCode);
    return result;
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
