part of '../quote.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});
  final ThemeController themeController = Get.find();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PanelController panelController = PanelController();

  List<Song> songs = []; // 初始空列表

  bool selectedIsPlay = false;
  int selectedIndex = -1;

  Song? get selectedSong =>
      (selectedIndex >= 0 && selectedIndex < songs.length)
          ? songs[selectedIndex]
          : null;

  final ThemeController themeController = Get.find();

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
    String songImage,
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
            return Song(
              title: map['title'] ?? '未知标题',
              subtitle: map['artist'] ?? '未知艺术家',
              imagePath:
                  map['imagePath'] ??
                  'assets/images/imageDefault.png',
              icon: AliIcon.iconDefault,
            );
          }).toList();

      setState(() {
        songs = newSongs;
        selectedIndex = 0;
        selectedIsPlay = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('加载了 ${newSongs.length} 首本地音乐'),
        ),
      );
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
              title: selectedSong?.title ?? '无音乐',
              albumCover: selectedSong?.imagePath ?? '',
              subTitle: selectedSong?.subtitle ?? '暂无播放',
            ),
        collapsed: BottomShow(
          index: selectedIndex,
          nextSong: _onNextSong,
          isPlay: selectedIsPlay,
          onTogglePlay: _togglePlayState,
          panelController: panelController,
          title: selectedSong?.title ?? '无音乐',
          songImage: selectedSong?.imagePath ?? '',
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
