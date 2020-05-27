import 'dart:ui';

import 'package:flame/components/parallax_component.dart';
import 'package:flutter/cupertino.dart';

class Background extends ParallaxComponent {
  bool _isDestroy = false;
  static final images = [
    ParallaxImage("sky.png", repeat: ImageRepeat.repeatX, alignment: Alignment.center, fill: LayerFill.height),
    ParallaxImage("cloud01.png", repeat: ImageRepeat.repeatX, alignment: Alignment.center, fill: LayerFill.height),
    ParallaxImage("hills.png", repeat: ImageRepeat.repeatX, alignment: Alignment.center, fill: LayerFill.height),
    ParallaxImage("ground.png", repeat: ImageRepeat.repeatX, alignment: Alignment.bottomCenter, fill: LayerFill.height)  ];

  Background() : super(images,
      baseSpeed: const Offset(5, 0), layerDelta: const Offset(10, 0));

  @override
  bool destroy() => _isDestroy;

  void remove() => _isDestroy = true;
}
