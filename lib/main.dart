import 'package:flutter/material.dart';
import 'package:epicture/login.dart';
import 'dart:convert';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:url_launcher/url_launcher.dart';
import 'package:epicture/API/imgur.dart';

void main() => runApp(MyApp());
  // Imgur imgur = new Imgur("ca42024bf4b47ff", "3688f84bd14578f16f3848bdd8fef68385df0a3e");
  // await imgur.authentificateClient('d107b4fa46bf7a727872ba5f3b9f5a76e26d82a3');
  // print(await imgur.accountBase().then((ImgurResponse res) {
    // return res.data;
  // }));