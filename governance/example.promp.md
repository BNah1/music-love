Đây là project `music-love`.

Hãy bắt đầu bằng cách đọc và tuân thủ:

- `AGENTS.md`
- `CONTROL.md`
- `governance/`
- `project_management/MASTER_PLAN.md`
- `project_management/tasks/TASK-0002-home-library-playback.md`
- Các skill liên quan đến development, independent review và verification

Hãy thực hiện `TASK-0002-home-library-playback` theo workflow đã cấu hình: một coder triển khai, sau đó một reviewer thực hiện review độc lập. Không cần tách planning task riêng.

Phạm vi chỉ nằm trong task này:
- Background scan thư viện nhạc local khi mở app
- Playlist hiển thị ngang trên Home
- Playlist detail
- Chọn bài, loop, shuffle
- Bottom player trên Home
- Notification playback

Giữ nguyên các thay đổi có sẵn trong working tree. Không thêm network, API key, cloud sync hoặc chức năng ngoài scope.

Bắt đầu bằng việc báo cáo ngắn:
1. Đã đọc những file nào
2. Hiện trạng code liên quan
3. Các rủi ro chính
4. Kế hoạch implementation ngắn

Sau đó triển khai coder, cập nhật canonical task, tự chuyển sang review độc lập, rồi ghi rõ findings, verification và các giới hạn còn lại.