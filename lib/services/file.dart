import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;

class FileService {
  static Future<List<String>> pickPDFFiles() async {
    List<String> pdfFilesPath = [];

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      for (var file in result.files) {
        String? filePath = file.path;
        if (filePath != null){
          pdfFilesPath.add(filePath);
        }
      }
    } 

    return pdfFilesPath;
  }
}
