import 'package:just_audio_media_kit/just_audio_media_kit.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:music/quote.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  JustAudioMediaKit.ensureInitialized(); // ✅ 重要！
  Get.put(ThemeController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (
        ColorScheme? lightDynamic,
        ColorScheme? darkDynamic,
      ) {
        final ThemeController themeController = Get.find();
        // fallback: if system doesn't support Monet (like Android 11-)
        final lightColorScheme =
            lightDynamic ??
            ColorScheme.fromSeed(seedColor: Colors.blue);
        final darkColorScheme =
            darkDynamic ??
            ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.dark,
            );
        return Obx(
          () => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: lightColorScheme,
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: darkColorScheme,
              useMaterial3: true,
            ),
            themeMode: themeController.themeMode.value,
            home: HomePage(),
          ),
        );
      },
    );
  }
}
