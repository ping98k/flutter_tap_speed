import 'dart:async';
import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Stopwatch sw = Stopwatch();
  Timer timer;
  List listReq, listPass, listErr;
  double count = 3.0;
  Random rng = new Random();
  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() {
    _stopTimer();
    sw.reset();
    listReq = List();
    listPass = List();
    listErr = List();
    while (listReq.length < count) {
      var i = rng.nextInt(9);
      if (listReq.contains(i)) continue;
      listReq.add(i);
    }
    print(listReq);
    setState(() {});
  }

  _colorSw(int i) {
    if (listReq.contains(i)) return Colors.grey;
    if (listPass.contains(i)) return Colors.blue;
    if (listErr.contains(i)) return Colors.red;
    return Colors.grey[300];
  }

  _onPress(int i) {
    if (listPass.length == 0 && listErr.length == 0) {
      _startTimer();
    }
    if (listReq.contains(i)) {
      listReq.remove(i);
      listPass.add(i);
    } else {
      listReq.remove(i);
      listPass.remove(i);
      listErr.add(i);
    }
    if (listReq.length == 0) {
      _stopTimer();
    }

    setState(() {});
  }

  _stopTimer() {
    try {
      sw.stop();
      timer.cancel();
    } catch (_) {}
  }

  _startTimer() {
    sw.reset();
    sw.start();
    timer = Timer.periodic(Duration(milliseconds: (1000 / 60).round()), (timer) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              Duration(microseconds: sw.elapsedMicroseconds).toString(),
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              height: 50,
            ),
            for (var i = 0; i <= 2; i++)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  for (var ii = 0; ii <= 2; ii++)
                    SqButton(color: _colorSw(ii + i * 3), onPressed: () => _onPress(ii + i * 3)),
                ],
              ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    if (sw.isRunning) {
                      _stopTimer();
                      setState(() {});
                    } else {
                      _startTimer();
                    }
                  },
                  child: sw.isRunning ? Text("Stop") : Text("Start"),
                ),
                FlatButton(
                  onPressed: () {
                    _stopTimer();
                    _init();
                  },
                  child: Text("Reset"),
                )
              ],
            ),
           
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Slider(
                divisions: 8,
                min: 1,
                max: 9,
                value: count,
                onChanged: (value) {
                  count = value;
                  _init();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SqButton extends StatelessWidget {
  SqButton({this.color, this.onPressed});
  Function onPressed;
  Color color;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: Container(
        margin: EdgeInsets.all(5),
        child: FlatButton(
          onPressed: onPressed,
          color: color,
          child: Text(""),
        ),
      ),
    );
  }
}
