import 'package:package_info_plus/package_info_plus.dart';

class CheckUpdate {
  static String? localBuildNumber;

  static bool checkUpdate() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      localBuildNumber = packageInfo.buildNumber;
    });
    if (int.parse(localBuildNumber!) < 5) {
      return true;
    }
    return false;
  }
}