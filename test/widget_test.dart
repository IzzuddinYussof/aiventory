import 'package:aiventory/flutter_flow/flutter_flow_theme.dart';
import 'package:aiventory/flutter_flow/flutter_flow_util.dart';
import 'package:aiventory/login/login_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Login screen renders without persisted auth',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await FlutterFlowTheme.initialize();

    FFAppState.reset();
    final appState = FFAppState();
    await appState.initializePersistedState();
    appState.token = '';

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
}
