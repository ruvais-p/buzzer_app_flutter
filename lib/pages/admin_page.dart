import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/game_state_provider.dart';
import '../providers/buzzer_provider.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameStateProvider>();
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
              'ADMIN PANEL',
              style: retroText.copyWith(
                fontSize: 20,
                shadows: [
                  Shadow(
                    color: Colors.blueAccent.withOpacity(0.8),
                    blurRadius: 15,
                  ),
                ],
                color: Colors.blueAccent,
              ),
            ),

            const SizedBox(height: 30),

            // ===== CONTROLS =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => game.updateStatus('register'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: game.status == 'register'
                            ? Colors.blueAccent
                            : Colors.grey[900],
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        side: BorderSide(
                          color: game.status == 'register'
                              ? Colors.white
                              : Colors.blueAccent,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        'REGISTER',
                        style: retroText.copyWith(
                          fontSize: 10,
                          color: game.status == 'register'
                              ? Colors.white
                              : Colors.blueAccent,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => game.updateStatus('active'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: game.status == 'active'
                            ? Colors.greenAccent
                            : Colors.grey[900],
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        side: BorderSide(
                          color: game.status == 'active'
                              ? Colors.white
                              : Colors.greenAccent,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        'START',
                        style: retroText.copyWith(
                          fontSize: 10,
                          color: game.status == 'active'
                              ? Colors.black
                              : Colors.greenAccent,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ===== RESET =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    buzzer.resetBuzzers();
                    game.updateStatus('register');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Colors.white, width: 2),
                  ),
                  child: Text(
                    'RESET ALL',
                    style: retroText.copyWith(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ===== TIMELINE =====
            Text(
              'BUZZ TIMELINE',
              style: retroText.copyWith(fontSize: 12, color: Colors.white),
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
                      border: Border.all(color: Colors.blueAccent),
                      color: Colors.black,
                    ),
                    child: Row(
                      children: [
                        Text(
                          '#${index + 1}',
                          style: retroText.copyWith(
                            fontSize: 10,
                            color: Colors.blueAccent,
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
                              ? '${time.hour}:${time.minute}:${time.second}.${time.millisecond}'
                              : '--',
                          style: retroText.copyWith(
                            fontSize: 8,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
