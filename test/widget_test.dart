import 'package:flutter_test/flutter_test.dart';
import 'package:plant_disease_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PlantDiseaseApp());
  });
}
