// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:epicture/imgur.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:epicture/main.dart';

void main() {
  group("imgur connection", () {
    test('user class should be created',() async {
      Imgur img = Imgur('ca42024bf4b47ff',
        '3688f84bd14578f16f3848bdd8fef68385df0a3e'
      );
      await img.authentificateClient('90f925e2dfb00b0869804f78d0487806bd453af6');
      expect(img.myUser.accountId, 115858719);
      expect(img.myUser.accessToken, "5828b01b9d8e658f90269a1b9a6ce359cab79495");
      expect(img.myUser.accountUsername, "epitest95");
      expect(img.myUser.refreshToken, "8ecc4ea72c70ed2f2b8c985444e30683291fc9d2");
      expect(img.myUser.tokenType, "bearer");   
    });

    group("account request", () {
      test("Test avatar", () async {
        Imgur img = Imgur('ca42024bf4b47ff',
          '3688f84bd14578f16f3848bdd8fef68385df0a3e'
        );
        await img.authentificateClient('90f925e2dfb00b0869804f78d0487806bd453af6');
        var toto = await img.accountAvatar();
        print(toto.success);
        expect(toto.success, true);
      });

      test("Test base", () async {
        Imgur img = Imgur('ca42024bf4b47ff',
          '3688f84bd14578f16f3848bdd8fef68385df0a3e'
        );
        await img.authentificateClient('90f925e2dfb00b0869804f78d0487806bd453af6');
        var toto = await img.accountBase();
        print(toto.success);
        expect(toto.success, true);
      });
      test("Test block", () async {
        Imgur img = Imgur('ca42024bf4b47ff',
          '3688f84bd14578f16f3848bdd8fef68385df0a3e'
        );
        await img.authentificateClient('90f925e2dfb00b0869804f78d0487806bd453af6');
        var toto = await img.accountBlocks();
        print(toto.success);
        expect(toto.success, true);
      });
      test("Test setting", () async {
        Imgur img = Imgur('ca42024bf4b47ff',
          '3688f84bd14578f16f3848bdd8fef68385df0a3e'
        );
        await img.authentificateClient('90f925e2dfb00b0869804f78d0487806bd453af6');
        var toto = await img.accountSetting();
        print(toto.success);
        expect(toto.success, true);
      });
      test("Test setting", () async {
        Imgur img = Imgur('ca42024bf4b47ff',
          '3688f84bd14578f16f3848bdd8fef68385df0a3e'
        );
        await img.authentificateClient('90f925e2dfb00b0869804f78d0487806bd453af6');
        var toto = await img.accountGalleryFavorites(0, true);
        print(toto.success);
        expect(toto.success, true);
      });
    });
  });
}
