part of '../quote.dart';

class PermissionUtils {
  static Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      final androidInfo =
          await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        return await Permission.audio.request().isGranted;
      } else {
        return await Permission.storage.request().isGranted;
      }
    } else if (Platform.isIOS || Platform.isMacOS) {
      return await Permission.mediaLibrary
          .request()
          .isGranted;
    }
    return true; // Linux / Windows 不需要权限
  }
}
