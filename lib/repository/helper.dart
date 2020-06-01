import 'dart:convert';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;

Future<String> urlToBase64(String url) async {
  final response = await http.get(url);
  final bytes = await FlutterImageCompress.compressWithList(
    response.bodyBytes.toList(),
    minHeight: 50,
    minWidth: 50,
    quality: 70,
  );

  return base64Encode(bytes);
}
