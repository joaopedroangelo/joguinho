import 'dart:math';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '../ember_quest.dart';

class MainMenu extends StatefulWidget {
  final EmberQuestGame game;

  const MainMenu({required this.game, super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  final _nomeController = TextEditingController();
  final _anoController = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final List<String> _welcomeAudios = [
    'voices/welcomes/welcome01.mp3',
    'voices/welcomes/welcome02.mp3',
  ];

  Future<void> _playRandomWelcome() async {
    final random = Random().nextInt(_welcomeAudios.length);
    await _audioPlayer.play(AssetSource(_welcomeAudios[random]));
  }

  bool get isFormValid {
    final nome = _nomeController.text.trim();
    final ano = int.tryParse(_anoController.text);
    return nome.isNotEmpty &&
        ano != null &&
        ano > 1900 &&
        ano <= DateTime.now().year;
  }

  int? get computedAge {
    final ano = int.tryParse(_anoController.text);
    if (ano == null) return null;
    return DateTime.now().year - ano;
  }

  String get initials {
    final nome = _nomeController.text.trim();
    if (nome.isEmpty) return '🙂';
    final parts = nome.split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    } else {
      final a = parts.first.substring(0, 1);
      final b = parts.last.substring(0, 1);
      return (a + b).toUpperCase();
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _anoController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Cores do card — sem cobrir todo o fundo do jogo (transparência)
    final cardColor = Colors.white.withOpacity(0.86);
    final accent = const Color(0xFF6C63FF);

    return Material(
      color: Colors.transparent, // mantém o fundo do jogo visível
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 380),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                ),
              ],
              border: Border.all(color: Colors.white.withOpacity(0.4)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Cabeçalho compacto: avatar + título colorido minimalista
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: accent,
                      child: Text(
                        initials,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Aventura do\n',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            ...'Alfabeto'.split('').asMap().entries.map((e) {
                              final i = e.key;
                              final ch = e.value;
                              final colors = [
                                Color(0xFFEF5350),
                                Color(0xFFFFA726),
                                Color(0xFFFFEB3B),
                                Color(0xFF66BB6A),
                                Color(0xFF29B6F6),
                                Color(0xFFAB47BC),
                                Color(0xFF8D6E63),
                              ];
                              return TextSpan(
                                text: ch,
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: colors[i % colors.length],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.volume_up, color: Colors.black87),
                      onPressed: _playRandomWelcome,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Campos — visual amigável e simples (pouco texto)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _nomeController,
                      decoration: InputDecoration(
                        hintText: 'Nome',
                        prefixIcon: const Icon(Icons.person_2_outlined),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _anoController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Ano (ex: 2018)',
                        prefixIcon: const Icon(Icons.abc),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Botão principal: grande e claro, sem muita tag line
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isFormValid
                        ? () {
                            // salvar no jogo se quiser (descomente se EmberQuestGame aceitar)
                            // widget.game.playerName = _nomeController.text.trim();
                            // widget.game.playerYear = int.parse(_anoController.text.trim());

                            widget.game.overlays.remove('MainMenu');
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isFormValid ? accent : Colors.grey.shade400,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: isFormValid ? 6 : 0,
                    ),
                    child: const Text(
                      'Jogar',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // ajuda curta — apenas ícone e texto mínimo
                Opacity(
                  opacity: 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.keyboard_alt, size: 14, color: Colors.black54),
                      SizedBox(width: 6),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
