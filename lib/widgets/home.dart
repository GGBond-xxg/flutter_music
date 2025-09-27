part of '../quote.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});
  final ThemeController themeController = Get.find();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PanelController panelController = PanelController();
  Duration currentPosition = Duration.zero; // 当前播放时间，动态更新

  List<Song> songs = []; // 初始空列表

  bool selectedIsPlay = false;
  int selectedIndex = -1;

  Song? get selectedSong =>
      (selectedIndex >= 0 && selectedIndex < songs.length)
          ? songs[selectedIndex]
          : null;

  final ThemeController themeController = Get.find();

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(
      duration.inMinutes.remainder(60),
    );
    final seconds = twoDigits(
      duration.inSeconds.remainder(60),
    );
    return '$minutes:$seconds';
  }

  void _changeSunMode() {
    themeController.setTheme(ThemeMode.light);
  }

  void _changeNightMode() {
    themeController.setTheme(ThemeMode.dark);
  }

  void _toggleTheme() {
    themeController.setTheme(ThemeMode.system);
  }

  void _togglePlayState() {
    if (selectedIndex == -1) {
      selectedIndex = 0;
    }
    selectedIsPlay = !selectedIsPlay;
    setState(() {});
  }

  void _onSelectSong(
    String title,
    String subTitle,
    IconData icon,
    bool isPlaying,
    Uint8List? imageBytes, // ✅ 改这里
    int index,
  ) {
    selectedIndex = index;
    selectedIsPlay = isPlaying;
    setState(() {});
  }

  void _onNextSong() {
    if (selectedIndex >= songs.length - 1) {
      selectedIndex = 0;
    } else {
      selectedIndex += 1;
    }
    selectedIsPlay = true;
    setState(() {});
  }

  void _onPreviousSong() {
    if (selectedIndex <= 0) {
      selectedIndex = songs.length - 1;
    } else {
      selectedIndex -= 1;
    }
    selectedIsPlay = true;
    setState(() {});
  }

  // 打开MusicData页面，返回歌曲列表后更新songs
  Future<void> _openMusicDataPage() async {
    final result = await Get.to<List<Map<String, dynamic>>>(
      () => const MusicLocalData(),
      transition: Transition.cupertino,
      duration: Duration(milliseconds: 300),
    );

    if (result != null && result.isNotEmpty) {
      final newSongs =
          result.map<Song>((map) {
            Uint8List? imageBytes;

            if (map['picture'] is Uint8List) {
              imageBytes = map['picture'];
            } else if (map['picture'] is List &&
                map['picture'].isNotEmpty) {
              if (map['picture'][0] is Uint8List) {
                imageBytes = map['picture'][0];
              }
            }

            return Song(
              title: map['title'] ?? '未知标题',
              subtitle: map['artist'] ?? '未知艺术家',
              icon: AliIcon.iconDefault,
              imageBytes: imageBytes,
              duration:
                  map['duration'] is Duration
                      ? (map['duration'] as Duration)
                          .inSeconds
                      : (map['duration'] as int?) ?? 0,
              // 取duration
            );
          }).toList();

      setState(() {
        songs = newSongs;
        selectedIndex = 0;
        selectedIsPlay = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyBackgroundColor(context),
      body: SlidingUpPanel(
        minHeight: 85,
        controller: panelController,
        maxHeight: MediaQuery.of(context).size.height,
        panelBuilder:
            () => MusicDetails(
              isPlay: selectedIsPlay,
              onNextSongs: _onNextSong,
              onTogglePlay: _togglePlayState,
              onPreviousSongs: _onPreviousSong,
              imageBytes: selectedSong?.imageBytes,
              title: selectedSong?.title ?? '无音乐',
              subTitle: selectedSong?.subtitle ?? '暂无播放',
              currentTime: formatDuration(currentPosition),
              totalDuration: formatDuration(
                Duration(
                  seconds: selectedSong?.duration ?? 0,
                ),
              ),
            ),
        collapsed: BottomShow(
          index: selectedIndex,
          nextSong: _onNextSong,
          isPlay: selectedIsPlay,
          onTogglePlay: _togglePlayState,
          panelController: panelController,
          title: selectedSong?.title ?? '无音乐',
          imageBytes: selectedSong?.imageBytes,
          subTitle: selectedSong?.subtitle ?? '暂无播放',
          icon: selectedSong?.icon ?? AliIcon.iconDefault,
        ),
        body: BodyWidget(
          songs: songs,
          onBackPressed: _onSelectSong,
          selectedIndex: selectedIndex,
        ),
      ),
      endDrawer: SettingPage(
        onTapSun: _changeSunMode,
        onTapSystem: _toggleTheme,
        onTapMoon: _changeNightMode,
        onImportMusic: _openMusicDataPage,
        currentThemeMode: themeController.themeMode.value,
      ),
    );
  }
}
