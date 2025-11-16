import 'package:hive/hive.dart';

import '../models/user_model.dart';

class CacheService {
  static const String _userBoxName = 'users_box';
  static const String _metaBoxName = 'users_meta_box';
  static const String _lastUpdatedKey = 'last_updated';

  Box<User>? _userBox;
  Box<dynamic>? _metadataBox;

  Future<void> init() async {
    _userBox = await Hive.openBox<User>(_userBoxName);
    _metadataBox = await Hive.openBox<dynamic>(_metaBoxName);
  }

  Future<void> saveUsers(List<User> users) async {
    final box = _ensureUserBox();
    await box.clear();
    await box.addAll(users);
    await _ensureMetadataBox().put(
      _lastUpdatedKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  List<User> getUsers() {
    final box = _ensureUserBox();
    return List<User>.unmodifiable(box.values);
  }

  DateTime? getLastUpdated() {
    final timestamp = _ensureMetadataBox().get(_lastUpdatedKey) as int?;
    if (timestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  bool isCacheStale(Duration maxAge) {
    final lastUpdated = getLastUpdated();
    if (lastUpdated == null) {
      return true;
    }
    return DateTime.now().difference(lastUpdated) > maxAge;
  }

  Box<User> _ensureUserBox() {
    final box = _userBox;
    if (box == null || !box.isOpen) {
      throw StateError('CacheService has not been initialized.');
    }
    return box;
  }

  Box<dynamic> _ensureMetadataBox() {
    final box = _metadataBox;
    if (box == null || !box.isOpen) {
      throw StateError('CacheService has not been initialized.');
    }
    return box;
  }
}
