import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  await FlutterFlowTheme.initialize();

  final appState = FFAppState(); // Initialize FFAppState
  await appState.initializePersistedState();

  runApp(ChangeNotifierProvider(
    create: (context) => appState,
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class MyAppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  String getRoute([RouteMatch? routeMatch]) {
    final RouteMatch lastMatch =
        routeMatch ?? _router.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : _router.routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }

  List<String> getRouteStack() =>
      _router.routerDelegate.currentConfiguration.matches
          .map((e) => getRoute(e))
          .toList();
  bool displaySplashImage = true;

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);

    Future.delayed(Duration(milliseconds: 1000),
        () => safeSetState(() => _appStateNotifier.stopShowingSplashImage()));
  }

  void setThemeMode(ThemeMode mode) => safeSetState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'aiventory',
      scrollBehavior: MyAppScrollBehavior(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
        scaffoldBackgroundColor: const Color(0xFFF4F7F6),
        canvasColor: const Color(0xFFF4F7F6),
        cardColor: const Color(0xFFFFFFFF),
        dividerColor: const Color(0xFFD7E2E0),
        splashColor: const Color(0x140E8C7D),
        highlightColor: Colors.transparent,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF0E8C7D),
          secondary: Color(0xFF4D6B73),
          surface: Color(0xFFFFFFFF),
          error: Color(0xFFD55C5C),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: false,
        scaffoldBackgroundColor: const Color(0xFF0F191A),
        canvasColor: const Color(0xFF0F191A),
        cardColor: const Color(0xFF152224),
        dividerColor: const Color(0xFF243537),
        splashColor: const Color(0x2235C9B8),
        highlightColor: Colors.transparent,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF35C9B8),
          secondary: Color(0xFF87A9AE),
          surface: Color(0xFF152224),
          error: Color(0xFFFF7A7A),
        ),
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}

class NavBarPage extends StatefulWidget {
  NavBarPage({
    Key? key,
    this.initialPage,
    this.page,
    this.disableResizeToAvoidBottomInset = false,
  }) : super(key: key);

  final String? initialPage;
  final Widget? page;
  final bool disableResizeToAvoidBottomInset;

  @override
  _NavBarPageState createState() => _NavBarPageState();
}

/// This is the private State class that goes with NavBarPage.
class _NavBarPageState extends State<NavBarPage> {
  String _currentPageName = 'dashboardHQ';
  late Widget? _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPageName = widget.initialPage ?? _currentPageName;
    _currentPage = widget.page;
  }

  @override
  Widget build(BuildContext context) {
    final tabs = <_NavBarTab>[
      _NavBarTab(
        pageName: 'dashboardHQ',
        page: DashboardHQWidget(),
        item: const BottomNavigationBarItem(
          icon: Icon(
            Icons.home_outlined,
            size: 24.0,
          ),
          label: 'Home',
          tooltip: '',
        ),
      ),
      _NavBarTab(
        pageName: 'findInventory',
        page: FindInventoryWidget(),
        item: const BottomNavigationBarItem(
          icon: Icon(
            Icons.search,
            size: 24.0,
          ),
          label: 'Search',
          tooltip: '',
        ),
      ),
      if (FFAppState().isHQUser)
        _NavBarTab(
          pageName: 'editInventory',
          page: EditInventoryWidget(),
          item: const BottomNavigationBarItem(
            icon: Icon(
              Icons.inventory_2_outlined,
              size: 24.0,
            ),
            label: 'Inventory',
            tooltip: '',
          ),
        ),
      _NavBarTab(
        pageName: 'StockIn',
        page: StockInWidget(),
        item: const BottomNavigationBarItem(
          icon: Icon(
            Icons.qr_code_scanner_outlined,
            size: 24.0,
          ),
          label: 'Stock ',
          tooltip: '',
        ),
      ),
      _NavBarTab(
        pageName: 'Order',
        page: OrderWidget(),
        item: const BottomNavigationBarItem(
          icon: Icon(
            Icons.shopping_cart,
            size: 24.0,
          ),
          label: 'Order ',
          tooltip: '',
        ),
      ),
      _NavBarTab(
        pageName: 'orderList',
        page: OrderListWidget(),
        item: const BottomNavigationBarItem(
          icon: Icon(
            Icons.library_books_rounded,
            size: 24.0,
          ),
          label: 'Order List',
          tooltip: '',
        ),
      ),
      _NavBarTab(
        pageName: 'Carousell',
        page: CarousellWidget(),
        item: const BottomNavigationBarItem(
          icon: Icon(
            Icons.storefront_sharp,
            size: 24.0,
          ),
          label: 'Carousell',
          tooltip: '',
        ),
      ),
    ];
    final tabNames = tabs.map((e) => e.pageName).toList();
    if (!tabNames.contains(_currentPageName)) {
      _currentPageName = tabs.first.pageName;
      _currentPage = null;
    }
    final currentIndex = tabNames.indexOf(_currentPageName);

    return Scaffold(
      resizeToAvoidBottomInset: !widget.disableResizeToAvoidBottomInset,
      body: _currentPage ?? tabs[currentIndex].page,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) => safeSetState(() {
          _currentPage = null;
          _currentPageName = tabs[i].pageName;
        }),
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        selectedItemColor: FlutterFlowTheme.of(context).primary,
        unselectedItemColor: FlutterFlowTheme.of(context).secondaryText,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: tabs.map((e) => e.item).toList(),
      ),
    );
  }
}

class _NavBarTab {
  const _NavBarTab({
    required this.pageName,
    required this.page,
    required this.item,
  });

  final String pageName;
  final Widget page;
  final BottomNavigationBarItem item;
}
