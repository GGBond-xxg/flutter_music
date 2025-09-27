part of '../../quote.dart';

class SettingSliverList extends StatelessWidget {
  final bool isDivider;
  final Color dividerColor;
  final int sliverListLength;
  final Widget Function(BuildContext, int) itemBuilder;
  const SettingSliverList({
    super.key,
    this.isDivider = true,
    this.dividerColor = Colors.transparent,
    required this.sliverListLength,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      itemBuilder: itemBuilder,
      separatorBuilder: (context, index) {
        return isDivider
            ? Divider(height: 1, color: dividerColor)
            : SizedBox();
      },
      itemCount: sliverListLength,
    );
  }
}
