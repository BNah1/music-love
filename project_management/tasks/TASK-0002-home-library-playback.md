# TASK-0002 — Home library and playlist playback

Status: `PLANNED`
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
