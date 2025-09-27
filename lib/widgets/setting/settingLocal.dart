part of '../../quote.dart';

class MusicLocalData extends StatefulWidget {
  const MusicLocalData({super.key});

  @override
  State<MusicLocalData> createState() =>
      _MusicLocalDataState();
}

class _MusicLocalDataState extends State<MusicLocalData> {
  List<Map<String, dynamic>> _musicList = [];
  bool _isLoading = false;

  Future<void> _loadMusic() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 假设 MusicLoader.loadLocalMusicWithPermission 会请求权限并加载音乐
      final musicList =
          await MusicLoader.loadLocalMusicWithPermission();

      setState(() {
        _musicList = musicList;
        _isLoading = false;
      });

      debugPrint("音乐加载成功，共 ${musicList.length} 首");
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      // 检查是否被永久拒绝权限
      final permanentlyDenied =
          await MusicLoader.isPermanentlyDenied();

      if (permanentlyDenied) {
        _showPermissionDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('请允许访问存储以加载本地音乐')),
        );
      }
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("权限请求"),
            content: const Text(
              "应用需要访问你的本地音乐文件，请在系统设置中手动授权存储权限。",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                  openAppSettings(); // 打开系统设置页面
                },
                child: const Text("去设置"),
              ),
              TextButton(
                onPressed: () => Get.back(),
                child: const Text("取消"),
              ),
            ],
          ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadMusic();
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = bodyBackgroundColor(context);
    Color color = selectAndTextColor(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('本地音乐', style: TextStyle(color: color)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: color),
          onPressed: () => Get.back(), // 返回空数据取消加载
        ),
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: color),
      ),
      backgroundColor: bgColor,
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(),
              )
              : _musicList.isEmpty
              ? Center(
                child: Text(
                  '没有加载到音乐',
                  style: TextStyle(
                    color: color,
                    fontSize: 16,
                  ),
                ),
              )
              : ListView.builder(
                itemCount: _musicList.length,
                itemBuilder: (context, index) {
                  final song = _musicList[index];
                  return ListTile(
                    title: Text(
                      song['title'] ?? '未知标题',
                      style: TextStyle(color: color),
                    ),
                    subtitle: Text(
                      song['artist'] ?? '未知艺术家',
                      style: TextStyle(
                        color: color.withOpacity(0.7),
                      ),
                    ),
                  );
                },
              ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton(
          onPressed:
              _musicList.isNotEmpty
                  ? () {
                    Get.back(
                      result: _musicList,
                    ); // 返回音乐数据给上一页
                  }
                  : null,
          child: Text('确认导入 ${_musicList.length} 首音乐'),
        ),
      ),
    );
  }
}
