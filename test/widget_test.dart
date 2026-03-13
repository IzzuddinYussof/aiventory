import 'package:aiventory/flutter_flow/flutter_flow_theme.dart';
import 'package:aiventory/flutter_flow/flutter_flow_util.dart';
import 'package:aiventory/login/login_widget.dart';
import 'package:aiventory/flutter_flow/nav/nav.dart';
import 'package:aiventory/upload_carousell/upload_carousell_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<FFAppState> _createInitializedAppState() async {
  SharedPreferences.setMockInitialValues({});
  await FlutterFlowTheme.initialize();

  FFAppState.reset();
  final appState = FFAppState();
  await appState.initializePersistedState();
  appState.token = '';
  return appState;
}

Widget _buildRouterApp(FFAppState appState, String initialLocation) {
  final appStateNotifier = AppStateNotifier.instance;
  appStateNotifier.stopShowingSplashImage();

  return ChangeNotifierProvider.value(
    value: appState,
    child: MaterialApp.router(
      routerConfig: createRouter(appStateNotifier)
        ..go(initialLocation),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Login screen renders without persisted auth',
      (WidgetTester tester) async {
    final appState = await _createInitializedAppState();

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => appState,
        child: MaterialApp(
          home: LoginWidget(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Inventory'), findsOneWidget);
  });

  testWidgets('UploadCarousell direct path without inventoryId shows guard',
      (WidgetTester tester) async {
    final appState = await _createInitializedAppState();

    await tester.pumpWidget(_buildRouterApp(appState, '/uploadCarousell'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Missing required parameter: inventoryId'),
        findsOneWidget);
  });

  testWidgets('UploadCarousell param path renders form page safely',
      (WidgetTester tester) async {
    final appState = await _createInitializedAppState();

    await tester
        .pumpWidget(_buildRouterApp(appState, '/uploadCarousell?inventoryId=1'));
    await tester.pumpAndSettle();

    expect(find.text('Upload Carousell'), findsOneWidget);
    expect(find.textContaining('Missing required parameter: inventoryId'),
        findsNothing);
  });
}
