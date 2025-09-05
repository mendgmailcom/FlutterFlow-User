import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/nav/nav.dart';

import 'custom_code/services/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize service locator
  await _setupServiceLocator();

  // Initialize services
  await _initializeServices();

  runApp(const MyApp());
}

Future<void> _setupServiceLocator() async {
  try {
    // Setup service locator
    await ServiceLocator.setup();
  } catch (e, stackTrace) {
    ErrorHandler()
        .handleException(e, stackTrace, context: 'Setup service locator');
  }
}

Future<void> _initializeServices() async {
  try {
    // Initialize notification service
    await NotificationService().init();

    // Initialize analytics service
    await AnalyticsService().initialize();

    // Initialize cache service
    await CacheService().initialize();

    // Initialize network service
    await NetworkService().initialize();

    // Initialize auth service
    await AuthService().initialize();

    // Initialize FlutterFlow theme
    await FlutterFlowTheme.initialize();
  } catch (e, stackTrace) {
    ErrorHandler()
        .handleException(e, stackTrace, context: 'Initialize services');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  State<MyApp> createState() => MyAppState();

  static MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>()!;
}

class MyAppState extends State<MyApp> {
  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);

    // Log app session start
    AnalyticsService().logSessionStart();
  }

  @override
  void dispose() {
    // Log app session end
    AnalyticsService().logSessionEnd();

    // Dispose services
    AuthService().dispose();

    super.dispose();
  }

  void setThemeMode(ThemeMode mode) {
    setState(() {
      FlutterFlowTheme.saveThemeMode(mode);
    });
  }

  String getRoute() {
    return _router.routerDelegate.currentConfiguration.uri.toString();
  }

  List<String> getRouteStack() {
    // For simplicity, return current route. In a full implementation,
    // this would return the navigation stack
    return [getRoute()];
  }

  @override
  Widget build(BuildContext context) {
    // Initialize theme
    FlutterFlowTheme.initialize();

    return ChangeNotifierProvider.value(
      value: _appStateNotifier,
      child: MaterialApp.router(
        title: 'HandyHelp',
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en', '')],
        theme: FlutterFlowTheme.of(context).themeData,
        darkTheme: FlutterFlowTheme.of(context).darkThemeData,
        themeMode: FlutterFlowTheme.themeMode,
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
