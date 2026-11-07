import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aiventory/app_state.dart';
import 'package:aiventory/backend/api_requests/api_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await FFAppState().initializePersistedState();
    FFAppState().token = 'session-test-placeholder';
  });

  Future<Map<String, String>> sentHeaders(String url,
      {Map<String, dynamic> headers = const {}}) async {
    Map<String, String> sent = {};
    final response = await ApiManager.instance.makeApiCall(
      callName: 'auth-continuity-${DateTime.now().microsecondsSinceEpoch}',
      apiUrl: url,
      callType: ApiCallType.GET,
      headers: headers,
      client: MockClient((request) async {
        sent = request.headers;
        return http.Response('{}', 200);
      }),
    );
    expect(response.statusCode, 200);
    return sent;
  }

  test('private Xano call uses the current persisted user token', () async {
    final sent = await sentHeaders(
        'https://xqoc-ewo0-x3u2.s2.xano.io/api:s4bMNy03/inventory');
    expect(sent['authorization'], 'Bearer session-test-placeholder');
  });

  test('token changes are honored on the next call', () async {
    FFAppState().token = 'new-session-placeholder';
    final sent = await sentHeaders(
        'https://xqoc-ewo0-x3u2.s2.xano.io/api:0o-ZhGP6/inventory_listing');
    expect(sent['authorization'], 'Bearer new-session-placeholder');
  });

  test('an existing explicit authorization is preserved', () async {
    final sent = await sentHeaders(
      'https://xqoc-ewo0-x3u2.s2.xano.io/api:s4bMNy03/auth/me',
      headers: {'Authorization': 'Bearer explicit-session'},
    );
    expect(sent['authorization'], 'Bearer explicit-session');
  });

  test('user token is never added to a third-party host', () async {
    final sent = await sentHeaders('https://external.invalid/resource');
    expect(sent.containsKey('authorization'), isFalse);
  });

  test('anonymous login does not inherit an old user token', () async {
    final sent = await sentHeaders(
        'https://xqoc-ewo0-x3u2.s2.xano.io/api:s4bMNy03/auth/login');
    expect(sent.containsKey('authorization'), isFalse);
  });

  test('empty token and caller-owned headers remain unchanged', () async {
    FFAppState().token = '';
    final input = <String, dynamic>{'X-Client': 'inventory'};
    final sent = await sentHeaders(
      'https://xqoc-ewo0-x3u2.s2.xano.io/api:s4bMNy03/inventory',
      headers: input,
    );
    expect(sent.containsKey('authorization'), isFalse);
    expect(input, {'X-Client': 'inventory'});
  });
}
