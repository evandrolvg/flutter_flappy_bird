import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/gestures.dart';

import '../game_controller.dart';

class LowOverButton extends SpriteComponent with Tapable {
  bool isDestroy = false;
  final GameController _game;

  LowOverButton(this._game)
      : super.fromSprite(270, 150, Sprite("rasante-btn.png"));

  @override
  void render(Canvas c) {
    super.render(c);
  }

  @override
  void resize(Size s) {
    x = s.width / 2 - width / 2;
    y = s.height * 5 / 6.5;
  }

  @override
  void onTapUp(TapUpDetails details) {
    this._game.lowOver();
  }

  @override
  bool destroy() => isDestroy;

  void remove() => isDestroy = true;

  @override
  int priority() => 30;

}
