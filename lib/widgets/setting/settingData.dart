part of '../../quote.dart';

class MusicData extends StatefulWidget {
  const MusicData({super.key});

  @override
  State<MusicData> createState() => _MusicDataState();
}

class _MusicDataState extends State<MusicData> {
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
            title: '音乐源',
            leadingWidget: IconButton(
              onPressed: Get.back,
              icon: Icon(AliIcon.iconBlack, color: color),
            ),
          ),
          SettingSliverList(
            isDivider: false,
            sliverListLength: settingMusicList.length,
            itemBuilder: (context, index) {
              var data = settingMusicList[index];
              var icon = data.icon;
              var title = data.title;
              var subtitle = data.subtitle;
              return NotImageListTile(
                icon: icon,
                title: title,
                bgcolor: bgColor,
                titleColor: color,
                subtitle: subtitle,
                subtitleColor: color,
                onPressed: () {},
              );
            },
          ),
        ],
      ),
    );
  }
}
