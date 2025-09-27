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
      padding: const EdgeInsets.only(bottom: 85),
      child: CustomScrollView(
        slivers: [
          // 这里用SliverAppBar或你自己的SliverAB
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
          SliverList(
            delegate: SliverChildBuilderDelegate((
              context,
              index,
            ) {
              final song = widget.songs[index];
              return ListTile(
                leading: Icon(
                  Icons.music_note,
                  color: color,
                  size: iconSize,
                ),
                title: Text(
                  song.title,
                  style: TextStyle(color: color),
                ),
                subtitle: Text(
                  song.subtitle,
                  style: TextStyle(
                    color: color.withOpacity(0.7),
                  ),
                ),
                selected: widget.selectedIndex == index,
                onTap: () {
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
              );
            }, childCount: widget.songs.length),
          ),
        ],
      ),
    );
  }
}
