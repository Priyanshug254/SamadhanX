import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/api_response.dart';
import '../../data/models/challenge_models.dart';
import '../network/api_client.dart';

class MediaService {
  final ApiClient _apiClient;
  final ImagePicker _imagePicker = ImagePicker();

  MediaService(this._apiClient);

  Future<AttachmentDto?> pickAndUploadImage({
    ImageSource source = ImageSource.gallery,
    String? caption,
  }) async {
    try {
      final XFile? picked = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (picked == null) return null;

      final fileBytes = await picked.readAsBytes();
      final fileName = picked.name;

      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          fileBytes,
          filename: fileName,
        ),
      });

      final response = await _apiClient.post(
        '/api/v1/files/upload',
        data: formData,
      );

      final apiResponse = ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => json as Map<String, dynamic>,
      );

      if (apiResponse.data != null) {
        final data = apiResponse.data!;
        return AttachmentDto(
          mediaType: data['mediaType']?.toString() ?? 'IMAGE',
          fileName: data['originalFileName']?.toString() ?? fileName,
          fileUrl: data['fileUrl']?.toString() ?? '',
          fileSizeBytes: data['fileSizeBytes'] is num ? (data['fileSizeBytes'] as num).toInt() : fileBytes.length,
          caption: caption,
        );
      }
    } catch (e) {
      debugPrint('Error uploading image: $e');
      rethrow;
    }
    return null;
  }

  Future<AttachmentDto?> pickAndUploadDocument({String? caption}) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'png', 'jpg', 'jpeg'],
        withData: true,
      );

      if (result == null || result.files.isEmpty) return null;
      final file = result.files.first;

      if (file.bytes == null) {
        if (file.path != null) {
          final ioFile = File(file.path!);
          final bytes = await ioFile.readAsBytes();
          final formData = FormData.fromMap({
            'file': MultipartFile.fromBytes(bytes, filename: file.name),
          });
          return await _uploadFormData(formData, file.name, caption, bytes.length);
        }
        return null;
      }

      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          file.bytes!,
          filename: file.name,
        ),
      });

      return await _uploadFormData(formData, file.name, caption, file.size);
    } catch (e) {
      debugPrint('Error uploading document: $e');
      rethrow;
    }
  }

  Future<AttachmentDto?> _uploadFormData(
    FormData formData,
    String fileName,
    String? caption,
    int byteSize,
  ) async {
    final response = await _apiClient.post(
      '/api/v1/files/upload',
      data: formData,
    );

    final apiResponse = ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json as Map<String, dynamic>,
    );

    if (apiResponse.data != null) {
      final data = apiResponse.data!;
      return AttachmentDto(
        mediaType: data['mediaType']?.toString() ?? 'DOCUMENT',
        fileName: data['originalFileName']?.toString() ?? fileName,
        fileUrl: data['fileUrl']?.toString() ?? '',
        fileSizeBytes: data['fileSizeBytes'] is num ? (data['fileSizeBytes'] as num).toInt() : byteSize,
        caption: caption,
      );
    }
    return null;
  }
}
