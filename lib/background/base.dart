import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:flutterflappybird/game_controller.dart';

class Base extends SpriteComponent {
  Base() : super.fromSprite(100, 100, Sprite('grass.png'));

 /* Base(x, this.gapTopY, this.gapHeight)
      : super.fromSprite(
      Base.bas, Pipe.pipeHeight, Sprite('pipe-bottom.png')) {
    this.x = x;
  }*/

  @override
  void resize(Size s) {
    x = 0;
    y = s.height - GameController.groundHeight;
    width = s.width;
    height = GameController.groundHeight;
  }

  @override
  int priority() => 30;
}
