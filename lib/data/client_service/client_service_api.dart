import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ClientServiceApi {


  final String cloudinaryImageUrl =
      "https://api.cloudinary.com/v1_1/dsriserv7/image/upload";
  final uploadPreset = 'my_preset';
  Future<String?> uploadImageToCloudinary(File imageFile) async {
    var request = http.MultipartRequest("POST", Uri.parse(cloudinaryImageUrl));
    request.fields['upload_preset'] = uploadPreset;
    request.files
        .add(await http.MultipartFile.fromPath('file', imageFile.path));

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var jsonResponseString = String.fromCharCodes(responseData);
    var jsonMap = jsonDecode(jsonResponseString);

    return jsonMap['url'];
  }


}