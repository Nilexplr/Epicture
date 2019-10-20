import 'package:flutter/material.dart';
import 'package:epicture/API/imgur.dart';
import 'package:epicture/logReadWrite.dart';
import 'package:flutter/services.dart';

class Settings extends StatefulWidget {
  final Imgur wrapper;

  Settings({Key key, this.wrapper}) : super(key: key);

  @override
  _Settings createState() => _Settings(wrapper: wrapper);
}

class _Settings extends State<Settings> {
  final Imgur wrapper;
  final log = new LogRW();

  _Settings({Key key, this.wrapper});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Settings"),
        ),
        body: Container(
          constraints: BoxConstraints.expand(),
          child: ListView(
            children: <Widget>[
              Container(
                child: RaisedButton(
                  child: Text('disconnect'),
                  onPressed: () {
                    log.deleteFile();
                    SystemNavigator.pop();
                    print('deconnect');
                  },
                ),
              )
            ],
          ),
        ));
  }
}
