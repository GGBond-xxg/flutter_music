part of '../../quote.dart';

class MusicLocalData extends StatefulWidget {
  const MusicLocalData({super.key});

  @override
  State<MusicLocalData> createState() =>
      _MusicLocalDataState();
}

class _MusicLocalDataState extends State<MusicLocalData> {
  final List<Map<String, dynamic>> _musicList = [
    {'title': '歌曲A', 'artist': '艺术家A', 'imagePath': ''},
    {'title': '歌曲B', 'artist': '艺术家B', 'imagePath': ''},
  ]; // 假数据演示

  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('导入音乐')),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(),
              )
              : ListView.builder(
                itemCount: _musicList.length,
                itemBuilder: (context, index) {
                  final song = _musicList[index];
                  return ListTile(
                    title: Text(song['title']),
                    subtitle: Text(song['artist']),
                  );
                },
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
