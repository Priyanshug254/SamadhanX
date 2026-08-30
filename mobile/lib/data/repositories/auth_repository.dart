import 'dart:convert';
import '../../core/constants/api_endpoints.dart';
import '../../core/network/api_client.dart';
import '../../core/storage/secure_storage_service.dart';
import '../models/api_response.dart';
import '../models/auth_models.dart';

class AuthRepository {
  final ApiClient _apiClient;
  final SecureStorageService _storageService;

  AuthRepository(this._apiClient, this._storageService);

  Future<AuthResponseModel> login(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      data: {
        'email': email.trim(),
        'password': password,
      },
    );

    final apiResponse = ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (data) => AuthResponseModel.fromJson(data as Map<String, dynamic>),
    );

    if (apiResponse.data != null) {
      await _storageService.saveToken(apiResponse.data!.accessToken);
      await _storageService.saveUserJson(jsonEncode(apiResponse.data!.user.toJson()));
      return apiResponse.data!;
    } else {
      throw Exception(apiResponse.message ?? 'Authentication failed');
    }
  }

  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phoneNumber,
    String role = 'CITIZEN',
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.register,
      data: {
        'email': email.trim(),
        'password': password,
        'firstName': firstName.trim(),
        'lastName': lastName.trim(),
        if (phoneNumber != null && phoneNumber.isNotEmpty) 'phoneNumber': phoneNumber.trim(),
        'role': role,
      },
    );

    final apiResponse = ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (data) => AuthResponseModel.fromJson(data as Map<String, dynamic>),
    );

    if (apiResponse.data != null) {
      await _storageService.saveToken(apiResponse.data!.accessToken);
      await _storageService.saveUserJson(jsonEncode(apiResponse.data!.user.toJson()));
      return apiResponse.data!;
    } else {
      throw Exception(apiResponse.message ?? 'Registration failed');
    }
  }

  Future<UserModel> getCurrentUser() async {
    final response = await _apiClient.get(ApiEndpoints.currentUser);
    final apiResponse = ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (data) => UserModel.fromJson(data as Map<String, dynamic>),
    );

    if (apiResponse.data != null) {
      await _storageService.saveUserJson(jsonEncode(apiResponse.data!.toJson()));
      return apiResponse.data!;
    } else {
      throw Exception('Failed to fetch user profile');
    }
  }

  Future<UserModel?> getCachedUser() async {
    final userJson = await _storageService.getUserJson();
    if (userJson != null && userJson.isNotEmpty) {
      try {
        return UserModel.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
      } catch (_) {}
    }
    return null;
  }

  Future<bool> hasValidSession() async {
    final token = await _storageService.getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> logout() async {
    await _storageService.clearAll();
  }
}
