// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:epicture/imgur.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("imgur connection", () {
    test('user class should be created',() async {
      Imgur img = Imgur('ca42024bf4b47ff',
        '3688f84bd14578f16f3848bdd8fef68385df0a3e'
      );
      await img.authentificateClient('90f925e2dfb00b0869804f78d0487806bd453af6');
      expect(img.myUser.accountId, 115858719);
      expect(img.myUser.accountUsername, "epitest95");
      expect(img.myUser.tokenType, "bearer");   
    });

    group("account request", () {
      test("Test avatar", () async {
        Imgur img = Imgur('ca42024bf4b47ff',
          '3688f84bd14578f16f3848bdd8fef68385df0a3e'
        );
        await img.authentificateClient('90f925e2dfb00b0869804f78d0487806bd453af6');
        var toto = await img.accountAvatar();
        expect(toto.success, true);
      });

      test("Test base", () async {
        Imgur img = Imgur('ca42024bf4b47ff',
          '3688f84bd14578f16f3848bdd8fef68385df0a3e'
        );
        await img.authentificateClient('90f925e2dfb00b0869804f78d0487806bd453af6');
        var toto = await img.accountBase();
        expect(toto.success, true);
      });
      test("Test block", () async {
        Imgur img = Imgur('ca42024bf4b47ff',
          '3688f84bd14578f16f3848bdd8fef68385df0a3e'
        );
        await img.authentificateClient('90f925e2dfb00b0869804f78d0487806bd453af6');
        var toto = await img.accountBlocks();
        expect(toto.success, true);
      });
      test("Test setting", () async {
        Imgur img = Imgur('ca42024bf4b47ff',
          '3688f84bd14578f16f3848bdd8fef68385df0a3e'
        );
        await img.authentificateClient('90f925e2dfb00b0869804f78d0487806bd453af6');
        var toto = await img.accountSetting();
        expect(toto.success, true);
      });
      test("Test setting", () async {
        Imgur img = Imgur('ca42024bf4b47ff',
          '3688f84bd14578f16f3848bdd8fef68385df0a3e'
        );
        await img.authentificateClient('90f925e2dfb00b0869804f78d0487806bd453af6');
        var toto = await img.accountGalleryFavorites(0, true);
        expect(toto.success, true);
      });
    });
  });
}
