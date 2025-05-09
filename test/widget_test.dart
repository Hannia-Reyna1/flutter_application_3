import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_3/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Usa la clase principal correcta de tu aplicación (TermoApp)
    await tester.pumpWidget(TermoApp());

    // Verifica que el contador inicia en 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Simula un tap en el botón de incrementar.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verifica que el contador aumentó a 1.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}