part of '../../quote.dart';

class SettingPage extends StatefulWidget {
  final void Function() onTapSun;
  final void Function() onTapMoon;
  final ThemeMode currentThemeMode;
  final void Function() onTapSystem;
  const SettingPage({
    super.key,
    required this.onTapSun,
    required this.onTapMoon,
    required this.onTapSystem,
    required this.currentThemeMode,
  });

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    final currentThemeMode = widget.currentThemeMode;
    final List<Widget> settingOptionsList = [
      MusicData(),
      ChangMode(
        onTapSun: widget.onTapSun,
        onTapMoon: widget.onTapMoon,
        onTapSystem: widget.onTapSystem,
        currentThemeMode: currentThemeMode,
      ),
    ];
    var bgColor = bodyBackgroundColor(context);
    var color = selectAndTextColor(context);

    return Container(
      color: bgColor,
      height: double.infinity,
      child: CustomScrollView(
        slivers: [
          SliverAB(
            title: '设置',
            leadingWidget: IconButton(
              onPressed: Get.back,
              icon: Icon(AliIcon.iconBlack, color: color),
            ),
          ),
          SettingSliverList(
            isDivider: false,
            sliverListLength: settingList.length,
            itemBuilder: (context, index) {
              var settingItem = settingList[index];
              var icon = settingItem.icon;
              var title = settingItem.title;
              var subtitle = settingItem.subtitle;

              if (index == settingList.length - 1) {
                subtitle =
                    '现在的主题是${isSunText(context)}的，进入切换主题';
                icon = isSunIcon(context);
              }
              return NotImageListTile(
                icon: icon,
                title: title,
                subtitle: subtitle,
                titleColor: color,
                subtitleColor: color,
                onPressed: () {
                  Get.to(
                    () => settingOptionsList[index],
                    transition: Transition.cupertino,
                    duration: Duration(milliseconds: 300),
                  );
                  setState(() {});
                },
                bgcolor: bgColor,
                widgetFlag: Icon(
                  Icons.arrow_forward_ios,
                  color: color,
                  size: 20.0,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
