import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BuzzerProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _buzzers = [];

  List<Map<String, dynamic>> get buzzers => _buzzers;

  BuzzerProvider() {
    _init();
  }

  void _init() {
    Supabase.instance.client
        .from('players')
        .stream(primaryKey: ['name'])
        .order('buzzed_at', ascending: true)
        .listen((data) {
          final buzzedPlayers = data
              .where((element) => element['buzzed_at'] != null)
              .toList();
          _buzzers = buzzedPlayers;
          notifyListeners();
        });
  }

  Future<void> buzz(String username) async {
    await Supabase.instance.client
        .from('players')
        .update({'buzzed_at': DateTime.now().toIso8601String()})
        .eq('name', username);
  }

  Future<void> resetBuzzers() async {
    await Supabase.instance.client
        .from('players')
        .update({'buzzed_at': null})
        .neq('name', 'placeholder');
  }
}
