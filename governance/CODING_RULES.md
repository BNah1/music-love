# Project Coding Rules

Project: `music-love`  
Stack: `Dart 3.8 / Flutter / Riverpod / Hive / audio_service`  
Architecture: feature-first, repository/data-source boundaries, Riverpod providers

## Project-specific rules

- App is offline-first. Do not add network services, API keys, telemetry or cloud dependencies without an Owner decision.
- Keep product code under `lib/`; keep framework records under `governance/`, `project_management/`, `skills/` and `.agent_logs/`.
- Follow existing Dart style and run `dart format` on changed Dart files.
- Preserve uncommitted user changes; do not reset or overwrite unrelated files.

## Commands

- Build: `flutter build apk --debug` (device/toolchain dependent)
- Test: `flutter test`
- Lint/static analysis: `flutter analyze`
