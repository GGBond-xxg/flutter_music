part of '../../quote.dart';

class BottomShow extends StatelessWidget {
  final int index;
  final bool isPlay;
  final String title;
  final IconData icon;
  final String subTitle;
  final String songImage;
  final VoidCallback nextSong;
  final VoidCallback onTogglePlay;
  final PanelController panelController;

  const BottomShow({
    super.key,
    required this.icon,
    required this.index,
    required this.title,
    required this.isPlay,
    required this.subTitle,
    required this.nextSong,
    required this.songImage,
    required this.onTogglePlay,
    required this.panelController,
  });

  @override
  Widget build(BuildContext context) {
    Color color = selectAndTextColor(context);
    Color bgColor = bodyBackgroundColor(context);
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          top: BorderSide(
            color: color.withAlpha(100),
            width: 0.5,
          ),
        ),
      ),
      child: TouchListButton(
        icon: Icon(icon, color: color),
        color: color,
        onPressed: () {
          panelController.open();
          // 用传入的 controller
        },
        padding: EdgeInsets.only(
          right: 8.0,
          left: 8.0,
          top: 4.0,
          bottom: 4.0,
        ),
        title: title,
        subtitle: subTitle,
        songImage: songImage,
        rowListIconButtons: [
          MoreIconButton(
            color: color,
            iconSize: 28.0,
            iconData:
                isPlay
                    ? AliIcon.iconPaused
                    : AliIcon.iconPlay,
            onPressed: () {
              onTogglePlay();
            },
          ),
          MoreIconButton(
            color: color,
            iconSize: 28.0,
            iconData: AliIcon.iconNext,
            onPressed: () {
              nextSong();
            },
          ),
        ],
      ),
    );
  }
}
