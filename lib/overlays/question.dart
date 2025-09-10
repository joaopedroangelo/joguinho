import 'package:flutter/material.dart';
import 'package:EscreveAI/ember_quest.dart';

class QuestionOverlay extends StatelessWidget {
  final EmberQuestGame game;
  final String question;
  final List<String> options;
  final void Function(String) onAnswerSelected;

  const QuestionOverlay({
    super.key,
    required this.game,
    required this.question,
    required this.options,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fundo semi-transparente com padrão infantil
        Container(
          decoration: BoxDecoration(
            color: Colors.blue[100]!.withOpacity(0.9),
            image: DecorationImage(
              image: AssetImage(
                  'assets/images/background_pattern.png'), // Padrão infantil
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.1),
                BlendMode.dstATop,
              ),
            ),
          ),
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
                    child: Image.asset(
                      'assets/images/quiz_icon.png', // Ícone de lápis ou livro
                      height: 60,
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
                      question,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                        fontFamily: 'ComicNeue', // Fonte infantil
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Opções de resposta
                  ...options.asMap().entries.map(
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
                              fontFamily: 'ComicNeue',
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          onPressed: () {
                            // Efeito de som ao clicar (pode ser implementado)
                            onAnswerSelected(option);
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
