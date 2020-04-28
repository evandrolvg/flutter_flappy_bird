import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class StartGame extends SpriteComponent {
  bool isVisible = true;

  StartGame() : super.fromSprite(200, 230, Sprite("logo.png"));

  @override
  void resize(Size s) {
    x = s.width / 2 - width/2;
    y = s.height / 2 - 310;
  }

  @override
  void render(Canvas c) {
    if (isVisible) {
      super.render(c);
    }
  }

  void setVisible(bool isVisible) {
    this.isVisible = isVisible;
  }

  @override
  int priority() => 30;
}
