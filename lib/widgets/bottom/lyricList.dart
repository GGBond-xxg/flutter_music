part of '../../quote.dart';

class LyricList extends StatefulWidget {
  final List<LyricLine> lyrics;
  final Stream<Duration> positionStream;
  final ItemScrollController lyricScrollController;
  final ItemPositionsListener lyricPositionListener;
  final Color highlightColor;
  final Color normalColor;
  final TextAlign textAlign;
  const LyricList({
    super.key,
    required this.lyrics,
    required this.positionStream,
    required this.lyricScrollController,
    required this.lyricPositionListener,
    required this.highlightColor,
    required this.normalColor,
    this.textAlign = TextAlign.left,
  });

  @override
  State<LyricList> createState() => _LyricListState();
}

class _LyricListState extends State<LyricList> {
  int _lastIndex = -1;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: widget.positionStream,
      builder: (context, snapshot) {
        final position = snapshot.data ?? Duration.zero;

        final currentIndex = widget.lyrics.lastIndexWhere(
          (line) => line.time <= position,
        );

        // 如果 currentIndex 变了，才滚动
        if (currentIndex != -1 &&
            currentIndex != _lastIndex &&
            widget.lyricScrollController.isAttached) {
          _lastIndex = currentIndex;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.lyricScrollController.scrollTo(
              index: currentIndex,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: 0.3,
            );
          });
        }

        return ScrollablePositionedList.builder(
          itemCount: widget.lyrics.length,
          itemScrollController:
              widget.lyricScrollController,
          itemPositionsListener:
              widget.lyricPositionListener,
          itemBuilder: (context, index) {
            final line = widget.lyrics[index];
            final isCurrent = index == currentIndex;

            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4.0,
              ),
              child: Text(
                line.text,
                textAlign: widget.textAlign,
                style: TextStyle(
                  color:
                      isCurrent
                          ? widget.highlightColor
                          : widget.normalColor.withAlpha(
                            100,
                          ),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
