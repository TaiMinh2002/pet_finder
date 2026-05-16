import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class CloudinaryAvatarService {
  CloudinaryAvatarService({http.Client? client})
    : _client = client ?? http.Client();

  static const _cloudName = 'dopqsirii';
  static const _uploadPreset = 'pet_finder';
  static final _allowedExtensions = {'jpg', 'jpeg', 'png', 'webp'};

  final http.Client _client;

  Future<String> uploadAvatar(File file) async {
    final extension = file.path.split('.').last.toLowerCase();
    if (!_allowedExtensions.contains(extension)) {
      throw const AvatarUploadFailure('Ảnh phải là jpg, jpeg, png hoặc webp.');
    }

    final request =
        http.MultipartRequest(
            'POST',
            Uri.parse(
              'https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
            ),
          )
          ..fields['upload_preset'] = _uploadPreset
          ..fields['folder'] = 'pet_finder/avatars'
          ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await _client.send(request);
    final body = await response.stream.bytesToString();
    final payload = jsonDecode(body) as Map<String, dynamic>;

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw AvatarUploadFailure(
        (payload['error'] as Map<String, dynamic>?)?['message'] as String? ??
            'Không thể tải ảnh đại diện lên.',
      );
    }

    final secureUrl = payload['secure_url'] as String?;
    if (secureUrl == null || secureUrl.isEmpty) {
      throw const AvatarUploadFailure('Cloudinary không trả về URL ảnh.');
    }
    return secureUrl;
  }
}

class AvatarUploadFailure implements Exception {
  const AvatarUploadFailure(this.message);

  final String message;
}
