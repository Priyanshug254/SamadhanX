import '../../core/constants/api_endpoints.dart';
import '../../core/network/api_client.dart';
import '../models/api_response.dart';
import '../models/domain_model.dart';

class DomainRepository {
  final ApiClient _apiClient;

  DomainRepository(this._apiClient);

  Future<List<DomainModel>> getAllActiveDomains() async {
    final response = await _apiClient.get(ApiEndpoints.domains);
    final apiResponse = ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (data) {
        if (data is List) {
          return data
              .map((item) => DomainModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        return <DomainModel>[];
      },
    );

    return apiResponse.data ?? [];
  }
}
