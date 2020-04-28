import 'package:flame/flame.dart';
import 'package:flame/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'game_controller.dart';
//Flutter Flame
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Hive - diretorio atual0
  final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
  Hive..init(appDocumentDirectory.path);

  Util flameUtil = Util();
  await flameUtil.fullScreen();
  await flameUtil.setOrientation(DeviceOrientation.portraitUp);

  GameController game = GameController();
  runApp(game.widget);
  //Classe - música de fundo em loop
  Flame.bgm.initialize();
  Flame.audio.disableLog();
}