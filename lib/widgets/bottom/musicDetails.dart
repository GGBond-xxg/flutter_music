part of '../../quote.dart';

class MusicDetails extends StatefulWidget {
  final bool isPlay;
  final String title;
  final String subTitle;
  final String currentTime;
  final String totalDuration;
  final Uint8List? imageBytes;
  final List<LyricLine> lyrics;
  final VoidCallback onNextSongs;
  final VoidCallback onTogglePlay;
  final VoidCallback onPreviousSongs;
  final Stream<Duration> positionStream;
  final ItemScrollController lyricScrollController;
  final ItemPositionsListener lyricPositionListener;
  const MusicDetails({
    super.key,
    required this.title,
    required this.isPlay,
    required this.lyrics,
    required this.subTitle,
    required this.imageBytes,
    required this.onNextSongs,
    required this.currentTime,
    required this.onTogglePlay,
    required this.totalDuration,
    required this.positionStream,
    required this.onPreviousSongs,
    required this.lyricScrollController,
    required this.lyricPositionListener,
  });

  @override
  State<MusicDetails> createState() => _MusicDetailsState();
}

class _MusicDetailsState extends State<MusicDetails> {
  int alignIndex = 0; // 当前对齐方式索引

  final List<TextAlign> alignments = [
    TextAlign.left,
    TextAlign.center,
    TextAlign.right,
  ];

  final List<IconData> alignIcons = [
    AliIcon.iconLeft,
    AliIcon.iconCenter,
    AliIcon.iconRight,
  ];

  void changeAlignment() {
    alignIndex = (alignIndex + 1) % alignments.length;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = bodyBackgroundColor(context);
    Color color = selectAndTextColor(context);
    double size = MediaQuery.of(context).size.width * 0.85;
    double iconSize = 50.0;
    double iconMarginSize =
        MediaQuery.of(context).size.width * 0.08;
    // 歌词对齐相关变量

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: size,
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.all(0.0),
                  title: TextstyleLyrics(
                    color: color,
                    fontSize: 25.0,
                    text: widget.title,
                    fontWeight: FontWeight.bold,
                  ),
                  subtitle: TextstyleLyrics(
                    color: color.withAlpha(400),
                    fontSize: 15.0,
                    text: widget.subTitle,
                    fontWeight: FontWeight.bold,
                  ),
                  trailing: MoreIconButton(
                    color: color,
                    iconData: AliIcon.iconSound,
                    onPressed: () {},
                  ),
                ),
                Container(
                  height: size,
                  width: size,
                  decoration: BoxDecoration(
                    color: color.withAlpha(100),
                    borderRadius: BorderRadius.circular(
                      10.0,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      8.0,
                    ),
                    child:
                        widget.imageBytes != null
                            ? Image.memory(
                              widget.imageBytes!,
                              fit: BoxFit.cover,
                            )
                            : Icon(
                              AliIcon.iconDefault,
                              color: color,
                              size: 80,
                            ),
                  ),
                ),

                /// 歌词滚动显示区域
                SizedBox(
                  height: 100,
                  child: LyricList(
                    lyrics: widget.lyrics,
                    normalColor: color,
                    highlightColor: color,
                    textAlign: alignments[alignIndex],
                    positionStream: widget.positionStream,
                    lyricScrollController:
                        widget.lyricScrollController,
                    lyricPositionListener:
                        widget.lyricPositionListener,
                  ),
                ),

                // 播放进度与控制
                StreamBuilder<Duration>(
                  stream: widget.positionStream,
                  builder: (context, snapshot) {
                    final position =
                        snapshot.data ?? Duration.zero;

                    // 解析 totalDuration（String -> Duration）
                    final total = _parseDuration(
                      widget.totalDuration,
                    );
                    double progress = 0.0;

                    if (total.inMilliseconds > 0) {
                      progress =
                          position.inMilliseconds /
                          total.inMilliseconds;
                      if (progress > 1.0) progress = 1.0;
                    }

                    return Column(
                      children: [
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: color.withAlpha(
                            50,
                          ),
                          valueColor:
                              AlwaysStoppedAnimation<Color>(
                                color,
                              ),
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                          children: [
                            TextstyleLyrics(
                              text: _formatDuration(
                                position,
                              ),
                              color: color,
                              fontWeight: FontWeight.normal,
                            ),
                            TextstyleLyrics(
                              text: widget.totalDuration,
                              color: color,
                              fontWeight: FontWeight.normal,
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),

                // 播放控制按钮
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    MoreIconButton(
                      color: color,
                      iconSize: iconSize,
                      iconData: AliIcon.iconPrevious,
                      onPressed: widget.onPreviousSongs,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: iconMarginSize,
                      ),
                      child: MoreIconButton(
                        color: color,
                        iconSize: iconSize,
                        iconData:
                            widget.isPlay
                                ? AliIcon.iconPaused
                                : AliIcon.iconPlay,
                        onPressed: widget.onTogglePlay,
                      ),
                    ),
                    MoreIconButton(
                      color: color,
                      iconSize: iconSize,
                      iconData: AliIcon.iconNext,
                      onPressed: widget.onNextSongs,
                    ),
                  ],
                ),

                // 底部按钮区
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                  children: [
                    MoreIconButton(
                      color: color,
                      iconData: AliIcon.iconlyrics,
                      onPressed: () {},
                    ),
                    MoreIconButton(
                      color: color,
                      iconData: AliIcon.iconListRepeat,
                      onPressed: () {},
                    ),
                    MoreIconButton(
                      color: color,
                      iconData: AliIcon.iconTimer,
                      onPressed: () {},
                    ),
                    MoreIconButton(
                      color: color,
                      iconData: alignIcons[alignIndex],
                      onPressed: () {
                        changeAlignment();
                      },
                    ),
                    MoreIconButton(
                      color: color,
                      iconData: AliIcon.iconPlayList,
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
