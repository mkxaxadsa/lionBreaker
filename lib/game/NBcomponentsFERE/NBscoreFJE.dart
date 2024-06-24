import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class NBScoreFJJ extends Component {
  final Size nbsize;
  final Vector2 nbposition;
  String nbscoreText;

  final Paint _backgroundPaint = Paint()..color = Colors.red;
  late TextStyle _textStyle;

  NBScoreFJJ({
    required this.nbsize,
    required Vector2 nbposition,
    required int nbscore,
  })  : nbposition = nbposition.clone(),
        nbscoreText = nbscore.toString(),
        super() {
    _textStyle = TextStyle(
      color: Colors.white,
      fontSize: nbsize.height / 2.1,
      fontWeight: FontWeight.bold,
      fontFamily: 'PressStart2P',
    );
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
        Rect.fromLTWH(nbposition.x, nbposition.y, nbsize.width, nbsize.height),
        _backgroundPaint);

    final scoreValueTextPainter = TextPainter(
      text: TextSpan(
        text: nbscoreText,
        style: _textStyle,
      ),
      textDirection: TextDirection.ltr,
    );
    scoreValueTextPainter.layout();
    scoreValueTextPainter.paint(
        canvas, Offset(nbposition.x + 3, nbposition.y + nbsize.height / 2));
  }

  void updateScore({required int score}) {
    nbscoreText = score.toString();
  }
}
