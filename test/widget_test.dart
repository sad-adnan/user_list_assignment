// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_list_assignment/data/models/pagination_response.dart';
import 'package:user_list_assignment/data/models/user_model.dart';
import 'package:user_list_assignment/data/services/api_service.dart';
import 'package:user_list_assignment/data/services/cache_service.dart';
import 'package:user_list_assignment/features/user_list/domain/user_list_notifier.dart';
import 'package:user_list_assignment/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Shows the user list screen title', (WidgetTester tester) async {
    final apiService = FakeApiService();
    final cacheService = FakeCacheService();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          apiServiceProvider.overrideWithValue(apiService),
          cacheServiceProvider.overrideWithValue(cacheService),
        ],
        child: const UserListAssignmentApp(),
      ),
    );

    expect(find.text('Users'), findsOneWidget);
  });
}

class FakeApiService extends ApiService {
  FakeApiService() : super(Dio());

  @override
  Future<PaginationResponse<User>> getUsers({
    required int page,
    int perPage = 10,
  }) async {
    return PaginationResponse<User>(
      page: page,
      perPage: perPage,
      total: 1,
      totalPages: 1,
      data: const [
        User(
          id: 1,
          email: 'test@example.com',
          firstName: 'Test',
          lastName: 'User',
          avatar: '',
        ),
      ],
    );
  }
}

class FakeCacheService extends CacheService {
  List<User> _users = const [];
  DateTime? _lastUpdated;

  @override
  Future<void> init() async {}

  @override
  Future<void> saveUsers(List<User> users) async {
    _users = List<User>.unmodifiable(users);
    _lastUpdated = DateTime.now();
  }

  @override
  List<User> getUsers() => _users;

  @override
  DateTime? getLastUpdated() => _lastUpdated;

  @override
  bool isCacheStale(Duration maxAge) => true;
}
