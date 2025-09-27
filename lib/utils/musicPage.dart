part of '../quote.dart';

class MusicPage extends StatefulWidget {
  const MusicPage({super.key});

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  List<Song> songs = [];
  int selectedIndex = 0;

  Future<void> _importMusic() async {
    final result = await Get.to<List<Map<String, dynamic>>>(
      () => MusicLocalData(),
    );
    if (result != null && result.isNotEmpty) {
      final importedSongs =
          result.map((e) => Song.fromMap(e)).toList();
      setState(() {
        songs = importedSongs;
        selectedIndex = 0;
      });
    }
  }

  void _onBackPressed(
    String title,
    String subtitle,
    IconData icon,
    bool isPlaying,
    String songImage,
    int selectedIndex,
  ) {
    setState(() {
      this.selectedIndex = selectedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('音乐主页'),
        actions: [
          IconButton(
            icon: const Icon(Icons.import_contacts),
            onPressed: _importMusic,
          ),
        ],
      ),
      body: BodyWidget(
        songs: songs,
        selectedIndex: selectedIndex,
        onBackPressed: _onBackPressed,
      ),
    );
  }
}
