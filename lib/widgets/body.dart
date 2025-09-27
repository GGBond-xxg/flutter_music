part of '../quote.dart';

class BodyWidget extends StatefulWidget {
  final int selectedIndex;
  final List<Song> songs;
  final void Function(
    String title,
    String subtitle,
    IconData icon,
    bool isPlaying,
    String songImage,
    int selectedIndex,
  )
  onBackPressed;

  const BodyWidget({
    super.key,
    required this.onBackPressed,
    required this.selectedIndex,
    required this.songs,
  });

  @override
  State<BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  double iconSize = 20.0;

  @override
  Widget build(BuildContext context) {
    Color bgColor = bodyBackgroundColor(context);
    Color color = selectAndTextColor(context);

    return Container(
      color: bgColor,
      height: double.infinity,
      padding: EdgeInsets.only(bottom: 85),
      child: CustomScrollView(
        slivers: [
          SliverAB(
            title: '音乐',
            actionsWidget: IconRowButton(
              icon: Icon(AliIcon.iconSetting, color: color),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              paddingRight: 16,
              color: color,
              size: 24.0,
            ),
          ),
          SettingSliverList(
            isDivider: false,
            sliverListLength: widget.songs.length,
            itemBuilder: (context, index) {
              final Song song = widget.songs[index];
              return Container(
                color: bgColor,
                child: TouchListButton(
                  color: color,
                  onPressed: () {
                    widget.onBackPressed(
                      song.title,
                      song.subtitle,
                      song.icon,
                      true,
                      song.imagePath,
                      index,
                    );
                    setState(() {});
                  },
                  icon: Icon(
                    AliIcon.iconDefault,
                    color: color,
                    size: iconSize,
                  ),
                  title: song.title,
                  subtitle: song.subtitle,
                  isSelected: widget.selectedIndex == index,
                  songImage: song.imagePath,
                  rowListIconButtons: [
                    widget.selectedIndex == index
                        ? Icon(
                          AliIcon.iconPlaying,
                          color: color,
                          size: iconSize,
                        )
                        : SizedBox(),
                    MoreIconButton(
                      color: color,
                      iconSize: iconSize,
                      iconData: AliIcon.iconMore,
                      onPressed: () {},
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
