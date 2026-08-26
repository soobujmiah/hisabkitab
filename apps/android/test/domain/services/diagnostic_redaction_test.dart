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
}
