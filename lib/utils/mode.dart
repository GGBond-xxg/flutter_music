part of '../quote.dart';

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
  final String songImage;
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
    required this.songImage,
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
        backgroundColor: transparent,
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
              // border: Border.all(color: color, width: 1.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            width: fangSize,
            height: fangSize,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                songImage,
                width: fangSize,
                height: fangSize,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => icon,
              ),
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
  final String imagePath;

  Song({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.imagePath,
  });

  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      title: map['title'] ?? '未知标题',
      subtitle: map['artist'] ?? '未知艺术家',
      icon: Icons.music_note, // 简单默认图标
      imagePath: map['imagePath'] ?? '',
    );
  }
}
