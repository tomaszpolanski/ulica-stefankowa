import 'package:flutter_test/flutter_test.dart';
import 'package:ulicastefankowa/features/about/about_page.dart';

import '../../test_utils.dart';

void main() {
  testWidgets('some content', (tester) async {
    await tester.pumpPage(
      const AboutPage(),
    );

    expect(find.text('Agnieszka Jakubas'), findsOneWidget);
  });
}
