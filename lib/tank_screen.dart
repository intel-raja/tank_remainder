import 'package:countdown_widget/countdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class MyHomeScreen extends StatefulWidget {
  MyHomeScreen({Key key}) : super(key: key);

  @override
  _MyHomeScreenState createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  CountDownController _countDownController;
  int time = 60, currenttime;
  ValueNotifier<double> percent = ValueNotifier<double>(0);

  clockTrack(Duration duration) {
    currenttime = duration.inSeconds;
    int sec, min, hrs;
    min = duration.inMinutes % 60;
    sec = duration.inSeconds % 60;
    hrs = duration.inHours;
    percent.value = 1 - (currenttime / time);
    return Text(
      '${hrs.toString().padLeft(2, '0')} : ${min.toString().padLeft(2, '0')} : ${sec.toString().padLeft(2, '0')}',
      style: TextStyle(
        fontSize: 20,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Tank Remainder'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              child: ValueListenableBuilder(
                valueListenable: percent,
                builder: (BuildContext context, double value, _) {
                  return LiquidCustomProgressIndicator(
                      value: value, // Defaults to 0.5.
                      valueColor: AlwaysStoppedAnimation(Colors
                          .blue), // Defaults to the current Theme's accentColor.
                      backgroundColor: Colors
                          .white, // Defaults to the current Theme's backgroundColor.
                      direction: Axis.vertical,
                      center: Text(
                        '${(value * 100).toStringAsFixed(0)} %',
                        style: TextStyle(fontSize: 40),
                      ), // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right).
                      shapePath: _tankShape(
                          size) // A Path object used to draw the shape of the progress indicator. The size of the progress indicator is created from the bounds of this path.
                      );
                },
              ),
            ),
            Positioned(
              left: size.width * .10,
              top: size.height * .15,
              child: Container(
                height: 150,
                width: size.width * .80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    //   color: Colors.white, //background color of box
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15.0,
                      offset: Offset(
                        10.0,
                        10.0,
                      ),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Remaining time to fill the tank',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    CountDownWidget(
                      duration: Duration(
                        seconds: time,
                      ),
                      builder: (context, duration) {
                        return clockTrack(duration);
                      },
                      onControllerReady: (controller) {
                        _countDownController = controller;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Path _tankShape(Size size) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, 0)
      ..close();
  }
}
