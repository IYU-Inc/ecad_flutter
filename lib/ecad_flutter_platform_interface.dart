import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'ecad_flutter_method_channel.dart';

abstract class EcadFlutterPlatform extends PlatformInterface {
  /// Constructs a EcadFlutterPlatform.
  EcadFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static EcadFlutterPlatform _instance = MethodChannelEcadFlutter();

  /// The default instance of [EcadFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelEcadFlutter].
  static EcadFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [EcadFlutterPlatform] when
  /// they register themselves.
  static set instance(EcadFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
