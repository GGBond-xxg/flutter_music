part of '../../quote.dart';

class MusicDetails extends StatelessWidget {
  final bool isPlay;
  final String title;
  final String subTitle;
  final String currentTime;
  final String totalDuration;
  final Uint8List? imageBytes;
  final VoidCallback onNextSongs;
  final VoidCallback onTogglePlay;
  final VoidCallback onPreviousSongs;
  const MusicDetails({
    super.key,
    required this.title,
    required this.isPlay,
    required this.subTitle,
    required this.imageBytes, // ✅ 改这里
    required this.onNextSongs,
    required this.currentTime,
    required this.onTogglePlay,
    required this.totalDuration,
    required this.onPreviousSongs,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor = bodyBackgroundColor(context);
    Color color = selectAndTextColor(context);
    double size = MediaQuery.of(context).size.width * 0.85;
    double iconSize = 50.0;
    double iconMarginSize =
        MediaQuery.of(context).size.width * 0.08;
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
                  contentPadding: EdgeInsets.only(
                    left: 0.0,
                    right: 0.0,
                  ),
                  title: Text(
                    title,
                    style: TextStyle(
                      color: color,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    subTitle,
                    style: TextStyle(
                      fontSize: 15.0,
                      color: color.withAlpha(400),
                      fontWeight: FontWeight.bold,
                    ),
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
                        imageBytes != null
                            ? Image.memory(
                              imageBytes!,
                              fit: BoxFit.cover,
                            )
                            : Icon(
                              AliIcon.iconDefault,
                              color: color,
                              size: 80,
                            ),
                  ),
                ),
                Container(
                  width: size,
                  color: bgColor,
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      TextstyleLyrics(
                        text: '今天我寒夜裏看雪飄過',
                        color: color.withAlpha(900),
                      ),
                      TextstyleLyrics(
                        text: '懷著冷卻了的心窩漂遠方',
                        color: color,
                      ),
                      TextstyleLyrics(
                        text: '風雨裏追趕 霧裏分不清影蹤',
                        color: color.withAlpha(900),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    LinearProgressIndicator(
                      value: 0.01, // 0.0 到 1.0
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        TextstyleLyrics(
                          text: currentTime,
                          color: color,
                          fontWeight: FontWeight.normal,
                        ),
                        TextstyleLyrics(
                          text: totalDuration,
                          color: color,
                          fontWeight: FontWeight.normal,
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                  ],
                ),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    MoreIconButton(
                      color: color,
                      iconSize: iconSize,
                      iconData: AliIcon.iconPrevious,
                      onPressed: () {
                        onPreviousSongs();
                      },
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: iconMarginSize,
                        right: iconMarginSize,
                      ),
                      child: MoreIconButton(
                        color: color,
                        iconSize: iconSize,
                        iconData:
                            isPlay
                                ? AliIcon.iconPaused
                                : AliIcon.iconPlay,
                        onPressed: () {
                          onTogglePlay();
                        },
                      ),
                    ),
                    MoreIconButton(
                      color: color,
                      iconSize: iconSize,
                      iconData: AliIcon.iconNext,
                      onPressed: () {
                        onNextSongs();
                      },
                    ),
                  ],
                ),
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
                      iconData: AliIcon.iconHSound,
                      onPressed: () {},
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
