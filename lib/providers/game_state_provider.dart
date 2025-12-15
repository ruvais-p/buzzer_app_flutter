import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GameStateProvider extends ChangeNotifier {
  String _status = 'register'; // register, active, locked

  String get status => _status;

  GameStateProvider() {
    _init();
  }

  void _init() {
    Supabase.instance.client
        .from('game_state')
        .stream(primaryKey: ['id'])
        .eq('id', 1)
        .listen((data) {
          if (data.isNotEmpty) {
            _status = data[0]['status'];
            notifyListeners();
          }
        });
  }

  Future<void> updateStatus(String newStatus) async {
    await Supabase.instance.client.from('game_state').upsert({
      'id': 1,
      'status': newStatus,
    });
  }
}
