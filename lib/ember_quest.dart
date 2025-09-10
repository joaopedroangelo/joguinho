import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

import 'actors/ember.dart';
import 'actors/water_enemy.dart';
import 'managers/segment_manager.dart';
import 'objects/ground_block.dart';
import 'objects/platform_block.dart';
import 'objects/star.dart';
import 'overlays/hud.dart';

class EmberQuestGame extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  EmberQuestGame();

  // Lista de questões educacionais
  final List<Map<String, dynamic>> questions = [
    {
      "question": "Qual letra inicia a palavra 'Abacaxi'?",
      "options": ["A", "B", "C", "D"],
      "answer": "A"
    },
    {
      "question": "Qual é a cor do céu em um dia claro?",
      "options": ["Azul", "Verde", "Amarelo", "Vermelho"],
      "answer": "Azul"
    },
    {
      "question": "Quantas pernas tem um cachorro?",
      "options": ["2", "4", "6", "8"],
      "answer": "4"
    },
    {
      "question": "Qual letra inicia a palavra 'Banana'?",
      "options": ["B", "M", "P", "T"],
      "answer": "B"
    },
    {
      "question": "Qual é a primeira letra da palavra 'Lâmpada'?",
      "options": ["L", "R", "S", "T"],
      "answer": "L"
    },
    {
      "question": "Qual é a primeira vogal da palavra 'elefante'?",
      "options": ["A", "E", "I", "O"],
      "answer": "E"
    },
    {
      "question": "Qual letra inicia a palavra 'Livro'?",
      "options": ["L", "V", "F", "P"],
      "answer": "L"
    },
    {
      "question": "Quantas sílabas tem a palavra 'bola'?",
      "options": ["1", "2", "3", "4"],
      "answer": "2"
    },
    {
      "question": "Qual é a letra final da palavra 'sol'?",
      "options": ["S", "O", "L", "R"],
      "answer": "L"
    },
    {
      "question": "Qual palavra rima com 'pato'?",
      "options": ["Rato", "Mesa", "Sol", "Luz"],
      "answer": "Rato"
    },
  ];

  late EmberPlayer _ember;
  late double lastBlockXPosition = 0.0;
  late UniqueKey lastBlockKey;

  int starsCollected = 0;
  int health = 3;
  double cloudSpeed = 0.0;
  double objectSpeed = 0.0;
  String playerName = '';
  int playerBirthYear = 0;

  // Variáveis para gerenciar as questões
  Map<String, dynamic>? currentQuestion;
  bool isQuestionActive = false;

  // Adicionando joystick
  late JoystickComponent joystick;

  @override
  Future<void> onLoad() async {
    //debugMode = true; // Uncomment to see the bounding boxes
    await images.loadAll([
      'block.png',
      'lapis.png',
      'ember.png',
      'borracha.png',
      'ground.png',
      'heart_half.png',
      'heart.png',
      'star.png',
      'water_enemy.png',
    ]);
    camera.viewfinder.anchor = Anchor.topLeft;

    // Inicializa joystick
    joystick = JoystickComponent(
      knob: CircleComponent(
        radius: 20,
        paint: Paint()..color = Colors.blueAccent,
      ),
      background: CircleComponent(
        radius: 50,
        paint: Paint()..color = Colors.blue.withOpacity(0.5),
      ),
      margin: EdgeInsets.only(
        right: 60, // distância da borda direita
        bottom:
            canvasSize.y / 2 - 60, // sobe para aproximadamente metade da tela
      ),
    );
    add(joystick);

    initializeGame(loadHud: true);
  }

  @override
  void update(double dt) {
    if (health <= 0 && !overlays.isActive('GameOver')) {
      overlays.add('GameOver');
    }

    // Atualiza movimento do EmberPlayer usando joystick
    _ember.move(joystick.relativeDelta);

    super.update(dt);
  }

  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 173, 223, 247);
  }

  void loadGameSegments(int segmentIndex, double xPositionOffset) {
    for (final block in segments[segmentIndex]) {
      final component = switch (block.blockType) {
        const (GroundBlock) => GroundBlock(
            gridPosition: block.gridPosition,
            xOffset: xPositionOffset,
          ),
        const (PlatformBlock) => PlatformBlock(
            gridPosition: block.gridPosition,
            xOffset: xPositionOffset,
          ),
        const (Star) => Star(
            gridPosition: block.gridPosition,
            xOffset: xPositionOffset,
          ),
        const (WaterEnemy) => WaterEnemy(
            gridPosition: block.gridPosition,
            xOffset: xPositionOffset,
          ),
        _ => throw UnimplementedError(),
      };
      world.add(component);
    }
  }

  void initializeGame({required bool loadHud}) {
    final segmentsToLoad = (size.x / 640).ceil();
    segmentsToLoad.clamp(0, segments.length);

    for (var i = 0; i <= segmentsToLoad; i++) {
      loadGameSegments(i, (640 * i).toDouble());
    }

    _ember = EmberPlayer(
      position: Vector2(128, canvasSize.y - 128),
    );
    world.add(_ember);
    if (loadHud) {
      camera.viewport.add(Hud());
    }
  }

  void reset() {
    starsCollected = 0;
    health = 3;
    isQuestionActive = false;
    currentQuestion = null;
    initializeGame(loadHud: false);
  }

  // Método chamado quando uma estrela é coletada
  void onStarCollected() {
    starsCollected++;

    // Se já há uma questão ativa, não faça nada
    if (isQuestionActive) return;

    // Pause o jogo
    pauseEngine();
    isQuestionActive = true;

    // Selecione uma questão aleatória
    final random = Random();
    currentQuestion = questions[random.nextInt(questions.length)];

    // Mostre o overlay de questão
    overlays.add('QuestionOverlay');
  }

  // Método para processar a resposta da questão
  void onQuestionAnswered(String selectedAnswer) {
    // Verifique se a resposta está correta
    final isCorrect = selectedAnswer == currentQuestion!['answer'];

    // Dê feedback ao jogador
    if (isCorrect) {
      // Recompense o jogador por responder corretamente
      starsCollected += 2; // Bônus por resposta correta
    } else {
      // Penalize o jogador por responder incorretamente
      health--;
    }

    // Remova o overlay
    overlays.remove('QuestionOverlay');

    // Retome o jogo
    resumeEngine();
    isQuestionActive = false;
    currentQuestion = null;
  }

  // Método para obter a questão atual (usado pelo overlay)
  Map<String, dynamic>? getCurrentQuestion() {
    return currentQuestion;
  }
}
