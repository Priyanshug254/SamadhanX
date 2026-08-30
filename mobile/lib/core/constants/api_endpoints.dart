class ApiEndpoints {
  // Base URL: Default to localhost:8088 (or 10.0.2.2:8088 on Android emulator)
  static const String defaultBaseUrl = 'http://10.0.2.2:8088';
  
  // Auth
  static const String login = '/api/v1/auth/login';
  static const String register = '/api/v1/auth/register';
  static const String currentUser = '/api/v1/users/me';
  
  // Domains
  static const String domains = '/api/v1/domains';
  
  // Challenges
  static const String challenges = '/api/v1/challenges';
  static const String mySubmissions = '/api/v1/challenges/my-submissions';
  static String challengeById(String id) => '/api/v1/challenges/$id';
  static String trackByNumber(String trackingNumber) => '/api/v1/challenges/tracking/$trackingNumber';
  static String challengeTimeline(String id) => '/api/v1/challenges/$id/timeline';
  static String endorseChallenge(String id) => '/api/v1/challenges/$id/endorse';
  
  // Organizations
  static const String organizations = '/api/v1/organizations';
}
