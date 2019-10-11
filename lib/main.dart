import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

main() async {
  var client = getClient();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context){
    // doSomeAction();
    return MaterialApp(
      title: 'hello',
      home: Scaffold(
        body: Container(
          child: Center(
            child: Text('hello'),
          ),
        ),
      )
    );
  }
}

final authorizationEndpoint =
    Uri.parse("https://api.imgur.com/oauth2/authorize");
final tokenEndpoint =
    Uri.parse("https://api.imgur.com/oauth2/token");

// The authorization server will issue each client a separate client
// identifier and secret, which allows the server to tell which client
// is accessing it. Some servers may also have an anonymous
// identifier/secret pair that any client may use.
//
// Note that clients whose source code or binary executable is readily
// available may not be able to make sure the client secret is kept a
// secret. This is fine; OAuth2 servers generally won't rely on knowing
// with certainty that a client is who it claims to be.
final identifier = "ca42024bf4b47ff";
final secret = "3688f84bd14578f16f3848bdd8fef68385df0a3e";

// This is a URL on your application's server. The authorization server
// will redirect the resource owner here once they've authorized the
// client. The redirection will include the authorization code in the
// query parameters.
final redirectUrl = Uri.parse("https://www.getpostman.com/oauth2/callback");

/// A file in which the users credentials are stored persistently. If the server
/// issues a refresh token allowing the client to refresh outdated credentials,
/// these may be valid indefinitely, meaning the user never has to
/// re-authenticate.
final credentialsFile = new File("~/credentials.json");

/// Either load an OAuth2 client from saved credentials or authenticate a new
/// one.
Future<oauth2.Client> getClient() async {
  var exists = await credentialsFile.exists();

  // If the OAuth2 credentials have already been saved from a previous run, we
  // just want to reload them.
  if (exists) {
    var credentials = new oauth2.Credentials.fromJson(
        await credentialsFile.readAsString());
    return new oauth2.Client(credentials,
        identifier: identifier, secret: secret);
  }

  // If we don't have OAuth2 credentials yet, we need to get the resource owner
  // to authorize us. We're assuming here that we're a command-line application.
  var grant = new oauth2.AuthorizationCodeGrant(
      identifier, authorizationEndpoint, tokenEndpoint,
      secret: secret);

  // Redirect the resource owner to the authorization URL. This will be a URL on
  // the authorization server (authorizationEndpoint with some additional query
  // parameters). Once the resource owner has authorized, they'll be redirected
  // to `redirectUrl` with an authorization code.
  //
  // `redirect` is an imaginary function that redirects the resource
  // owner's browser.
  await redirect(grant.getAuthorizationUrl(redirectUrl));
  
  // Another imaginary function that listens for a request to `redirectUrl`.
  var request = await listen(redirectUrl);

  // Once the user is redirected to `redirectUrl`, pass the query parameters to
  // the AuthorizationCodeGrant. It will validate them and extract the
  // authorization code to create a new Client.
  return await grant.handleAuthorizationResponse(request.uri.queryParameters);
}


void doSomeAction() async {

  // produces a request object
  var request = await HttpClient().getUrl(Uri.parse('https://api.imgur.com/oauth2/authorize?client_id=ca42024bf4b47ff&response_type=token'));  // sends the request
  var response = await request.close(); 

  // transforms and prints the response
  await for (var contents in response.transform(Utf8Decoder())) {
    print(contents);
  }
  // Present the dialog to the user
  // print("totoo");
  // 
  // final result = await FlutterWebAuth.authenticate(url: 'https://api.imgur.com/oauth2/authorize?client_id=ca42024bf4b47ff&response_type=token', callbackUrlScheme: "getpostman");
  // print("tata");
  // Extract token from resulting url
  // final token = Uri.parse(result).queryParameters['token'];
// "https://app.getpostman.com/oauth2/callback#access_token=ca8be478cca86177b6b5cba3140d9be68bc27e05&expires_in=315360000&token_type=bearer&refresh_token=6a5dc2f48f7fc31bb38eb89c9a7424b7e58067a0&account_username=Nilexplr&account_id=115000203"
// 
  // print("hello");
  // print(token);
}