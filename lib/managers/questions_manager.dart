import 'dart:convert';
import 'dart:math';
import 'package:EscreveAI/ember_quest.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

/// Gerencia carregamento, seleção, áudio e verificação das questões.
/// Observação: recebe uma referência ao [EmberQuestGame] para pausar/retomar
/// e abrir a overlay.
class QuestionsManager {
  final EmberQuestGame game;

  QuestionsManager(this.game);

  final AudioPlayer _audioPlayer = AudioPlayer();
  List<Map<String, dynamic>> _questions = [];
  Map<String, dynamic>? _currentQuestion;
  String? _currentAudioPath;

  bool get hasQuestions => _questions.isNotEmpty;
  Map<String, dynamic>? get currentQuestion => _currentQuestion;

  /// Carrega as questões do JSON (com fallback)
  Future<void> loadQuestions() async {
    try {
      final jsonString =
          await rootBundle.loadString('assets/questions/questions.json');
      final List<dynamic> jsonList = json.decode(jsonString);

      _questions = jsonList
          .where((q) => q['disponivel'] == true)
          .toList()
          .cast<Map<String, dynamic>>();

      _questions.sort((a, b) => a['id'].compareTo(b['id']));
      print('${_questions.length} questões carregadas do JSON');
    } catch (e) {
      print('Erro ao carregar questões: $e');
      _questions = [
        {
          "id": 1,
          "disponivel": true,
          "question": "Teste",
          "options": ["A", "B", "C", "D"],
          "answer": "A"
        },
        {
          "id": 2,
          "disponivel": true,
          "question": "Qual é a cor do céu em um dia claro?",
          "options": ["Azul", "Verde", "Amarelo", "Vermelho"],
          "answer": "Azul"
        },
      ];
    }
  }

  /// Reset do estado interno (usado por game.reset())
  void resetQuestions() {
    _currentQuestion = null;
    _currentAudioPath = null;
  }

  /// Seleciona questão aleatória e prepara áudio (interno)
  Map<String, dynamic>? _selectRandomQuestion() {
    if (_questions.isEmpty) return null;
    final random = Random();
    _currentQuestion = _questions[random.nextInt(_questions.length)];

    final questionId = _currentQuestion!['id'];
    final formattedId = questionId.toString().padLeft(2, '0');
    _currentAudioPath = 'voices/questions_voices/$formattedId.mp3';

    return _currentQuestion;
  }

  /// Deve ser chamado quando o jogo decide tentar perguntar (ex: coleta de estrela)
  /// Pausa o motor, marca isQuestionActive no game, abre overlay e toca áudio.
  void maybeAskQuestion() {
    if (game.isQuestionActive || _questions.isEmpty) return;

    final q = _selectRandomQuestion();
    if (q == null) return;

    game.isQuestionActive = true;
    game.pauseEngine();
    game.overlays.add('QuestionOverlay');
    playCurrentQuestionAudio();
  }

  Future<void> playCurrentQuestionAudio() async {
    if (_currentAudioPath == null) return;
    try {
      await _audioPlayer.play(AssetSource(_currentAudioPath!));
    } catch (e) {
      print('Erro ao reproduzir áudio: $e');
    }
  }

  Future<void> stopAudio() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      // ignore
    }
  }

  /// Apenas checa se a resposta bate com a resposta correta.
  /// Não limpa o estado: a overlay é responsável por limpar após timeout.
  bool checkAnswer(String selectedAnswer) {
    if (_currentQuestion == null) return false;
    return selectedAnswer == _currentQuestion!['answer'];
  }

  /// Limpa a questão atual e marca game.isQuestionActive = false
  void clearCurrentQuestion() {
    _currentQuestion = null;
    _currentAudioPath = null;
    game.isQuestionActive = false;
  }
}
