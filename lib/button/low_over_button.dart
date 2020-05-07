import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/gestures.dart';
import 'package:flutterflappybird/bird/bird.dart';

import '../game_controller.dart';

class LowOverButton extends SpriteComponent with Tapable {
  bool isVisible = false;
  final GameController _game;
  Bird _bird;

  LowOverButton(this._game)
      : super.fromSprite(75, 75, Sprite("rasante-btn.png"));

  @override
  void render(Canvas c) {
    if (isVisible) {
      super.render(c);
    }
  }

  @override
  void resize(Size s) {
    x = s.width / 5.2 - width;
    y = s.height * 5 / 5.5;
  }

  @override
  void onTapUp(TapUpDetails details) {
    this._game.lowOver();
  }

  void setVisible(bool isVisible) {
    this.isVisible = isVisible;
  }

  @override
  int priority() => 30;
}
