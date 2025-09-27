part of '../../quote.dart';

class SettingItem {
  final IconData icon;
  final String title;
  final String subtitle;

  const SettingItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

final List<SettingItem> settingList = [
  SettingItem(
    icon: AliIcon.iconStorage,
    title: '音乐源',
    subtitle: '设置音乐源，本地存储或Nas存储',
  ),
  SettingItem(
    icon: AliIcon.iconSun,
    title: '主题',
    subtitle: '现在的主题是白色的，进入切换主题',
  ),
];
final IconData sunIcon = AliIcon.iconSun;
final IconData moonIcon = AliIcon.iconMoon;

isNight(BuildContext context, sun, moon) {
  final isDart =
      Theme.of(context).brightness == Brightness.dark;
  var isNight = isDart == false ? sun : moon;
  return isNight;
}

isSunText(BuildContext context) {
  return isNight(context, '白色', '黑色');
}

isSunIcon(BuildContext context) {
  return isNight(context, sunIcon, moonIcon);
}

class SettingChangModel {
  final IconData icon;
  final String title;
  final String subtitle;
  final String radioValue;
  const SettingChangModel({
    required this.subtitle,
    required this.icon,
    required this.title,
    required this.radioValue,
  });
}

final List<SettingChangModel> settingChangList = [
  SettingChangModel(
    icon: AliIcon.iconSun,
    title: '白天模式',
    subtitle: '主动切换白天模式',
    radioValue: 'sun',
  ),
  SettingChangModel(
    icon: AliIcon.iconMoon,
    title: '夜间模式',
    subtitle: '主动切换夜间模式',
    radioValue: 'moon',
  ),
  SettingChangModel(
    icon: AliIcon.iconSetting,
    title: '跟随系统',
    subtitle: '跟随手机系统的夜间模式',
    radioValue: 'system',
  ),
];

class SettingMusicData {
  final IconData icon;
  final String title;
  final String subtitle;
  const SettingMusicData({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

final List<SettingMusicData> settingMusicList = [
  SettingMusicData(
    icon: AliIcon.iconLocal,
    title: '本地音乐',
    subtitle: '本地存储的音乐',
  ),
  SettingMusicData(
    icon: AliIcon.iconCloud,
    title: 'Nas云音乐',
    subtitle: '云存储的音乐',
  ),
];
