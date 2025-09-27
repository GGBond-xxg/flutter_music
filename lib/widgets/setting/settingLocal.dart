part of '../../quote.dart';

class MusicLocalData extends StatefulWidget {
  const MusicLocalData({super.key});

  @override
  State<MusicLocalData> createState() =>
      _MusicLocalDataState();
}

class _MusicLocalDataState extends State<MusicLocalData> {
  List<Map<String, dynamic>> _musicList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMusic();
  }

  Future<void> _loadMusic() async {
    try {
      final music =
          await MusicLoader.loadLocalMusicWithPermission();
      setState(() {
        _musicList = music;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = bodyBackgroundColor(context);
    Color color = selectAndTextColor(context);
    return Scaffold(
      body: Container(
        color: bgColor,
        height: double.infinity,
        child:
            _isLoading
                ? const Center(
                  child: CircularProgressIndicator(),
                )
                : CustomScrollView(
                  slivers: [
                    SliverAB(
                      title: '导入音乐',
                      leadingWidget: IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(
                          AliIcon.iconBlack,
                          color: color,
                        ),
                      ),
                    ),
                    SettingSliverList(
                      isDivider: false,
                      sliverListLength: _musicList.length,
                      itemBuilder: (context, index) {
                        final song = _musicList[index];
                        return NotImageListTile(
                          title: song['title'],
                          subtitle: song['artist'],
                          icon: AliIcon.iconLocal,
                          bgcolor: bgColor,
                          titleColor: color,
                          subtitleColor: color,
                          onPressed: () {},
                        );
                      },
                    ),
                  ],
                ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: bgColor,
            splashFactory: NoSplash.splashFactory,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero, // 去掉圆角
              side: BorderSide.none, // 去掉边框
            ),
          ),
          onPressed: () {
            // 返回导入的音乐列表给上一页
            Get.back(result: _musicList);
          },
          child: Text('确认导入 ${_musicList.length} 首音乐'),
        ),
      ),
    );
  }
}
