import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/gestures.dart';

class PlayButton extends SpriteComponent with Tapable {
  bool isDestroy = false;
  Function tapCallback;

  PlayButton(this.tapCallback)
      : super.fromSprite(60, 60, Sprite("play-btn.png"));

  @override
  void resize(Size s) {
    x = s.width / 2 - width / 2;
    y = s.height * 5 / 9;
  }

  @override
  void onTapUp(TapUpDetails details) {
    tapCallback();
  }

  @override
  bool destroy() => isDestroy;

  void remove() => isDestroy = true;

  @override
  int priority() => 30;
}
