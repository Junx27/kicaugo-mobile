import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:url_launcher_platform_interface/link.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

/// Peluncur peta palsu yang menganggap aplikasi eksternal tersedia.
class FakeLauncherPlatform extends UrlLauncherPlatform {
  @override
  LinkDelegate? get linkDelegate => null;

  @override
  Future<bool> canLaunch(String url) async => true;

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async => true;
}

/// Menonaktifkan plugin lokasi dan peluncur URL asli selama test widget.
void stubExternalNavigation({UrlLauncherPlatform? platform}) {
  const geolocatorChannel = MethodChannel('flutter.baseflow.com/geolocator');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(geolocatorChannel, (call) async {
        throw MissingPluginException();
      });
  addTearDown(
    () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(geolocatorChannel, null),
  );

  final previous = UrlLauncherPlatform.instance;
  addTearDown(() => UrlLauncherPlatform.instance = previous);
  UrlLauncherPlatform.instance = platform ?? FakeLauncherPlatform();
}
