import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_constants.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/error/failures.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/cache_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) => sl<ApiService>());
final cacheServiceProvider = Provider<CacheService>((ref) => sl<CacheService>());

final userListNotifierProvider =
    NotifierProvider<UserListNotifier, UserListState>(UserListNotifier.new);

class UserListNotifier extends Notifier<UserListState> {
  late final ApiService _apiService;
  late final CacheService _cacheService;

  @override
  UserListState build() {
    _apiService = ref.read(apiServiceProvider);
    _cacheService = ref.read(cacheServiceProvider);

    final cachedUsers = _cacheService.getUsers();
    final initialState = UserListState.initial(initialUsers: cachedUsers);

    Future.microtask(initialize);
    return initialState;
  }

  Future<void> initialize() async {
    final shouldFetch = state.users.isEmpty;
    if (shouldFetch) {
      await fetchUsers();
      return;
    }

    final isStale = _cacheService.isCacheStale(AppConstants.cacheMaxAge);
    if (isStale) {
      await fetchUsers(silent: true);
    }
  }

  void updateSearch(String query) {
    final sanitized = query.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (state.searchQuery == sanitized) {
      return;
    }
    state = state.copyWith(searchQuery: sanitized);
  }

  Future<void> fetchUsers({bool silent = false}) async {
    if (state.isLoading || state.isBackgroundSyncing) {
      return;
    }

    state = state.copyWith(
      hasMoreData: true,
      currentPage: 1,
      error: null,
      isLoading: silent ? state.isLoading : true,
      isBackgroundSyncing: silent ? true : false,
    );

    try {
      final response = await _apiService.getUsers(page: state.currentPage);
      final users = response.data;
      await _cacheService.saveUsers(users);
      state = state.copyWith(
        users: users,
        hasMoreData: state.currentPage < response.totalPages,
        error: users.isEmpty ? 'No users found.' : null,
      );
    } on Exception catch (error) {
      final failure = _mapErrorToFailure(error);
      final cachedUsers = _cacheService.getUsers();
      state = state.copyWith(
        users: cachedUsers,
        error: failure.message,
      );
    } finally {
      state = state.copyWith(
        isLoading: false,
        isBackgroundSyncing: false,
      );
    }
  }

  Future<void> loadMoreUsers() async {
    if (state.isLoadingMore || !state.hasMoreData) {
      return;
    }

    state = state.copyWith(isLoadingMore: true);

    final nextPage = state.currentPage + 1;
    try {
      final response = await _apiService.getUsers(page: nextPage);
      final updatedUsers = [...state.users, ...response.data];
      await _cacheService.saveUsers(updatedUsers);
      state = state.copyWith(
        users: updatedUsers,
        currentPage: nextPage,
        hasMoreData: nextPage < response.totalPages,
        error: updatedUsers.isEmpty ? 'No users found.' : state.error,
      );
    } on Exception catch (error) {
      state = state.copyWith(error: _mapErrorToFailure(error).message);
    } finally {
      state = state.copyWith(isLoadingMore: false);
    }
  }

  Future<void> refresh() async {
    if (state.isLoading) return;
    state = state.copyWith(currentPage: 1, hasMoreData: true);
    await fetchUsers(silent: true);
  }

  Failure _mapErrorToFailure(Object error) {
    if (error is ServerException) {
      return ServerFailure(error.message);
    }
    return const ServerFailure('Unable to load users. Please try again.');
  }

}

class UserListState {
  const UserListState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMoreData = true,
    this.isBackgroundSyncing = false,
    this.currentPage = 1,
    this.searchQuery = '',
    this.users = const [],
    this.error,
  });

  factory UserListState.initial({List<User> initialUsers = const []}) {
    return UserListState(users: List<User>.unmodifiable(initialUsers));
  }

  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMoreData;
  final bool isBackgroundSyncing;
  final int currentPage;
  final String searchQuery;
  final List<User> users;
  final String? error;

  bool get hasBlockingError =>
      error != null && error != 'No users found.' && users.isEmpty;

  List<User> get filteredUsers {
    if (searchQuery.isEmpty) {
      return users;
    }

    final normalizedQuery = _normalizeText(searchQuery);
    if (normalizedQuery.isEmpty) {
      return users;
    }

    final filtered = users
        .where((user) {
          final matchesName = _normalizeText(user.fullName).contains(normalizedQuery);
          final matchesEmail = _normalizeText(user.email).contains(normalizedQuery);
          return matchesName || matchesEmail;
        })
        .toList(growable: false);

    return List<User>.unmodifiable(filtered);
  }

  UserListState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMoreData,
    bool? isBackgroundSyncing,
    int? currentPage,
    String? searchQuery,
    List<User>? users,
    String? error,
  }) {
    return UserListState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      isBackgroundSyncing: isBackgroundSyncing ?? this.isBackgroundSyncing,
      currentPage: currentPage ?? this.currentPage,
      searchQuery: searchQuery ?? this.searchQuery,
      users: users != null ? List<User>.unmodifiable(users) : this.users,
      error: error ?? this.error,
    );
  }
}

String _normalizeText(String value) {
  return value
      .toLowerCase()
      .replaceAll(_specialCharactersPattern, '')
      .trim();
}

final RegExp _specialCharactersPattern = RegExp(
  r'[^\p{L}\p{N}]',
  unicode: true,
);
