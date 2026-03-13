import 'package:aiventory/flutter_flow/flutter_flow_theme.dart';
import 'package:aiventory/flutter_flow/flutter_flow_util.dart';
import 'package:aiventory/tracking_order/tracking_order_widget.dart';
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
  return appState;
}

Widget _buildTestApp({required FFAppState appState, String? url}) {
  return ChangeNotifierProvider.value(
    value: appState,
    child: MaterialApp(
      home: TrackingOrderWidget(
        orderID: 123,
        itemName: 'Sample Item',
        url: url,
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('TrackingOrder renders safely when url is missing',
      (WidgetTester tester) async {
    final appState = await _createInitializedAppState();

    await tester.pumpWidget(_buildTestApp(appState: appState));
    await tester.pump();

    expect(find.text('Tracking Order'), findsOneWidget);
    expect(find.text('Sample Item'), findsOneWidget);
    expect(find.byIcon(Icons.inventory_2_outlined), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('TrackingOrder renders fallback when url is invalid',
      (WidgetTester tester) async {
    final appState = await _createInitializedAppState();

    await tester.pumpWidget(
      _buildTestApp(appState: appState, url: 'not-a-valid-url'),
    );
    await tester.pump();

    expect(find.text('Tracking Order'), findsOneWidget);
    expect(find.byIcon(Icons.inventory_2_outlined), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
