
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class StorageDataSource {

  Future<void> requestPermission() async {
  }


  Future<void> pickFileMp3() async {
  }

}

class StorageDataSourceImpl implements StorageDataSource {
  @override
  Future<void> pickFileMp3() async {
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
      }
    } else {
      print('Người dùng đã hủy chọn file');
    }
  }

  @override
  Future<void> requestPermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

}