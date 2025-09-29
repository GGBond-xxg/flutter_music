part of '../quote.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});
  final ThemeController themeController = Get.find();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Duration currentPosition = Duration.zero; // 当前播放时间，动态更新
  final AudioPlayer _player = AudioPlayer(); //播放器实例
  final PanelController panelController = PanelController();
  final ItemScrollController lyricScrollController =
      ItemScrollController();
  final ItemPositionsListener lyricPositionListener =
      ItemPositionsListener.create();

  List<LyricLine> _currentLyrics = []; // 当前歌词

  List<LyricLine> _parseLyrics(String lyrics) {
    final regex = RegExp(r'\[(\d+):(\d+)\.(\d+)\](.*)');
    final lines = lyrics.split('\n');
    List<LyricLine> result = [];

    for (var line in lines) {
      final match = regex.firstMatch(line);
      if (match != null) {
        final minutes = int.parse(match.group(1)!);
        final seconds = int.parse(match.group(2)!);
        final milliseconds = int.parse(match.group(3)!);
        final text = match.group(4)!.trim();
        if (text.isEmpty) continue;
        result.add(
          LyricLine(
            time: Duration(
              minutes: minutes,
              seconds: seconds,
              milliseconds: milliseconds * 10,
            ),
            text: text,
          ),
        );
      }
    }

    result.sort((a, b) => a.time.compareTo(b.time));
    return result;
  }

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

  void _play() async {
    _player.playing
        ? await _player.pause()
        : await _player.play();
  }

  void _changePlayIcon() {
    selectedIsPlay = !selectedIsPlay;
  }

  void _changePlayToTrue() {
    selectedIsPlay = true;
  }

  void _togglePlayState() async {
    _play();
    _changePlayIcon();
    setState(() {});
  }

  void _changeNowPlaySong() async {
    final nowSong = songs[selectedIndex];
    await _player.setAudioSource(
      AudioSource.uri(Uri.file(nowSong.path)),
    );
    // 设置歌词
    _currentLyrics = nowSong.lyrics;
    await _player.play();
    _changePlayToTrue(); // 更新播放图标
    setState(() {}); // 更新 UI
  }

  void _onNextSong() {
    if (songs.isEmpty) return;
    // 切换索引
    if (selectedIndex >= songs.length - 1) {
      selectedIndex = 0;
    } else {
      selectedIndex += 1;
    }
    _changeNowPlaySong();
    // 播放
    selectedIsPlay = true;
    setState(() {});
  }

  void _onPreviousSong() async {
    if (songs.isEmpty) return;

    // 更新索引
    if (selectedIndex <= 0) {
      selectedIndex = songs.length - 1;
    } else {
      selectedIndex -= 1;
    }
    _changeNowPlaySong();
    // 播放
    selectedIsPlay = true;
    setState(() {});
  }

  void _onSelectSong(
    String title,
    String subTitle,
    IconData icon,
    bool isPlaying,
    Uint8List? imageBytes,
    int index,
  ) async {
    selectedIndex = index;
    // 点歌就认为应该播放
    selectedIsPlay = true;
    final song = songs[index];
    _currentLyrics = song.lyrics;
    try {
      Uri uri = Uri.file(song.path);
      final audioSource = AudioSource.uri(uri);
      await _player.setAudioSource(audioSource);
    } catch (e) {
      return;
    }

    setState(() {}); // 更新 UI（显示当前选中的 song）

    try {
      // 等待播放器进入 ready 或 buffering 状态
      _player.playbackEventStream
          .firstWhere(
            (event) =>
                event.processingState ==
                    ProcessingState.ready ||
                event.processingState ==
                    ProcessingState.buffering,
          )
          .then((_) {
            _player.play();
          });
    } catch (e) {
      await _player.play();
      // fallback：直接尝试播放
    }
  }

  // 打开MusicData页面，返回歌曲列表后更新songs
  // 打开导入音乐界面，只在用户点击导入按钮时调用
  Future<void> _openMusicDataPage() async {
    // ✅ 直接跳转，不预加载
    final result = await Get.to<List<Map<String, dynamic>>>(
      () => MusicLocalData(),
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
              path: map['path'] ?? '',
              lyrics:
                  map['lyrics'] is List<LyricLine>
                      ? map['lyrics']
                      : [],
            );
          }).toList();

      setState(() {
        songs = newSongs;
        selectedIndex = -1;
        selectedIsPlay = false;

        // 初始化歌词
        final rawLyrics = result[0]['lyrics'];
        if (rawLyrics is String) {
          _currentLyrics = _parseLyrics(rawLyrics);
        } else {
          _currentLyrics = [];
        }
      });
    }
  }

  Future<void> _loadMusicInHome() async {
    final music =
        await MusicLoader.loadLocalMusicWithPermission();

    final newSongs =
        music.map<Song>((map) {
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
            path: map['path'] ?? '',
            lyrics:
                map['lyrics'] is List<LyricLine>
                    ? map['lyrics']
                    : [],
          );
        }).toList();

    setState(() {
      songs = newSongs;
      selectedIndex = -1;
      selectedIsPlay = false;
      _currentLyrics = [];
    });
  }

  @override
  void initState() {
    super.initState();
    _loadMusicInHome(); // 👈 自动加载一次

    _player.playbackEventStream.listen((event) {
      if (event.processingState ==
          ProcessingState.completed) {
        Future.microtask(() => _onNextSong());
      } else if (event.processingState ==
              ProcessingState.ready ||
          event.processingState ==
              ProcessingState.buffering) {
        currentPosition = _player.position;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
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
              lyrics: _currentLyrics,
              onNextSongs: _onNextSong,
              onTogglePlay: _togglePlayState,
              onPreviousSongs: _onPreviousSong,
              imageBytes: selectedSong?.imageBytes,
              title: selectedSong?.title ?? '无音乐',
              positionStream: _player.positionStream,
              subTitle: selectedSong?.subtitle ?? '暂无播放',
              currentTime: formatDuration(currentPosition),
              lyricScrollController: lyricScrollController,
              lyricPositionListener: lyricPositionListener,
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
