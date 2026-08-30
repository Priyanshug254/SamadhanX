import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/network/api_client.dart';
import 'core/services/location_service.dart';
import 'core/services/media_service.dart';
import 'core/services/notification_service.dart';
import 'core/storage/secure_storage_service.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/challenge_repository.dart';
import 'data/repositories/domain_repository.dart';
import 'presentation/screens/challenge/challenge_detail_screen.dart';
import 'presentation/screens/splash/splash_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/challenge_provider.dart';
import 'providers/domain_provider.dart';
import 'providers/notification_provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase before the Flutter application starts
  try {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  } catch (e) {
    debugPrint('Firebase initialization note: $e');
  }

  // Core Services
  final storageService = SecureStorageService();
  
  late AuthProvider authProvider;
  
  final apiClient = ApiClient(
    storageService,
    onUnauthorized: () {
      authProvider.handleUnauthorized();
    },
  );

  // Push Notification & Device Services
  final notificationService = NotificationService(apiClient, storageService);
  final locationService = LocationService();
  final mediaService = MediaService(apiClient);

  // Initialize push notification listener & deep linking
  await notificationService.initialize(
    onNavigate: (referenceType, referenceId) {
      if (referenceType == 'CHALLENGE' && referenceId.isNotEmpty) {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => ChallengeDetailScreen(challengeId: referenceId),
          ),
        );
      }
    },
  );

  // Repositories
  final authRepository = AuthRepository(apiClient, storageService);
  final domainRepository = DomainRepository(apiClient);
  final challengeRepository = ChallengeRepository(apiClient);

  // Providers
  authProvider = AuthProvider(authRepository, notificationService);
  final domainProvider = DomainProvider(domainRepository);
  final challengeProvider = ChallengeProvider(challengeRepository);
  final notificationProvider = NotificationProvider(apiClient);

  runApp(
    MultiProvider(
      providers: [
        Provider<ApiClient>.value(value: apiClient),
        Provider<NotificationService>.value(value: notificationService),
        Provider<LocationService>.value(value: locationService),
        Provider<MediaService>.value(value: mediaService),
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ChangeNotifierProvider<DomainProvider>.value(value: domainProvider),
        ChangeNotifierProvider<ChallengeProvider>.value(value: challengeProvider),
        ChangeNotifierProvider<NotificationProvider>.value(value: notificationProvider),
      ],
      child: const SamadhanXCitizenApp(),
    ),
  );
}

class SamadhanXCitizenApp extends StatelessWidget {
  const SamadhanXCitizenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'SamadhanX Citizen',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
