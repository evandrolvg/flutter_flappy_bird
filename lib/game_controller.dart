import 'dart:async';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutterflappybird/background/background.dart';
import 'package:flutterflappybird/background/base.dart';
import 'package:flutterflappybird/bird/bird.dart';
import 'package:flutterflappybird/collision_detector.dart';
import 'package:flutterflappybird/config/sound.dart';
import 'package:flutterflappybird/pipe/pipe.dart';
import 'package:flutterflappybird/text/final_score.dart';
import 'package:flutterflappybird/text/game_over.dart';
import 'package:flutterflappybird/text/score.dart';
import 'package:flutterflappybird/text/start_game.dart';
import 'package:flutterflappybird/text/top_score.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'button/play_button.dart';
import 'button/retry_button.dart';
import 'config/store.dart';
import 'game_state.dart';

class GameController extends BaseGame {
  //Altura do chao
  static final double groundHeight = 80;

  GameState gameState = GameState.initializing;
  //Hive
  Box userBox;
  Size screenSize;

  double width;
  double height;
  double centerX;
  double centerY;

  Background _bg = Background();
  Base _base = Base();
  //Obstáculos
  final int _pipeIntervalInMs = 1800;
  int _pipeCount;
  List<Pipe> _pipes = [];
  //Coleção de objetos em que cada objeto pode ocorrer apenas uma vez
  Set<int> _passedPipeIds = new Set();
  double _lastPipeInterval;
  Timer pipeFactoryTimer;
  Bird _bird;
  Score _score = Score(0);
  int _topScore;
  FinalScore finalScoreText;
  TopScore topScoreText;

  StartGame _startGame = StartGame();
  PlayButton _playButton;
  GameOver _gameOver = GameOver();
  RetryButton _retryButton;
  bool _hasCrashed;

  @override
  bool debugMode() {
    return false;
  }

  GameController() {
    _initializeUserBox().then((b) => userBox = b);
    Flame.audio.loadAll([
      Sound.bgm,
      //Sound.jump,
      Sound.die,
      Sound.crash,
      Sound.score,
    ]);
    add(_bg);
    add(_base);
    add(_score);
    add(_startGame);
    add(_gameOver);
    _getLastTopScore().then((s) => _topScore = s);

    Flame.bgm.stop();

  }

  Future<Box> _initializeUserBox() async {
    print('GameController - initializeUserBox - Hive');
    return Hive.openBox(Store.userBox);
  }

  Future<int> _getLastTopScore() async => Hive.openBox(Store.userBox)
      .then((b) => b.get(Store.topScore, defaultValue: 0));

  @override
  void resize(Size s) {
    print('GameController - resize');
    super.resize(s);
    if (GameState.initializing == gameState) {
      screenSize = s;
      width = s.width;
      height = s.height - groundHeight;
      centerX = s.width / 2;
      centerY = (s.height - groundHeight) / 2;
      _gotoStartGame();
    }
  }

  void _initializeGame() {
    print('GameController - initializeGame');
    _initializeBgm();
    _initializeBird();
    _initializePipes();
    _initializePlayButton();
    _score.reset();
    _hasCrashed = false;
  }

  void _initializePlayButton() {
    print('GameController - initializePlayButton');
    _playButton?.remove();
    _playButton = PlayButton(() => _gotoPlayGame());
    add(_playButton);
  }

  void _initializeRetryButton() {
    print('GameController - initializeRetryButton');
    _destroyRetryButton();
    _retryButton = RetryButton(() => _gotoStartGame());
    add(_retryButton);
  }

  void _initializeBird() {
    print('GameController - initializeBird');
    _bird?.remove();
    _bird = Bird(this);
    add(_bird);
  }

  void _initializePipes() {
    print('GameController - initializePipes');
    _pipes.forEach((p) => p.destroy());
    _pipes = [];
    _pipeCount = 0;
    _passedPipeIds = new Set();
    _lastPipeInterval = 1400;
  }

  void _initializeBgm() {
    print('GameController - initializeBgm');
    Flame.bgm.stop();
    //if (Flame.bgm.isPlaying) {
    //}
    Flame.bgm.play(Sound.bgm, volume: 0.4);
  }

  @override
  void update(double t) {
    super.update(t);
    if (GameState.playing == gameState) {
      if (!_hasCrashed && _isCrashing()) {
        _gotoGameOver();
      } else {
        _updatePipes(t);
        _updateScore();
      }
    }
  }

  void _updateScore() {
    print('GameController - updateScore');
    _pipes
        .where((p) => p.isPassed(_bird))
        .forEach((p) => _passedPipeIds.add(p.pipeId));
    _score.updateScore(_passedPipeIds.length);
  }

  bool _isCrashing() {
    print('GameController - isCrashing');
    if (_bird.isDead || _hasCrashed) return false;
    if (_bird.y < 0 || _bird.y > (height - _bird.height / 2)) {
      return true;
    }
    final _comingPipes = _pipes.where((p) => !p.isPassed(_bird));
    for (Pipe p in _comingPipes) {
      if (CollisionDetector.hasBirdCollided(_bird, p)) {
        return true;
      }
    }
    return false;
  }

  void _updatePipes(double t) {
    print('GameController - updatePipes');
    if (_lastPipeInterval > _pipeIntervalInMs) {
      Pipe pipe = Pipe(_pipeCount++, this, width);
      add(pipe.pipeTop);
      add(pipe.pipeBottom);
      _pipes.add(pipe);
      _lastPipeInterval = 0;
    } else {
      _lastPipeInterval += t * 1000;
    }
    _pipes.forEach((p) {
      p.isOutOfSight ? p.destroy() : p.move();
    });
    _pipes = _pipes.where((p) => !p.isOutOfSight).toList();
  }

  @override
  void onTapDown(TapDownDetails details) {
    switch (gameState) {
      case GameState.playing:
        {
          _bird.jump();
        }
        break;
      default:
        break;
    }
  }

  void _gotoStartGame() {
    print('gotoStartGame');
    _startGame.setVisible(true);
    _gameOver.hide();
    _hideScores();
    _destroyRetryButton();
    _initializePlayButton();
    _initializeGame();
    gameState = GameState.start;
  }

  void _hideScores() {
    _score.setVisible(false);
    finalScoreText?.remove();
    topScoreText?.remove();
  }

  void _destroyRetryButton() {
    _retryButton?.remove();
  }

  void _gotoPlayGame() {
    print('GameController - gotoPlayGame');
    gameState = GameState.playing;
    _startGame.setVisible(false);
    _playButton.remove();
    _score.setVisible(true);
    _bird.jump();
  }

  void _gotoGameOver() {
    print('GameController - gotoGameOver');
    _score.setVisible(false);
    Flame.audio.play(Sound.crash, volume: 0.5);
    _bird.die();
    Flame.bgm.stop();
    _updateTopScore();
    _hasCrashed = true;
    _gameOver.show();
    _initializeRetryButton();
    gameState = GameState.finished;
  }

  void _updateTopScore() {
    print('GameController - updateTopScore');
    _getLastTopScore().then((lastTopScore) {
      if (_score.score > lastTopScore) {
        _topScore = _score.score;
        Hive.openBox(Store.userBox)
            .then((b) => b.put(Store.topScore, _topScore));
      }
      _showScoreBoard();
    });
  }

  void _showScoreBoard() {
    print('GameController - showScoreBoard');
    finalScoreText = FinalScore(_score.score);
    topScoreText = TopScore(_topScore);
    add(finalScoreText);
    add(topScoreText);
  }
}
