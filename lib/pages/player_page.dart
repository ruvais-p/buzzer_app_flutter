import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/game_state_provider.dart';
import '../providers/player_provider.dart';
import '../providers/buzzer_provider.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  final TextEditingController _controller = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameStateProvider>();
    final player = context.watch<PlayerProvider>();
    final buzzer = context.watch<BuzzerProvider>();

    final retroText = GoogleFonts.pressStart2p(
      color: Colors.redAccent,
      letterSpacing: 1.5,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0F),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // ===== TITLE =====
            Text(
              'QUIZ BUZZER',
              style: retroText.copyWith(
                fontSize: 20,
                shadows: [
                  Shadow(
                    color: Colors.redAccent.withOpacity(0.8),
                    blurRadius: 15,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ===== MAIN CONTENT =====
            if (game.status == 'register' && !player.isRegistered)
              // Centered Register Form
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _controller,
                          style: retroText.copyWith(fontSize: 10),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.black,
                            hintText: 'ENTER NAME',
                            hintStyle: retroText.copyWith(
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.redAccent,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                          ),
                          onPressed: () {
                            if (_controller.text.isNotEmpty) {
                              player.register(_controller.text);
                            }
                          },
                          child: Text(
                            'REGISTER',
                            style: retroText.copyWith(
                              color: Colors.black,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              // Game Interface (Registered or Non-Register Mode)
              Expanded(
                child: Center(
                  child: Column(
                    children: [
                      // PLAYER INFO
                      if (player.isRegistered)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            'PLAYER: ${player.username}',
                            style: retroText.copyWith(fontSize: 10),
                          ),
                        ),

                      const SizedBox(height: 40),

                      // BUZZER BUTTON / STATUS
                      if (game.status == 'active' && player.isRegistered)
                        GestureDetector(
                          onTap: () async {
                            await _audioPlayer.play(
                              AssetSource('buzzer_sound.mp3'),
                            );

                            final hasBuzzed = buzzer.buzzers.any(
                              (b) => b['name'] == player.username,
                            );
                            if (!hasBuzzed) {
                              buzzer.buzz(player.username!);
                            }
                          },
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const RadialGradient(
                                colors: [Colors.redAccent, Colors.black],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.redAccent.withOpacity(0.9),
                                  blurRadius: 50,
                                  spreadRadius: 12,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                'BUZZ',
                                style: retroText.copyWith(
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                      else if (game.status == 'locked')
                        Text(
                          'BUZZER LOCKED',
                          style: retroText.copyWith(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        )
                      else if (game.status == 'register' && player.isRegistered)
                        Text(
                          'WAITING...',
                          style: retroText.copyWith(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),

                      const SizedBox(height: 30),

                      // TIMELINE
                      if (buzzer.buzzers.isNotEmpty) ...[
                        const SizedBox(height: 40),
                        Text(
                          'BUZZ TIMELINE',
                          style: retroText.copyWith(fontSize: 12),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            itemCount: buzzer.buzzers.length,
                            itemBuilder: (context, index) {
                              final b = buzzer.buzzers[index];
                              final time = b['buzzed_at'] != null
                                  ? DateTime.parse(b['buzzed_at'])
                                  : null;

                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6,
                                ),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.redAccent),
                                  color: Colors.black,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      '#${index + 1}',
                                      style: retroText.copyWith(
                                        fontSize: 10,
                                        color: Colors.red,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        b['name'] ?? 'UNKNOWN',
                                        style: retroText.copyWith(
                                          fontSize: 10,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      time != null
                                          ? '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}'
                                          : '--',
                                      style: retroText.copyWith(
                                        fontSize: 8,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    if (b['name'] == player.username)
                                      const Padding(
                                        padding: EdgeInsets.only(left: 8),
                                        child: Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 14,
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
