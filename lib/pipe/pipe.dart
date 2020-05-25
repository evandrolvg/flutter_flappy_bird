import 'dart:math';

import 'package:flutterflappybird/bird/bird.dart';
import 'package:flutterflappybird/game_controller.dart';
import 'package:flutterflappybird/pipe/pipe_bottom.dart';
import 'package:flutterflappybird/pipe/pipe_top.dart';

class Pipe {
  static double speed = 3;
  static double pipeWidth = 60;
  static double pipeHeight = 700;

  final int pipeId;
  final GameController _game;

  PipeTop pipeTop;
  PipeBottom pipeBottom;

  double _gapHeight;
  double _gapTopY;

  final int gapMinHeight = 300;
  final int gapMaxHeight = 500;
  final int gapMinTopY = 40;
  final int gapMaxTopY = 350;
  double x;
  bool isOutOfSight = false;

  Bird _bird;

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

  void move(bool lowOver) {
    if (x < -100) {
      isOutOfSight = true;
    } else {
      x -= speed;
      pipeTop.move(x, lowOver);
      pipeBottom.move(x);
    }
  }

  bool isPassed(Bird bird) {
    return (x + pipeWidth) < bird.x;
  }

  void destroy() {
    pipeTop.remove();
    pipeBottom.remove();
  }

}
