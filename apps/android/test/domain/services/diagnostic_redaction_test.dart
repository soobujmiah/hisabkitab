import 'package:flutter_test/flutter_test.dart';
import 'package:songjog/domain/services/diagnostic_redaction.dart';

void main() {
  test('removes sensitive diagnostic keys', () {
    final result = DiagnosticRedaction.sanitize({
      'error': 'boom',
      'device': 'test',
      'password': 'hidden',
      'token': 'hidden',
      'api_key': 'hidden',
    });

    expect(result, {'error': 'boom', 'device': 'test'});
  });

  test('is case-insensitive and covers common secret spellings', () {
    final result = DiagnosticRedaction.sanitize({
      'Password': 'x',
      'API_KEY': 'x',
      'access_token': 'x',
      'client_secret': 'x',
      'private_key': 'x',
      'authorization': 'x',
      'bearer': 'x',
      'plain': 'kept',
    });
    expect(result, {'plain': 'kept'});
  });

  test('blocks suffixed secret keys', () {
    expect(DiagnosticRedaction.isBlockedKey('user_password'), isTrue);
    expect(DiagnosticRedaction.isBlockedKey('refresh-token'), isTrue);
    expect(DiagnosticRedaction.isBlockedKey('provider_api_key'), isTrue);
    expect(DiagnosticRedaction.isBlockedKey('session_cookie'), isTrue);
    // Ordinary keys must survive.
    expect(DiagnosticRedaction.isBlockedKey('quantity'), isFalse);
    expect(DiagnosticRedaction.isBlockedKey('keyboard'), isFalse);
    expect(DiagnosticRedaction.isBlockedKey('token_count'), isFalse);
  });

  test('redacts nested maps and lists recursively', () {
    final result = DiagnosticRedaction.sanitize({
      'outer': {
        'safe': 1,
        'inner': {
          'password': 'nested-secret',
          'deeper': [
            {'api_key': 'in-list-secret', 'safe': true},
          ],
        },
      },
      'top_token': 'secret',
    });

    expect(result.containsKey('top_token'), isFalse);
    final outer = result['outer'] as Map<String, Object?>;
    expect(outer['safe'], 1);
    final inner = outer['inner'] as Map<String, Object?>;
    expect(inner.containsKey('password'), isFalse);
    final deeper = (inner['deeper'] as List).single as Map<String, Object?>;
    expect(deeper.containsKey('api_key'), isFalse);
    expect(deeper['safe'], true);
  });
}
