part of '../quote.dart';

// DiyIcon for AliIconfont
class AliIcon {
  static IconData fontIcon(int codeIcon) {
    return IconData(codeIcon, fontFamily: 'AliIconfont');
  }

  static IconData iconPlay = fontIcon(0xe667); // 播放按钮
  static IconData iconPaused = fontIcon(0xe662); // 播放暂停
  static IconData iconNext = fontIcon(0xe63b); // 下一首
  static IconData iconPrevious = fontIcon(0xe63a); // 上一首
  static IconData iconlyrics = fontIcon(0xe855); // 歌词
  static IconData iconClose = fontIcon(0xe601); // 关闭
  static IconData iconStorage = fontIcon(0xea5f); // 存储
  static IconData iconCloud = fontIcon(0xe603); // 云存储
  static IconData iconLocal = fontIcon(0xe609); // 本地存储
  static IconData iconPlayList = fontIcon(0xe716); // 播放列表
  static IconData iconAddList = fontIcon(0xe86a); // 添加播放列表
  static IconData iconShuffle = fontIcon(0xe6a0); // 随机播放
  static IconData iconRepeat = fontIcon(0xe6a2); // 单曲循环
  static IconData iconListRepeat = fontIcon(0xe6a3); // 列表循环
  static IconData iconSetting = fontIcon(0xe60f); // 设置
  static IconData iconMore = fontIcon(0xe600); // 更多
  static IconData iconBlack = fontIcon(0xe61d); // 返回
  static IconData iconDefault = fontIcon(0xe60d); // 默认图片
  static IconData iconPlaying = fontIcon(0xe61c); // 播放中
  static IconData iconNull = fontIcon(0xe000); // 无图标
  static IconData iconSun = fontIcon(0xe602); // 太阳
  static IconData iconMoon = fontIcon(0xe62e); // 月亮
  static IconData iconSound = fontIcon(0xe654); // 声源切换
  static IconData iconTimer = fontIcon(0xe721); // 定时器
  static IconData iconLeft = fontIcon(0xe854); // 靠左
  static IconData iconCenter = fontIcon(0xe852); // 剧中
  static IconData iconRight = fontIcon(0xe853); // 靠右
}

// DefaultColors
// DefaultWhiteColors
// const Color defaultWhiteBodyColor = Color(0xFFffffff);
// const Color defaultWhiteSelectColor = Color(0xFF465359);
// DefaultBlackColors
// const Color defaultBlackBodyColor = Color(0xFF011d27);
// const Color defaultBlackSelectColor = Color(0xFFbfdbf7);

// ChangColorMore
// isNightMode(BuildContext context, white, black) {
//   final isDart =
//       Theme.of(context).brightness == Brightness.dark;
//   var bgColor = isDart ? black : white;
//   return bgColor;
// }

// Brightness titleFontColor(BuildContext context) {
//   return isNightMode(
//     context,
//     Brightness.dark,
//     Brightness.light,
//   );
// }

// Color defaultBodyBackgroundColor(BuildContext context) {
//   return isNightMode(
//     context,
//     defaultWhiteBodyColor,
//     defaultBlackBodyColor,
//   );
// }

// Color defaultSelectAndTextColor(BuildContext context) {
//   return isNightMode(
//     context,
//     defaultWhiteSelectColor,
//     defaultBlackSelectColor,
//   );
// }

Color bodyBackgroundColor(BuildContext context) {
  return Theme.of(context).colorScheme.surface;
}

Color selectAndTextColor(BuildContext context) {
  return Theme.of(context).colorScheme.primary;
}

const Color transparent = Colors.transparent;
