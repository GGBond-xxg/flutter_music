part of '../../quote.dart';

class MusicData extends StatefulWidget {
  final Future<void> Function()? onImportMusic;
  const MusicData({super.key, this.onImportMusic});

  @override
  State<MusicData> createState() => _MusicDataState();
}

class _MusicDataState extends State<MusicData> {
  @override
  Widget build(BuildContext context) {
    Color bgColor = bodyBackgroundColor(context);
    Color color = selectAndTextColor(context);

    final List<Widget> musicDataPages = [
      const MusicLocalData(),
    ];

    return Container(
      color: bgColor,
      height: double.infinity,
      child: CustomScrollView(
        slivers: [
          SliverAB(
            title: '音乐源',
            leadingWidget: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(AliIcon.iconBlack, color: color),
            ),
          ),
          SettingSliverList(
            isDivider: false,
            sliverListLength: settingMusicList.length,
            itemBuilder: (context, index) {
              final settingMusic = settingMusicList[index];
              IconData icon = settingMusic.icon;
              String title = settingMusic.title;
              String subtitle = settingMusic.subtitle;
              return NotImageListTile(
                icon: icon,
                title: title,
                bgcolor: bgColor,
                titleColor: color,
                subtitle: subtitle,
                subtitleColor: color,
                onPressed: () async {
                  await widget.onImportMusic?.call();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
