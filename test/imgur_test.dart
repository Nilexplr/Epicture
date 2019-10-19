import 'package:epicture/API/imgur.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:io';

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
        var toto = await img.accountGalleryFavorites();
        expect(toto.success, true);
      });

      test("Test image", () async {
        Imgur img = Imgur('ca42024bf4b47ff',
          '3688f84bd14578f16f3848bdd8fef68385df0a3e'
        );
        await img.authentificateClient('90f925e2dfb00b0869804f78d0487806bd453af6');
        var toto = await img.accountImage();
        expect(toto.success, true);
      });
      test("Test gallery favorites", () async {
        Imgur img = Imgur('ca42024bf4b47ff',
          '3688f84bd14578f16f3848bdd8fef68385df0a3e'
        );
        await img.authentificateClient('90f925e2dfb00b0869804f78d0487806bd453af6');
        var toto = await img.accountGalleryFavorites();
        expect(toto.success, true);
      });
      test("Test user favorites", () async {
        Imgur img = Imgur('ca42024bf4b47ff',
          '3688f84bd14578f16f3848bdd8fef68385df0a3e'
        );
        await img.authentificateClient('90f925e2dfb00b0869804f78d0487806bd453af6');
        var toto = await img.accountFavorites();
        expect(toto.success, true);
      });
    });
    group("album", () {
      test("Test get Album", () async {
        Imgur img = Imgur('ca42024bf4b47ff',
          '3688f84bd14578f16f3848bdd8fef68385df0a3e'
        );
        await img.authentificateClient('90f925e2dfb00b0869804f78d0487806bd453af6');
        var toto = await img.getAlbum('tynSLHI');
        expect(toto.success, true);
      });
      test("Test get images of album", () async {
        Imgur img = Imgur('ca42024bf4b47ff',
          '3688f84bd14578f16f3848bdd8fef68385df0a3e'
        );
        await img.authentificateClient('90f925e2dfb00b0869804f78d0487806bd453af6');
        var toto = await img.albumImages('tynSLHI');
        expect(toto.success, true);
      });
      test("Test get an image in an album", () async {
        Imgur img = Imgur('ca42024bf4b47ff',
          '3688f84bd14578f16f3848bdd8fef68385df0a3e'
        );
        await img.authentificateClient('90f925e2dfb00b0869804f78d0487806bd453af6');
        var toto = await img.albumImage('tynSLHI', 'xWLbpsX');
        expect(toto.success, true);
      });
    });
    group("Gallery request", () {
      test("Test get Gallery", () async {
        Imgur img = Imgur('ca42024bf4b47ff',
          '3688f84bd14578f16f3848bdd8fef68385df0a3e'
        );
        await img.authentificateClient('90f925e2dfb00b0869804f78d0487806bd453af6');
        var toto = await img.getGallery();
        expect(toto.success, true);
      });
      test("Test get Gallery Album", () async {
        Imgur img = Imgur('ca42024bf4b47ff',
          '3688f84bd14578f16f3848bdd8fef68385df0a3e'
        );
        await img.authentificateClient('90f925e2dfb00b0869804f78d0487806bd453af6');
        var toto = await img.getGalleryAlbum('tynSLHI');
        expect(toto.success, true);
      });
      test("Test get Tags", () async {
        Imgur img = Imgur('ca42024bf4b47ff',
          '3688f84bd14578f16f3848bdd8fef68385df0a3e'
        );
        await img.authentificateClient('90f925e2dfb00b0869804f78d0487806bd453af6');
        var toto = await img.getTags();
        expect(toto.success, true);
      });
      test("Test get Gallery Tags", () async {
        Imgur img = Imgur('ca42024bf4b47ff',
          '3688f84bd14578f16f3848bdd8fef68385df0a3e'
        );
        await img.authentificateClient('90f925e2dfb00b0869804f78d0487806bd453af6');
        var toto = await img.getGalleryByTag("cats");
        expect(toto.success, true);
      });
      test("Test search Gallery Tags", () async {
        Imgur img = Imgur('ca42024bf4b47ff',
          '3688f84bd14578f16f3848bdd8fef68385df0a3e'
        );
        await img.authentificateClient('90f925e2dfb00b0869804f78d0487806bd453af6');
        var toto = await img.searchGallery("cats");
        expect(toto.success, true);
      });
    });
    group("Image request", () {
      test("Test get Image", () async {
        Imgur img = Imgur('ca42024bf4b47ff',
          '3688f84bd14578f16f3848bdd8fef68385df0a3e'
        );
        await img.authentificateClient('90f925e2dfb00b0869804f78d0487806bd453af6');
        var toto = await img.getImage("9R3tBRY");
        expect(toto.success, true);
      });
      test("Test add to favorite", () async {
        Imgur img = Imgur('ca42024bf4b47ff',
          '3688f84bd14578f16f3848bdd8fef68385df0a3e'
        );
        await img.authentificateClient('90f925e2dfb00b0869804f78d0487806bd453af6');
        var toto = await img.favorite("9R3tBRY");
        expect(toto.success, true);
      });
      test("Test add image", () async {
        Imgur img = Imgur('ca42024bf4b47ff',
          '3688f84bd14578f16f3848bdd8fef68385df0a3e'
        );
        await img.authentificateClient('90f925e2dfb00b0869804f78d0487806bd453af6');
        var toto = await img.uploadImage(img.transformFileImage(File("/home/nicolas/Images/test.png")), "");
        print(toto.success);
        expect(toto.success, true);
      });
    });
  });
  group('imgur bouton', () {

  });
}
