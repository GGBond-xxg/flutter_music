part of '../quote.dart';

class TextstyleLyrics extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  const TextstyleLyrics({
    super.key,
    required this.text,
    required this.color,
    this.fontSize = 14.0,
    this.fontWeight = FontWeight.bold,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
      ),
    );
  }
}

class IconRowButton extends StatelessWidget {
  final Icon icon;
  final double size;
  final double paddingRight;
  final Color color;
  final void Function() onPressed;
  const IconRowButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.paddingRight,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: icon,
          onPressed: onPressed,
          color: color,
          iconSize: size,
        ),
        SizedBox(width: paddingRight),
      ],
    );
  }
}

class TouchListButton extends StatelessWidget {
  final void Function() onPressed;
  final Icon icon;
  final Color color;
  final String title;
  final String subtitle;
  final bool isSelected;
  final Uint8List? songImageBytes; // 改成 Uint8List? 类型
  final bool isShowSplash;
  final EdgeInsets padding;
  final List<Widget> rowListIconButtons;

  const TouchListButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    this.isSelected = false,
    this.songImageBytes,
    this.isShowSplash = false,
    required this.rowListIconButtons,
    this.padding = const EdgeInsets.all(8.0),
  });

  @override
  Widget build(BuildContext context) {
    double fangSize = 48.0;
    double size = MediaQuery.of(context).size.width * 0.89;
    InteractiveInkFeatureFactory noShow =
        NoSplash.splashFactory;
    InteractiveInkFeatureFactory showSF =
        InkRipple.splashFactory;
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        splashFactory: isShowSplash ? noShow : showSF,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        padding: padding,
      ),
      child: SizedBox(
        width: size,
        child: ListTile(
          contentPadding: EdgeInsets.only(
            left: 0,
            right: 0,
          ),
          enabled: isSelected,
          leading: Container(
            decoration: BoxDecoration(
              color: color.withAlpha(100),
              borderRadius: BorderRadius.circular(3.0),
            ),
            width: fangSize,
            height: fangSize,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3.0),
              child:
                  songImageBytes != null
                      ? Image.memory(
                        songImageBytes!,
                        width: fangSize,
                        height: fangSize,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                icon,
                      )
                      : Icon(AliIcon.iconDefault),
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: selectAndTextColor(context),
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              color: selectAndTextColor(context),
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [...rowListIconButtons],
          ),
        ),
      ),
    );
  }
}

// SliverAB
class SliverAB extends StatefulWidget {
  final String title;
  final Widget actionsWidget;
  final Widget leadingWidget;
  const SliverAB({
    super.key,
    required this.title,
    this.actionsWidget = const SizedBox(),
    this.leadingWidget = const SizedBox(),
  });

  @override
  State<SliverAB> createState() => _SliverABState();
}

class _SliverABState extends State<SliverAB> {
  int selectedIndex = -1;
  @override
  Widget build(BuildContext context) {
    Color bgColor = bodyBackgroundColor(context);
    return SliverAppBar(
      pinned: true,
      expandedHeight: 150.0,
      backgroundColor: bgColor,
      scrolledUnderElevation: 0.0,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsetsDirectional.only(
          start: 46,
          bottom: 12,
        ),
        title: Text(
          widget.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: selectAndTextColor(context),
          ),
        ),
      ),
      leading: widget.leadingWidget,
      actions: [widget.actionsWidget],
    );
  }
}

// NotImageListTile
class NotImageListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color bgcolor;
  final String subtitle;
  final Color titleColor;
  final bool isShowSplash;
  final Widget? widgetFlag;
  final Color subtitleColor;
  final VoidCallback onPressed;
  const NotImageListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.bgcolor,
    required this.subtitle,
    required this.titleColor,
    this.isShowSplash = false,
    required this.subtitleColor,
    required this.onPressed,
    this.widgetFlag,
  });

  @override
  Widget build(BuildContext context) {
    InteractiveInkFeatureFactory noShow =
        NoSplash.splashFactory;
    InteractiveInkFeatureFactory showSF =
        InkRipple.splashFactory;
    return TextButton(
      style: TextButton.styleFrom(
        splashFactory: isShowSplash ? noShow : showSF,
        backgroundColor: bgcolor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
      onPressed: onPressed,
      child: ListTile(
        leading: Icon(icon, color: titleColor, size: 24.0),
        title: Text(
          title,
          style: TextStyle(color: titleColor),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: subtitleColor),
        ),
        trailing: widgetFlag,
      ),
    );
  }
}

class MoreIconButton extends StatelessWidget {
  final Color color;
  final double iconSize;
  final IconData iconData;
  final VoidCallback onPressed;
  const MoreIconButton({
    super.key,
    required this.color,
    this.iconSize = 26.0,
    required this.iconData,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: ButtonStyle(
        splashFactory: InkRipple.splashFactory,
      ),
      onPressed: onPressed,
      icon: Icon(iconData, color: color, size: iconSize),
    );
  }
}

class Song {
  final String title;
  final String subtitle;
  final IconData icon;
  final Uint8List? imageBytes;
  final int duration;
  final String path;
  final List<LyricLine> lyrics; // 直接存 List<LyricLine>

  Song({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.imageBytes,
    required this.duration,
    required this.path,
    required this.lyrics,
  });
}

class LyricLine {
  final Duration time;
  final String text;

  const LyricLine({required this.time, required this.text});
}

// 把 "03:25" -> Duration(minutes: 3, seconds: 25)
Duration _parseDuration(String timeStr) {
  final parts = timeStr.split(':');
  if (parts.length != 2) return Duration.zero;

  final minutes = int.tryParse(parts[0]) ?? 0;
  final seconds = int.tryParse(parts[1]) ?? 0;

  return Duration(minutes: minutes, seconds: seconds);
}

// 把 Duration -> "03:25"
String _formatDuration(Duration duration) {
  final minutes = duration.inMinutes
      .remainder(60)
      .toString()
      .padLeft(2, '0');
  final seconds = duration.inSeconds
      .remainder(60)
      .toString()
      .padLeft(2, '0');
  return '$minutes:$seconds';
}
