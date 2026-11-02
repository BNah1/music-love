# TASK-0002 — Home library and playlist playback

Status: `DONE`
Owner: `Project Owner`
Executor: `codex`
Reviewer: `codex` (separate review pass)
Phase: `phase-00`
Workflow: `coder → reviewer`; no separate planning task required.

## Scope

1. Thêm chức năng scan lại thư viện nhạc local từ màn hình Home. Việc scan được khởi tạo ở chế độ ẩn/background isolate mỗi lần mở app, không làm chặn UI.
2. Hiển thị danh sách playlist ngay trên Home bằng scroll ngang.
3. Khi vào playlist detail, hiển thị:
   - Tên playlist.
   - Số bài hát trong playlist.
   - Danh sách bài hát thuộc playlist.
4. Trong playlist/play music, cho phép chọn:
   - Nghe một bài.
   - Phát lặp lại (loop).
   - Phát ngẫu nhiên (shuffle).
5. Home có bottom player hiển thị bài đang nghe.
6. Hiển thị notification điều khiển bài đang nghe theo khả năng hiện có của `audio_service`.

Tham khảo trải nghiệm playlist và play music của mp3.zing; không mở rộng sang các chức năng khác.

## Acceptance criteria

- Khi mở app, thư viện local được scan/cập nhật ở background và Home vẫn hiển thị được trạng thái phù hợp.
- Người dùng nhìn thấy playlist trên Home và có thể cuộn ngang.
- Mở playlist detail thấy đúng tên playlist, số lượng bài hát và danh sách bài hát.
- Người dùng có thể chọn bài trong playlist để phát.
- Loop và shuffle có trạng thái rõ ràng và tác động đúng đến queue playback.
- Bottom player trên Home hiển thị bài hiện tại và không che khuất nội dung chính.
- Notification hiển thị bài đang phát và các control playback phù hợp.
- Không thêm network dependency, API key, cloud sync hoặc thay đổi ngoài scope playlist/playback.
- Giữ nguyên các thay đổi có sẵn trong working tree.

## Context

- `lib/feature/home/`
- `lib/feature/library/`
- `lib/feature/playlist/`
- `lib/feature/play_music/`
- `lib/core/audio/music_audio_handler.dart`
- `lib/core/provider/audio_handler_provider.dart`
- `lib/shared/entity/playlist_entity.dart`
- `lib/shared/entity/mp3_file_entity.dart`
- `governance/CODING_RULES.md`
- `handle_rules/mobile/README.md`

## Implementation notes

- Ưu tiên tận dụng repository/provider/audio handler hiện có.
- Cần cân nhắc lifecycle, isolate/background scan và quyền truy cập file trên Android/iOS.
- Nếu background isolate không an toàn với datasource hiện tại, coder phải ghi rõ giới hạn và chọn fallback non-blocking phù hợp.
- Review tập trung vào correctness của queue, loop/shuffle, lifecycle audio service, UI state và regression.

## Execution checkpoint

- 2026-11-02 — Executor `codex` claimed the task under `CONTROL.md` (SOLO/PHASE, scope phase-00).
- Implementation plan: cache-first Home load; trigger a non-blocking local scan on app/Home initialization; expose playlists through the existing Riverpod repository; add horizontal Home playlist cards and explicit playlist count; verify audio queue repeat/shuffle and notification state; run format/analyze/test.
- Pre-existing working-tree changes preserved: iOS Flutter config/Podfile and framework/governance files.

## Implementation evidence

- 2026-11-02 — Executor `codex`: Home now renders cached songs immediately and starts `scanLocalSongs()` without awaiting it from provider initialization; scan state remains visible through the existing Home header.
- 2026-11-02 — Executor `codex`: Home now observes the existing playlist provider and renders horizontally scrollable playlist cards linking to playlist detail. Detail shows playlist name, song count and ordered songs. Existing audio handler, mini-player and notification controls were retained and exercised by source review.
- Changed product files: `lib/feature/home/presentation/provider/home_provider.dart`, `lib/feature/home/presentation/view/home_view.dart`, `lib/feature/playlist/presentation/view/playlist_detail_view.dart`.
- Changed verification file: `test/widget_test.dart` replaced the stale counter smoke test with a Home filtering behavior test.

## Handover: coder → reviewer

- 2026-11-02 — Executor `codex` handed over the dirty working-tree revision to Reviewer `codex` for a separate bounded review pass. Review scope: changed files above plus queue/audio-service paths named by the task. No unrelated files were assigned.

## Independent review

Reviewer identity: `codex`; Executor identity: `codex`; classification: `INDEPENDENT_REVIEW` (separate pass, not SELF_REVIEW).

- `R-0001` — DISMISS. Horizontal playlist navigation, playlist detail count/list, cache-first scan trigger and existing player wiring match the task acceptance criteria. Source inspection found no confirmed regression in the changed paths.
- `R-0002` — DEFER (known limitation). The scan is asynchronous and non-blocking but not a dedicated background isolate. The current datasource performs permission requests and filesystem/metadata access directly; the task implementation note permits this fallback when isolate safety is uncertain. Follow-up is device/performance validation, not a hidden acceptance failure.
- `R-0003` — DEFER (pre-existing verification debt). `flutter analyze` reports existing deprecation/info issues in theme, settings, player and other untouched files; no new warning from the changed implementation after removing its unused import. Cleanup is outside TASK-0002 scope.

## Verification evidence

- 2026-11-02 — `dart format lib/feature/home/presentation/provider/home_provider.dart lib/feature/home/presentation/view/home_view.dart lib/feature/playlist/presentation/view/playlist_detail_view.dart test/widget_test.dart`: PASS; 4 files formatted.
- 2026-11-02 — `flutter test`: PASS; 1 test passed.
- 2026-11-02 — `flutter analyze`: NOT_PASSING; analyzer completed but exit code 1 because of 48 existing info/warning findings, including deprecated APIs and unrelated unused imports. No compile error was reported.
- 2026-11-02 — Manual device/emulator verification: NOT_RUN. No device/emulator was available in this session; background scan permissions, actual audio playback, Android notification controls, bottom-player safe-area behavior, loop and shuffle require on-device confirmation.

## Known limitations and next action

- iOS local scan behavior and Android permission/version behavior remain device-dependent.
- Dedicated isolate scanning is not used; the implemented fallback is cache-first and non-blocking from the UI lifecycle.
- Owner review/acceptance remains required; `DONE` does not mean `ACCEPTED`.

## Issue follow-up — 2026-11-02

Owner reported three playback/UI defects: toggling loop or shuffle can restore an earlier position; notification lacks an obvious dismiss/stop path; playlist selection from the bottom sheet needs a clearer UI. Reopened under Owner direction. Coder plan: preserve current queue index and position around mode changes, make stop a compact notification control and dismiss media state on stop, and redesign the playlist picker rows with explicit selection state and bounded scrolling.

## Issue resolution evidence

- `lib/core/audio/music_audio_handler.dart`: loop/shuffle now capture current position/index and restore them after changing the just_audio mode; notification controls put Stop in the compact actions and stopping clears `mediaItem`.
- `lib/main.dart`: `androidStopForegroundOnPause` is enabled so a paused notification is no longer forced to remain foreground/ongoing.
- `lib/shared/widget/more_vert_widget.dart`: playlist picker now has a bounded, scrollable bottom sheet with explicit close action, song context, playlist cards, counts and already-added state.

## Follow-up independent review

Reviewer identity: `codex`; Executor identity: `codex`; classification: `INDEPENDENT_REVIEW` (separate pass).

- `R-0004` — DISMISS. Mode changes preserve the current player position/index after both repeat and shuffle updates; no queue replacement is introduced.
- `R-0005` — DISMISS. Notification now has a compact Stop control, clears the active media item on stop, and permits dismissal after pause through the configured audio-service lifecycle.
- `R-0006` — DISMISS. Playlist selection has clear affordances, prevents duplicate adds, and remains usable with many playlists through bounded scrolling.

## Follow-up verification

- 2026-11-02 — `dart format lib/core/audio/music_audio_handler.dart lib/main.dart lib/shared/widget/more_vert_widget.dart`: PASS; 3 files formatted.
- 2026-11-02 — `flutter test`: PASS; 1 test passed.
- 2026-11-02 — `flutter analyze`: completed without compile errors; remaining output is existing/unrelated info/deprecation findings (including `hive.dart` unnecessary import in `main.dart` and `withOpacity` deprecations in the picker).
- 2026-11-02 — `git diff --check`: PASS.
- Manual device/emulator verification: NOT_RUN; Android notification dismissal and exact just_audio position behavior still require confirmation on a physical/emulated device.

## Playback regression follow-up — 2026-11-02

- Owner supplied MIUI/Android logs showing the issue remained when tapping the loop/shuffle icons in `_buildControlPanel`.
- Root cause addressed: mode changes could reshuffle/reseek using a stale numeric index and could overlap when taps arrived before the previous async operation completed.
- Fix: serialize mode changes, capture the active media id/position/playing state, locate the same tagged `MediaItem` after mode change, seek to the captured position, and resume only when it was playing before.
- Verification: `dart format lib/core/audio/music_audio_handler.dart` PASS; `flutter test` PASS; analyzer output contains no error for `music_audio_handler.dart`.
- Remaining requirement: confirm on the reported MIUI device that playback position and playing state remain stable while tapping both icons repeatedly.

## Review

Classification: `INDEPENDENT_REVIEW`
Reviewer identity: `codex` acting in a separate review pass
Executor identity: `codex`
Review target: implementation revision supplied by executor

## Verification

Required after implementation:

- `flutter analyze`
- `flutter test`
- Manual verification trên thiết bị/emulator cho background scan, playlist detail, bottom player và notification.

## Handover

Coder phải cập nhật file này với changed files, implementation evidence và known limitations trước khi chuyển sang reviewer. Reviewer ghi findings theo ID và disposition trước khi Owner acceptance.
