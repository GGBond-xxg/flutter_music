part of '../../quote.dart';

class TextstyleLyrics extends StatelessWidget {
  final String text;
  final Color color;
  final FontWeight fontWeight;
  const TextstyleLyrics({
    super.key,
    required this.text,
    required this.color,
    this.fontWeight = FontWeight.bold,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        color: color,
        fontWeight: fontWeight,
      ),
    );
  }
}
