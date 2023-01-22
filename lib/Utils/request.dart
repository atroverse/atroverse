import 'dart:io';

import 'package:dio/dio.dart';

class request{


  static send(File file,fileName,String url)async{
  Dio? dio;
    FormData formData = FormData.fromMap({
      "image":
      await MultipartFile.fromFile(file.path, filename: file.path),
    });
   var response = await dio?.post(url, data: formData);
   return response?.data;
  }
}