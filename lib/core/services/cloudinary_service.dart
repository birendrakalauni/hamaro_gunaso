import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class CloudinaryService {
  /// Your Cloudinary Cloud Name
  static const String cloudName = 'ft4bst4q';

  /// Unsigned Upload Preset
  static const String uploadPreset = 'hamaro_gunaso';

  Future<String?> uploadImage(File imageFile) async {
    try {
      final uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
      );

      final request = http.MultipartRequest('POST', uri);

      request.fields['upload_preset'] = uploadPreset;

      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );

      final response = await request.send();

      final responseBody = await response.stream.bytesToString();

      final data = jsonDecode(responseBody);

      if (response.statusCode == 200) {
        print("Cloudinary Upload Successful");
        print(data['secure_url']);

        return data['secure_url'];
      } else {
        print("Cloudinary Upload Failed");
        print("Status Code: ${response.statusCode}");
        print(responseBody);

        return null;
      }
    } catch (e) {
      print("Cloudinary Error: $e");
      return null;
    }
  }
}
