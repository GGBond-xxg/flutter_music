part of '../quote.dart';

class PermissionUtils {
  static Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      final androidInfo =
          await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      if (sdkInt >= 33) {
        // Android 13 及以上使用 media 权限
        final audioStatus = await Permission.audio.status;
        if (audioStatus.isGranted) return true;

        final result = await Permission.audio.request();
        return result.isGranted;
      } else {
        // Android 13 以下使用 storage 权限
        final storageStatus =
            await Permission.storage.status;
        if (storageStatus.isGranted) return true;

        final result = await Permission.storage.request();
        return result.isGranted;
      }
    } else if (Platform.isIOS || Platform.isMacOS) {
      final status = await Permission.mediaLibrary.status;
      if (status.isGranted) return true;

      final result =
          await Permission.mediaLibrary.request();
      return result.isGranted;
    } else {
      // Windows / Linux 默认允许
      return true;
    }
  }

  static Future<bool> isPermanentlyDenied() async {
    if (Platform.isAndroid) {
      final androidInfo =
          await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      if (sdkInt >= 33) {
        return await Permission.audio.isPermanentlyDenied;
      } else {
        return await Permission.storage.isPermanentlyDenied;
      }
    } else if (Platform.isIOS || Platform.isMacOS) {
      return await Permission
          .mediaLibrary
          .isPermanentlyDenied;
    }

    return false;
  }
}
