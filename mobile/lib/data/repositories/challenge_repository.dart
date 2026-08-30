import '../../core/constants/api_endpoints.dart';
import '../../core/network/api_client.dart';
import '../models/api_response.dart';
import '../models/challenge_models.dart';

class ChallengeRepository {
  final ApiClient _apiClient;

  ChallengeRepository(this._apiClient);

  Future<ChallengeDetailModel> submitChallenge(SubmitChallengeDto dto) async {
    final response = await _apiClient.post(
      ApiEndpoints.challenges,
      data: dto.toJson(),
    );

    final apiResponse = ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (data) => ChallengeDetailModel.fromJson(data as Map<String, dynamic>),
    );

    if (apiResponse.data != null) {
      return apiResponse.data!;
    } else {
      throw Exception(apiResponse.message ?? 'Failed to register societal challenge');
    }
  }

  Future<PageData<ChallengeSummaryModel>> getMySubmissions({
    int page = 0,
    int size = 20,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.mySubmissions,
      queryParameters: {
        'page': page,
        'size': size,
        'sort': 'createdAt,desc',
      },
    );

    final apiResponse = ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (data) => PageData<ChallengeSummaryModel>.fromJson(
        data as Map<String, dynamic>,
        (item) => ChallengeSummaryModel.fromJson(item),
      ),
    );

    return apiResponse.data ??
        PageData(
          content: [],
          totalElements: 0,
          totalPages: 0,
          number: 0,
          size: size,
          last: true,
        );
  }

  Future<PageData<ChallengeSummaryModel>> searchPublicChallenges({
    String? search,
    String? domainCode,
    String? status,
    String? state,
    String? district,
    int page = 0,
    int size = 20,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'size': size,
      'sort': 'createdAt,desc',
    };

    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (domainCode != null && domainCode.isNotEmpty) queryParams['domainCode'] = domainCode;
    if (status != null && status.isNotEmpty) queryParams['status'] = status;
    if (state != null && state.isNotEmpty) queryParams['state'] = state;
    if (district != null && district.isNotEmpty) queryParams['district'] = district;

    final response = await _apiClient.get(
      ApiEndpoints.challenges,
      queryParameters: queryParams,
    );

    final apiResponse = ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (data) => PageData<ChallengeSummaryModel>.fromJson(
        data as Map<String, dynamic>,
        (item) => ChallengeSummaryModel.fromJson(item),
      ),
    );

    return apiResponse.data ??
        PageData(
          content: [],
          totalElements: 0,
          totalPages: 0,
          number: 0,
          size: size,
          last: true,
        );
  }

  Future<ChallengeDetailModel> getChallengeById(String id) async {
    final response = await _apiClient.get(ApiEndpoints.challengeById(id));
    final apiResponse = ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (data) => ChallengeDetailModel.fromJson(data as Map<String, dynamic>),
    );

    if (apiResponse.data != null) {
      return apiResponse.data!;
    } else {
      throw Exception('Challenge not found');
    }
  }

  Future<ChallengeDetailModel> getChallengeByTrackingNumber(String trackingNumber) async {
    final response = await _apiClient.get(ApiEndpoints.trackByNumber(trackingNumber.trim()));
    final apiResponse = ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (data) => ChallengeDetailModel.fromJson(data as Map<String, dynamic>),
    );

    if (apiResponse.data != null) {
      return apiResponse.data!;
    } else {
      throw Exception('Challenge not found with tracking number: $trackingNumber');
    }
  }

  Future<List<TimelineEventModel>> getChallengeTimeline(String id) async {
    final response = await _apiClient.get(ApiEndpoints.challengeTimeline(id));
    final apiResponse = ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (data) {
        if (data is List) {
          return data
              .map((item) => TimelineEventModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        return <TimelineEventModel>[];
      },
    );

    return apiResponse.data ?? [];
  }

  Future<void> endorseChallenge(String id, {String? comment}) async {
    await _apiClient.post(
      ApiEndpoints.endorseChallenge(id),
      data: comment != null && comment.isNotEmpty ? {'comment': comment} : null,
    );
  }
}
