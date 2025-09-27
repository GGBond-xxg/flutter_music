part of '../../quote.dart';

class MusicData extends StatefulWidget {
  const MusicData({super.key});

  @override
  State<MusicData> createState() => _MusicDataState();
}

class _MusicDataState extends State<MusicData> {
  void _checkPermission() async {
    bool granted =
        await PermissionUtils.requestStoragePermission();

    if (!granted) {
      bool permanentlyDenied =
          await PermissionUtils.isPermanentlyDenied();

      if (permanentlyDenied) {
        _showPermissionDialog(); // 引导用户手动去设置权限
      } else {
        // 用户刚刚拒绝了权限（但没选“不再询问”），你也可以选择提醒或什么都不做
        // 可以弹 Toast 告诉用户必须允许权限
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('请允许访问存储以加载本地音乐')),
        );
      }
    } else {
      // 权限已获得，执行后续操作
      debugPrint("权限已获得，继续读取文件");
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
                  Navigator.of(context).pop();
                  openAppSettings(); // 打开系统设置页
                },
                child: const Text("去设置"),
              ),
              TextButton(
                onPressed:
                    () => Navigator.of(context).pop(),
                child: const Text("取消"),
              ),
            ],
          ),
    );
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
                onPressed: () {
                  _checkPermission();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
