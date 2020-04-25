import 'dart:math';

import 'package:flutterflappybird/bird/bird.dart';
import 'package:flutterflappybird/game_controller.dart';
import 'package:flutterflappybird/pipe/pipe_bottom.dart';
import 'package:flutterflappybird/pipe/pipe_top.dart';

class Pipe {
  static final double speed = 3;
  static final double pipeWidth = 70;
  static final double pipeHeight = 500;

  final int pipeId;
  final GameController _game;

  PipeTop pipeTop;
  PipeBottom pipeBottom;

  double _gapHeight;
  double _gapTopY;

  final int gapMinHeight = 165;
  final int gapMaxHeight = 165;
  final int gapMinTopY = 90;
  final int gapMaxTopY = 450;
  double x;
  bool isOutOfSight = false;

  Pipe(this.pipeId, this._game, startX) {
    x = startX;
    _gapHeight = _randomIntInRange(gapMinHeight, gapMaxHeight);
    _gapTopY = _randomIntInRange(gapMinTopY, gapMaxTopY);
    pipeTop = PipeTop(x, _gapTopY);
    pipeBottom = PipeBottom(x, _gapTopY, _gapHeight);
  }

  Map get upperLTWH => {
        "x": x,
        "height": _gapTopY,
      };

  Map get lowerLTWH => {
        "x": x,
        "height": _game.height - _gapTopY - _gapHeight,
      };

  double _randomIntInRange(int min, int max) {
    if (min == max) return min.toDouble();
    return (min + Random().nextInt(max - min)).toDouble();
  }

  void move() {
    if (x < -100) {
      isOutOfSight = true;
    } else {
      x -= speed;
      pipeTop.move(x);
      pipeBottom.move(x);
    }
  }

  bool isPassed(Bird bird) => (x + pipeWidth) < bird.x;

  void destroy() {
    pipeTop.remove();
    pipeBottom.remove();
  }
}
