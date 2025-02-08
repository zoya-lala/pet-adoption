import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class PetCard extends StatelessWidget {
  final String name;
  final String status;

  PetCard({required this.name, required this.status});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(status,
              style: TextStyle(
                  color: status == 'Available' ? Colors.green : Colors.red)),
        ],
      ),
    );
  }
}

void main() {
  testWidgets('PetCard should display pet name and status',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: PetCard(name: 'Buddy', status: 'Available'),
    ));

    expect(find.text('Buddy'), findsOneWidget);
    expect(find.text('Available'), findsOneWidget);
  });
}
