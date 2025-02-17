import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/widgets/snackbar.dart';

//flutter test .\test\snackbar_test.dart
void main() {
  testWidgets('Muestra el SnackBar correctamente', (WidgetTester tester) async {
    late BuildContext context;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (ctx) {
              context = ctx;
              return ElevatedButton(
                onPressed: () {
                  showCustomSnackBar(
                    context,
                    message: 'Prueba test',
                    colorPrincipal: Colors.green.shade400,
                    colorIcon: Colors.white,
                    borderColor: Colors.green,
                    icon: Icons.check_circle,
                  );
                },
                child: Text('Mostrar SnackBar'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Mostrar SnackBar'));
    await tester.pump();

    expect(find.text('Prueba test'), findsOneWidget);
    expect(find.byType(SnackBar), findsOneWidget);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsNothing);
  });
}
