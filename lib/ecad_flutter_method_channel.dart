import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'ecad_flutter_platform_interface.dart';

/// An implementation of [EcadFlutterPlatform] that uses method channels.
class MethodChannelEcadFlutter extends EcadFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('ecad_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
