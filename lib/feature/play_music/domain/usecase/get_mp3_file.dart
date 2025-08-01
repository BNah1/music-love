import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermission() async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
}


Future<void> pickFileMp3() async{
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['mp3'],
    allowMultiple: true
  );

  if(result != null){
    List<String> paths = result.paths.whereType<String>().toList();
    print('Người dùng chọn các file MP3:');
    for (var path in paths) {
      print(path);
      // Bạn có thể lưu lại path này để tạo playlist hoặc phát nhạc
    }
  } else {
    print('Người dùng đã hủy chọn file');
  }
}