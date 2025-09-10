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

    return Stack(
      children: [
        // Fundo semi-transparente
        Container(
          color: Colors.blue[100]!.withOpacity(0.9),
          width: double.infinity,
          height: double.infinity,
        ),

        // Card central com a pergunta e respostas
        Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(25),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: const Offset(0, 5),
                  )
                ],
                border: Border.all(
                  color: Colors.orange,
                  width: 4,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Ícone decorativo
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: const Icon(
                      Icons.school,
                      size: 60,
                      color: Colors.blue,
                    ),
                  ),

                  // Pergunta
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.yellow[100],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.amber,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      currentQuestion['question'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Opções de resposta
                  ...currentQuestion['options'].asMap().entries.map(
                    (entry) {
                      int index = entry.key;
                      String option = entry.value;

                      // Cores alternadas para os botões
                      Color buttonColor;
                      switch (index % 4) {
                        case 0:
                          buttonColor = Colors.blue;
                          break;
                        case 1:
                          buttonColor = Colors.green;
                          break;
                        case 2:
                          buttonColor = Colors.orange;
                          break;
                        case 3:
                          buttonColor = Colors.pink;
                          break;
                        default:
                          buttonColor = Colors.blue;
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonColor,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 65),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 5,
                            shadowColor: buttonColor.withOpacity(0.5),
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          onPressed: () {
                            // Notifique o jogo sobre a resposta selecionada
                            widget.game.onQuestionAnswered(option);
                          },
                          child: Text(
                            option,
                            textAlign: TextAlign.center,
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
    );
  }
}
