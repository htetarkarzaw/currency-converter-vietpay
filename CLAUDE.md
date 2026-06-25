# Currency Converter — Vietpay Assessment

## Stack
- Flutter + Dart
- BLoC (flutter_bloc)
- Drift (local DB — single source of truth)
- Dio (networking)
- GetIt (DI)
- Material3

## Architecture
Clean Architecture: data / domain / presentation
- data: API calls, Drift DB, repository implementations
- domain: models, repository interfaces (pure Dart, no Flutter imports)
- presentation: BLoC, screens, widgets

## Rules
- Never use StatefulWidget where a Bloc/Cubit exists
- All colors via ThemeData ColorScheme tokens — no hardcoded hex
- Single source of truth: Drift only, never read from network in UI
- Every Bloc must have a corresponding bloc_test file
