# user_list_assignment

A Flutter application that fetches and displays users from [ReqRes](https://reqres.in/) with pagination, local search, detailed user profiles, offline caching, and graceful error handling.

## Features
- **User List & Detail:** Browse paginated users with avatars, navigate to a detail view that highlights email and a friendly placeholder phone number.
- **Local Search:** Filter the in-memory list instantly without additional network calls.
- **Infinite Scroll & Pull-to-Refresh:** Loads more users when you reach the bottom and supports manual refresh gestures.
- **Offline Experience:** Hive caches the latest successful response so previously viewed users are shown even when the network is unavailable.
- **Robust Error States:** Clear messaging for API failures, connectivity loss, and empty responses with retry actions.

## Architecture
The project follows a pragmatic, feature-driven structure:
```
lib/
├── core/            # Configuration, dependency injection, networking, error types
├── data/            # Models and services (API + cache)
├── features/
│   └── user_list/   # Domain Riverpod notifier, UI screens, and widgets
│   └── user_detail/ 
└── routes.dart      # App routes
```
`flutter_riverpod` manages UI state, `dio` handles networking, `get_it` wires dependencies, and `hive_flutter` powers caching.

## Getting Started
1. Install Flutter (3.9.2 or later).
2. Run `flutter pub get` to install dependencies.
3. Launch the app with `flutter run` (mobile or web).

## Testing & Analysis
- Static analysis: `flutter analyze`
- Widget tests currently exercise a minimal smoke test (`flutter test`). Note that network access is required at runtime, so consider mocking services before extending tests.

## Notes
- The ReqRes API requires the `x-api-key: reqres-free-v1` header; this is configured in `DioClient`.
- Cached data lives in the Hive box named `users_box`. Clearing the app data removes the cache.