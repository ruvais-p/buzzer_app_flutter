import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PlayerProvider extends ChangeNotifier {
  String? _username;

  String? get username => _username;

  bool get isRegistered => _username != null;

  Future<void> register(String name) async {
    try {
      await Supabase.instance.client.from('players').upsert({'name': name});
      _username = name;
      notifyListeners();
    } catch (e) {
      debugPrint('Error registering: $e');
      rethrow;
    }
  }

  void reset() {
    _username = null;
    notifyListeners();
  }
}
