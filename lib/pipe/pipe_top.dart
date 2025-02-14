import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:flutterflappybird/pipe/pipe.dart';

class PipeTop extends SpriteComponent {
  final double gapTopY;
  bool isDestroy = false;

  PipeTop(x, this.gapTopY)
      : super.fromSprite(
            Pipe.pipeWidth, Pipe.pipeHeight, Sprite('pipe-top.png')) {
    this.x = x;
    //print('Angle ${this.angle}');
  }

  @override
  void resize(Size s) {
    y = 0 - (height - gapTopY);
    super.resize(s);
  }

  void move(double x, bool lowOver) {
    if (lowOver) {
      this.sprite = Sprite('pipe-top-explode.png');
      this.angle = this.angle - 0.1;
      this.width = this.width * 1.2 ;
      this.remove();
    }

    this.x = x;
  }

  @override
  bool destroy() => isDestroy;

  void remove() => isDestroy = true;

  @override
  int priority() => 25;
}
