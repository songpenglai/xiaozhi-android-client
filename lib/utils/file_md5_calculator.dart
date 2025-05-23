import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

class FileMd5Calculator {
  // 同步计算文件MD5（适用于小文件）
  static String calculateSync(String filePath) {
    final file = File(filePath);
    if (!file.existsSync()) {
      throw FileSystemException('File not found', filePath);
    }
    return calculateFileSync(file);
  }

  static String calculateFileSync(File file) {
    final bytes = file.readAsBytesSync();
    final digest = md5.convert(bytes);
    return digest.toString();
  }

  // 异步计算文件MD5（适用于大文件，避免阻塞UI）
  static Future<String> calculate(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw FileSystemException('File not found', filePath);
    }

    final stream = file.openRead();
    final digest = await md5.bind(stream).first;
    return digest.toString();
  }

  // 从字节数据计算MD5
  static String fromBytes(Uint8List bytes) {
    final digest = md5.convert(bytes);
    return digest.toString();
  }

  // 从字符串计算MD5
  static String fromString(String text) {
    final bytes = utf8.encode(text);
    return fromBytes(bytes);
  }

  // 验证文件MD5
  static Future<bool> verify(String filePath, String expectedMd5) async {
    try {
      final actualMd5 = await calculate(filePath);
      return actualMd5.toLowerCase() == expectedMd5.toLowerCase();
    } catch (e) {
      print('Error verifying MD5: $e');
      return false;
    }
  }
}  