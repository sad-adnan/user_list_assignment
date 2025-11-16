import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../routes.dart';
import '../../domain/user_list_notifier.dart';
import '../widgets/error_display_widget.dart';
import '../widgets/user_list_tile.dart';
import '../widgets/search_bar_widget.dart';

class UserListScreen extends ConsumerStatefulWidget {
  const UserListScreen({super.key});

  @override
  ConsumerState<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends ConsumerState<UserListScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final state = ref.read(userListNotifierProvider);
    if (state.searchQuery.isNotEmpty) return;
    final threshold = 200;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - threshold) {
      ref.read(userListNotifierProvider.notifier).loadMoreUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userListNotifierProvider);
    final notifier = ref.read(userListNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            tooltip: 'Refresh users',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: state.isLoading ? null : notifier.refresh,
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.hasBlockingError) {
            return Center(
              child: ErrorDisplayWidget(
                message: state.error!,
                onRetry: notifier.fetchUsers,
              ),
            );
          }

          final users = state.filteredUsers;
          final showEndOfListIndicator =
              users.isNotEmpty &&
              state.searchQuery.isEmpty &&
              !state.hasMoreData;
          final showBottomLoader =
              state.isLoadingMore && state.searchQuery.isEmpty;

          return SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                const maxContentWidth = 720.0;
                final horizontalPadding =
                    constraints.maxWidth > maxContentWidth
                        ? (constraints.maxWidth - maxContentWidth) / 2
                        : 0.0;

                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                  ),
                  child: Column(
                    children: [
                      SearchBarWidget(
                        initialValue: state.searchQuery,
                        onChanged: notifier.updateSearch,
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: state.isBackgroundSyncing
                            ? const Padding(
                                key: ValueKey('syncing'),
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: LinearProgressIndicator(minHeight: 2),
                              )
                            : const SizedBox(
                                key: ValueKey('idle'),
                                height: 2,
                              ),
                      ),
                      if (users.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          child: Row(
                            children: [
                              Text(
                                '${users.length} users',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 4),
                      Expanded(
                        child: users.isEmpty
                            ? _buildEmptyState(context, state.searchQuery)
                            : RefreshIndicator(
                                color: Theme.of(context).colorScheme.primary,
                                onRefresh: notifier.refresh,
                                child: ListView.builder(
                                  controller: _scrollController,
                                  padding: const EdgeInsets.only(bottom: 24),
                                  itemCount: users.length +
                                      (showBottomLoader ? 1 : 0) +
                                      (showEndOfListIndicator ? 1 : 0),
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  keyboardDismissBehavior:
                                      ScrollViewKeyboardDismissBehavior.onDrag,
                                  itemBuilder: (context, index) {
                                    if (index >= users.length) {
                                      final extraIndex = index - users.length;
                                      if (showBottomLoader && extraIndex == 0) {
                                        return const Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      }

                                      return const _EndOfListIndicator();
                                    }

                                    final user = users[index];
                                    return UserListTile(
                                      user: user,
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                          AppRoutes.userDetail,
                                          arguments: user,
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String searchQuery) {
    final isSearching = searchQuery.isNotEmpty;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSearching ? Icons.search_off_rounded : Icons.people_outline,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              isSearching ? 'No users found' : 'No users available',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              isSearching
                  ? 'Try adjusting your search criteria'
                  : 'Pull to refresh',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _EndOfListIndicator extends StatelessWidget {
  const _EndOfListIndicator();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.2),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.flag_outlined, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'You\'ve reached the end of the list',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
