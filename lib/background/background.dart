import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';

class Background extends SpriteComponent {
  Background() : super.fromSprite(600, 400, Sprite('bg.png')) {
    this.x = 0;
    this.y = 0;
  }

  @override
  void resize(Size s) {
    width = s.width;
    height = s.height;
  }

  @override
  void render(Canvas c) {
    super.render(c);
  }

  void lowOver(bool lowOver){
    if (lowOver){
      this.sprite = Sprite('bg_low.png');
    }else{
      this.sprite = Sprite('bg.png');
    }
  }

  @override
  int priority() => 20;
}
