import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:store_lyqx/features/login/data/models/user_model.dart';

class AppStorage {
  AppStorage._();

  static const _favKey = 'favorites';

  static Future<Set<int>> getFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_favKey) ?? <String>[];
      final parsed = <int>{};
      for (final s in list) {
        try {
          parsed.add(int.parse(s));
        } catch (_) {
          // Ignore malformed entry
        }
      }
      return parsed;
    } catch (_) {
      // On platform error return empty set
      return <int>{};
    }
  }

  static Future<bool> isFavorite(int id) async {
    try {
      final favs = await getFavorites();
      return favs.contains(id);
    } catch (_) {
      return false;
    }
  }

  static Future<void> toggleFavorite(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favs = (prefs.getStringList(_favKey) ?? <String>[]).toSet();
      final idStr = id.toString();
      if (favs.contains(idStr)) {
        favs.remove(idStr);
      } else {
        favs.add(idStr);
      }
      await prefs.setStringList(_favKey, favs.toList());
    } catch (e) {
      // Ignore platform errors; optionally log
      // ignore: avoid_print
      print('SharedPreferences error: $e');
    }
  }

  // User storage
  static const _userKey = 'logged_user';
  static const _cartKeyPrefix = 'cart_user_';

  static Future<void> saveUser(dynamic user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // accept either a model-like object or a Map (toJson result)
      int? id;
      String? username;
      String? email;

      if (user is Map) {
        id = (user['id'] is int)
            ? user['id'] as int
            : int.tryParse('${user['id']}');
        username = user['username']?.toString();
        email = user['email']?.toString();
      } else {
        try {
          id = user.id as int?;
        } catch (_) {
          id = null;
        }
        try {
          username = user.username as String?;
        } catch (_) {
          username = null;
        }
        try {
          email = user.email as String?;
        } catch (_) {
          email = null;
        }
      }

      final map = {'id': id, 'username': username ?? '', 'email': email ?? ''};

      await prefs.setString(_userKey, jsonEncode(map));
      // Debug saved user
      // ignore: avoid_print
      print('AppStorage: saved user ${map['username']} (id: ${map['id']})');
    } catch (e) {
      // Debug storage error
      // ignore: avoid_print
      print('AppStorage.saveUser error: $e');
    }
  }

  /// Clear all favorites
  static Future<void> clearFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_favKey);
    } catch (e) {
      // ignore: avoid_print
      print('AppStorage.clearFavorites error: $e');
    }
  }

  /// Remove stored user; optionally clear cart/favorites
  static Future<void> logout({
    bool clearCart = true,
    bool clearFavorites = false,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Remove user-specific cached cart
      if (clearCart) {
        try {
          final user = await getUserModel();
          final userId = user?.id;
          if (userId != null) {
            await prefs.remove('$_cartKeyPrefix$userId');
          }
        } catch (_) {
          // ignore
        }
      }
      if (clearFavorites) {
        await prefs.remove(_favKey);
      }
      await prefs.remove(_userKey);
    } catch (e) {
      // ignore: avoid_print
      print('AppStorage.logout error: $e');
    }
  }

  static Future<String?> getSavedUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userKey);
    } catch (_) {
      return null;
    }
  }

  /// Get stored user as [UserModel], or null
  static Future<UserModel?> getUserModel() async {
    try {
      final raw = await getSavedUser();
      if (raw == null || raw.isEmpty) return null;
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return UserModel.fromJson(decoded);
      }
      // Non-map stored value; log and return null
      // ignore: avoid_print
      print(
        'AppStorage.getUserModel: unexpected JSON type ${decoded.runtimeType}',
      );
      return null;
    } catch (e) {
      // Ignore parse errors (log)
      // ignore: avoid_print
      print('AppStorage.getUserModel error: $e');
      return null;
    }
  }

  /// Save cart JSON for user id
  static Future<void> saveCartForUser(int userId, String cartJson) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('$_cartKeyPrefix$userId', cartJson);
      // ignore: avoid_print
      print('AppStorage: saved cart for user $userId');
    } catch (e) {
      // ignore: avoid_print
      print('AppStorage.saveCartForUser error: $e');
    }
  }

  /// Get stored cart JSON for user, or null
  static Future<String?> getCartForUser(int userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString('$_cartKeyPrefix$userId');
      // Debug
      // ignore: avoid_print
      print(
        'AppStorage.getCartForUser: userId=$userId, raw=${raw?.substring(0, raw.length.clamp(0, 200))}',
      );
      return raw;
    } catch (_) {
      return null;
    }
  }
}
