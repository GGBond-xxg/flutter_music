part of '../../quote.dart';

class ChangMode extends StatefulWidget {
  final void Function() onTapSun;
  final void Function() onTapMoon;
  final void Function() onTapSystem;
  final ThemeMode currentThemeMode;
  const ChangMode({
    super.key,
    required this.onTapSun,
    required this.onTapMoon,
    required this.onTapSystem,
    required this.currentThemeMode,
  });

  @override
  State<ChangMode> createState() => _ChangModeState();
}

class _ChangModeState extends State<ChangMode> {
  String radioModel = 'sun';
  _onChangTheme(String value) {
    if (value == 'sun') {
      widget.onTapSun();
    } else if (value == 'moon') {
      widget.onTapMoon();
    } else {
      widget.onTapSystem();
    }
    radioModel = value;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    switch (widget.currentThemeMode) {
      case ThemeMode.light:
        radioModel = 'sun';
        break;
      case ThemeMode.dark:
        radioModel = 'moon';
        break;
      case ThemeMode.system:
        radioModel = 'system';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = bodyBackgroundColor(context);
    Color color = selectAndTextColor(context);
    return Container(
      color: bgColor,
      height: double.infinity,
      child: CustomScrollView(
        slivers: [
          SliverAB(
            title: '主题',
            leadingWidget: IconButton(
              onPressed: Get.back,
              icon: Icon(AliIcon.iconBlack, color: color),
            ),
          ),
          SettingSliverList(
            isDivider: false,
            sliverListLength: settingChangList.length,
            itemBuilder: (context, index) {
              var changModel = settingChangList[index];
              var icon = changModel.icon;
              var title = changModel.title;
              var subtitle = changModel.subtitle;
              var radioValue = changModel.radioValue;
              return NotImageListTile(
                icon: icon,
                title: title,
                bgcolor: bgColor,
                titleColor: color,
                subtitle: subtitle,
                subtitleColor: color,
                onPressed: () {
                  _onChangTheme(radioValue);
                  setState(() {});
                },
                widgetFlag: Radio(
                  value: radioValue,
                  groupValue: radioModel,
                  onChanged: (value) {
                    _onChangTheme(radioValue);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
