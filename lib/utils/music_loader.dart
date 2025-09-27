part of '../quote.dart';

class MusicLoader {
  // 请求权限（内部使用）
  static Future<bool> _requestPermission() async {
    if (Platform.isAndroid) {
      final androidInfo =
          await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      if (sdkInt >= 33) {
        final status = await Permission.audio.status;
        if (status.isGranted) return true;
        final result = await Permission.audio.request();
        return result.isGranted;
      } else {
        final status = await Permission.storage.status;
        if (status.isGranted) return true;
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

  // 判断是否永久拒绝权限（以后不能再请求，只能跳设置）
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

  // 获取一个默认音乐目录（Android / 桌面平台都做 fallback）
  static Future<Directory> getMusicDirectory() async {
    if (Platform.isAndroid) {
      Directory dir = Directory(
        '/storage/emulated/0/Music',
      );
      if (await dir.exists()) {
        return dir;
      }
      Directory? ext = await getExternalStorageDirectory();
      if (ext != null) return ext;
      return await getApplicationDocumentsDirectory();
    } else if (Platform.isWindows ||
        Platform.isLinux ||
        Platform.isMacOS) {
      return await getApplicationDocumentsDirectory();
    } else {
      throw UnsupportedError(
        "Unsupported platform for music directory",
      );
    }
  }

  // 扫描目录下的音频文件
  static Future<List<File>> scanAudioFiles(
    Directory dir,
  ) async {
    final List<File> audioFiles = [];
    final extensions = [
      '.mp3',
      '.flac',
      '.wav',
      '.m4a',
      '.aac',
      '.ogg',
    ];

    await for (var entity in dir.list(
      recursive: true,
      followLinks: false,
    )) {
      if (entity is File) {
        String pathLower = entity.path.toLowerCase();
        for (var ext in extensions) {
          if (pathLower.endsWith(ext)) {
            audioFiles.add(entity);
            break;
          }
        }
      }
    }

    return audioFiles;
  }

  // 从文件列表读取 metadata，返回一个 Map 列表
  static Future<List<Map<String, dynamic>>> extractMetadata(
    List<File> files,
  ) async {
    List<Map<String, dynamic>> result = [];
    for (var file in files) {
      try {
        // audio_metadata_reader 读取是同步的，传 File 对象
        final meta = readMetadata(file, getImage: false);

        result.add({
          'title': meta.title ?? file.uri.pathSegments.last,
          'artist': meta.artist ?? '',
          'album': meta.album ?? '',
          // duration 单位是秒，可能是 null
          'duration': meta.duration ?? 0,
          'path': file.path,
          // 你可以扩展支持封面、genre等
        });
      } catch (e, stack) {
        print('读取音乐文件 ${file.path} 元数据失败: $e');
        print(stack);
        result.add({
          'title': file.uri.pathSegments.last,
          'artist': '',
          'album': '',
          'duration': 0,
          'path': file.path,
        });
      }
    }
    return result;
  }

  // 一体化接口：检查权限 + 扫描 + 读取元数据
  static Future<List<Map<String, dynamic>>>
  loadLocalMusicWithPermission() async {
    bool granted = await _requestPermission();
    if (!granted) {
      throw Exception("Permission not granted");
    }
    Directory dir = await getMusicDirectory();
    List<File> files = await scanAudioFiles(dir);
    return await extractMetadata(files);
  }
}
