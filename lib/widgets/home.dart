part of '../quote.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});
  final ThemeController themeController = Get.find();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PanelController panelController = PanelController();
  final List<Song> songs = List.generate(
    20,
    (i) => Song(
      title: 'Title $i',
      subtitle: 'Subtitle $i',
      imagePath: 'assets/images/imageDefault.png',
      icon: AliIcon.iconDefault,
    ),
  );

  bool selectedIsPlay = false;
  int selectedIndex = -1;
  Song? get selectedSong =>
      (selectedIndex >= 0 && selectedIndex < songs.length)
          ? songs[selectedIndex]
          : null;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
    super.initState();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyBackgroundColor(context),
      body: SlidingUpPanel(
        // parallaxEnabled: true,
        // parallaxOffset: 0.2,
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
          onBackPressed: _onSelectSong,
          selectedIndex: selectedIndex,
          songs: songs,
        ),
      ),
      endDrawer: SettingPage(
        onTapSun: _changeSunMode,
        onTapMoon: _changeNightMode,
        onTapSystem: _toggleTheme,
        currentThemeMode: themeController.themeMode.value,
      ),
    );
  }
}
