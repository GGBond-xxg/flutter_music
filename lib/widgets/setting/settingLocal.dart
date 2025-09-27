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
      print("加载本地音乐失败: $e");
      // 可以考虑给用户提示权限或者失败原因
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
                        return ListTile(
                          title: Text(song['title']),
                          subtitle: Text(song['artist']),
                        );
                      },
                    ),
                  ],
                ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton(
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
