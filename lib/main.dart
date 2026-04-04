import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
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

  Future<void> _bootstrapSession() async {
    final appState = FFAppState();

    if (appState.token.isEmpty) {
      _appStateNotifier.stopShowingSplashImage();
      return;
    }

    try {
      final authMe = await AuthGroup.autMeCall.call(
        token: appState.token,
      );

      if (!(authMe.succeeded)) {
        appState.token = '';
        _appStateNotifier.stopShowingSplashImage();
        return;
      }

      appState.user = UserStruct.maybeFromMap((authMe.jsonBody ?? ''))!;

      final results = await Future.wait([
        InventoryGroup.inventoryCall.call(),
        BranchGroup.branchListCall.call(),
        InventoryCategoryGroup.getInventoryCategoryCall.call(),
      ]);

      final inventoryResponse = results[0];
      final branchResponse = results[1];
      final inventoryCategoryResponse = results[2];

      if (inventoryResponse.succeeded) {
        appState.allInventory = ((inventoryResponse.jsonBody ?? '')
                .toList()
                .map<InventoryStruct?>(InventoryStruct.maybeFromMap)
                .toList() as Iterable<InventoryStruct?>)
            .withoutNulls
            .toList()
            .cast<InventoryStruct>();
      }

      if (branchResponse.succeeded) {
        final branchLists = ((branchResponse.jsonBody ?? '')
                .toList()
                .map<BranchStruct?>(BranchStruct.maybeFromMap)
                .toList() as Iterable<BranchStruct?>)
            .withoutNulls
            .toList()
            .cast<BranchStruct>();

        appState.branchLists = branchLists;
        if (!appState.branchLists.any((e) => e.id == 0)) {
          appState.addToBranchLists(BranchStruct(
            id: 0,
            label: 'All Dentabay',
          ));
        }
        appState.branchIdUser = valueOrDefault<int>(
          appState.branchLists
              .where((e) => e.label == appState.user.branch)
              .toList()
              .firstOrNull
              ?.id,
          0,
        );
        appState.setActiveBranch(
          id: appState.isHQUser ? 0 : appState.branchIdUser,
          label: appState.isHQUser ? 'All Dentabay' : appState.user.branch,
          notify: false,
        );
      }

      if (inventoryCategoryResponse.succeeded) {
        appState.inventoryCategoryLists =
            ((inventoryCategoryResponse.jsonBody ?? '')
                    .toList()
                    .map<InventoryCategoryStruct?>(
                        InventoryCategoryStruct.maybeFromMap)
                    .toList() as Iterable<InventoryCategoryStruct?>)
                .withoutNulls
                .toList()
                .cast<InventoryCategoryStruct>();
      }
    } catch (_) {
      appState.token = '';
    } finally {
      _appStateNotifier.stopShowingSplashImage();
    }
  }

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);

    _bootstrapSession();
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
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF4F7F6),
          foregroundColor: Color(0xFF152627),
          elevation: 0,
          centerTitle: false,
          scrolledUnderElevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF152627),
            letterSpacing: -0.25,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFFFFFFF),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          hintStyle: const TextStyle(
            color: Color(0xFF8A9B9D),
            fontSize: 14,
          ),
          labelStyle: const TextStyle(
            color: Color(0xFF607476),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFD7E2E0), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFD7E2E0), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF0E8C7D), width: 1.4),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFD55C5C), width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFD55C5C), width: 1.2),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFFFFFFFF),
          selectedItemColor: Color(0xFF0E8C7D),
          unselectedItemColor: Color(0xFF7B8D90),
          selectedLabelStyle: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.1,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
          elevation: 8,
          type: BottomNavigationBarType.fixed,
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
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F191A),
          foregroundColor: Color(0xFFF2F7F6),
          elevation: 0,
          centerTitle: false,
          scrolledUnderElevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFFF2F7F6),
            letterSpacing: -0.25,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF152224),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          hintStyle: TextStyle(
            color: Color(0xFF839A9C),
            fontSize: 14,
          ),
          labelStyle: TextStyle(
            color: Color(0xFF9CB1B2),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Color(0xFF243537), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Color(0xFF243537), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Color(0xFF35C9B8), width: 1.4),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Color(0xFFFF7A7A), width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Color(0xFFFF7A7A), width: 1.2),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF152224),
          selectedItemColor: Color(0xFF35C9B8),
          unselectedItemColor: Color(0xFF89A0A2),
          selectedLabelStyle: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.1,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
          elevation: 10,
          type: BottomNavigationBarType.fixed,
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
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).bottomNavigationBarTheme.backgroundColor ??
              FlutterFlowTheme.of(context).secondaryBackground,
          border: Border(
            top: BorderSide(
              color: FlutterFlowTheme.of(context).alternate,
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0x26000000)
                  : const Color(0x120A1718),
              blurRadius: 18,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (i) => safeSetState(() {
            _currentPage = null;
            _currentPageName = tabs[i].pageName;
          }),
          backgroundColor:
              Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          selectedItemColor:
              Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
          unselectedItemColor:
              Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
          selectedLabelStyle:
              Theme.of(context).bottomNavigationBarTheme.selectedLabelStyle,
          unselectedLabelStyle:
              Theme.of(context).bottomNavigationBarTheme.unselectedLabelStyle,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: tabs.map((e) => e.item).toList(),
        ),
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
