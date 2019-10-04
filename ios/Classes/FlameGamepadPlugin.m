#import "FlameGamepadPlugin.h"
#import <flame_gamepad/flame_gamepad-Swift.h>

@implementation FlameGamepadPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlameGamepadPlugin registerWithRegistrar:registrar];
}
@end
