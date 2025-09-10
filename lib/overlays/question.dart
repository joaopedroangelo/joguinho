import 'package:flutter/material.dart';
import 'package:EscreveAI/ember_quest.dart';

class QuestionOverlay extends StatefulWidget {
  final EmberQuestGame game;

  const QuestionOverlay({
    super.key,
    required this.game,
  });

  @override
  State<QuestionOverlay> createState() => _QuestionOverlayState();
}

class _QuestionOverlayState extends State<QuestionOverlay> {
  @override
  Widget build(BuildContext context) {
    final currentQuestion = widget.game.getCurrentQuestion();

    if (currentQuestion == null) {
      return Container();
    }

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Fundo animado com gradiente
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue.shade100,
                  Colors.purple.shade100,
                ],
              ),
            ),
            width: double.infinity,
            height: double.infinity,
          ),

          // Bolhas flutuantes (emoji bolinhas)
          Positioned(
            top: 100,
            left: 30,
            child: Text(
              '🔵',
              style: TextStyle(fontSize: 40),
            ),
          ),
          Positioned(
            top: 200,
            right: 40,
            child: Text(
              '🟠',
              style: TextStyle(fontSize: 35),
            ),
          ),
          Positioned(
            bottom: 150,
            left: 50,
            child: Text(
              '🟢',
              style: TextStyle(fontSize: 45),
            ),
          ),

          // Conteúdo principal
          Center(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 3,
                      offset: const Offset(0, 10),
                    )
                  ],
                  border: Border.all(
                    color: Colors.amber,
                    width: 3,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Cabeçalho com emoji
                    Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.yellow.shade100,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.orange,
                          width: 3,
                        ),
                      ),
                      child: Text(
                        '🧩', // Emoji de quebra-cabeça - representando desafio
                        style: TextStyle(fontSize: 40),
                      ),
                    ),

                    // Texto de incentivo
                    Text(
                      'Desafio da Estrela! 🌟',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple.shade700,
                        fontFamily: 'ComicNeue',
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Pergunta
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.lightBlue.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.lightBlue.shade300,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        currentQuestion['question'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                          fontFamily: 'ComicNeue',
                          height: 1.3,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Opções de resposta
                    ...currentQuestion['options'].asMap().entries.map(
                      (entry) {
                        int index = entry.key;
                        String option = entry.value;

                        // Emojis para cada opção
                        List<String> optionEmojis = ['🟦', '🟩', '🟨', '🟥'];
                        String optionEmoji = optionEmojis[index % 4];

                        // Cores vibrantes para cada botão
                        List<Color> buttonColors = [
                          Colors.blue.shade400,
                          Colors.green.shade400,
                          Colors.orange.shade400,
                          Colors.pink.shade400,
                        ];

                        Color buttonColor = buttonColors[index % 4];

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColor,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 70),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              elevation: 8,
                              shadowColor: buttonColor.withOpacity(0.6),
                              textStyle: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'ComicNeue',
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 15,
                              ),
                            ),
                            onPressed: () {
                              // Notifique o jogo sobre a resposta selecionada
                              widget.game.onQuestionAnswered(option);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$optionEmoji ',
                                  style: TextStyle(fontSize: 22),
                                ),
                                Expanded(
                                  child: Text(
                                    option,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
