import 'dart:math';
import 'dart:typed_data';

import 'package:circular_slider_flutter/double_circular_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  ui.Image _image;

  final baseColor = Color.fromRGBO(255, 255, 255, 0.3);

  ValueKey<DateTime> forceRebuild;

  int initTime;
  int endTime;

  int inBedTime;
  int outBedTime;
  // int days = 0;

  @override
  void initState() {
    super.initState();
    // initTime = 0;
    // endTime = 144;
    // inBedTime = initTime;
    // outBedTime = endTime;
    _shuffle();
    _loadImage();
  }

  void _shuffle() {
    setState(() {
      initTime = _generateRandomTime();
      endTime = _generateRandomTime();
      inBedTime = initTime;
      outBedTime = endTime;
      print("InitTime:$initTime");
      print("InitTime:$endTime");
      print("ShuffleCalled");
    });
  }

  void _updateLabels(int init, int end, int laps) {
    print("Called");
    setState(() {

      inBedTime = init;
      outBedTime = end;

      // days = laps;
    });
  }

  _loadImage() async {
    ByteData bd = await rootBundle.load("assets/checkin.png");

    final Uint8List bytes = Uint8List.view(bd.buffer);

    final ui.Codec codec = await ui.instantiateImageCodec(bytes);

    final ui.Image image = (await codec.getNextFrame()).image;

    setState(() => _image = image);
  }


  @override
  Widget build(BuildContext context) {
    print("Build Called");
    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        title: Text("Apple"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            key: forceRebuild,
            child: DoubleCircularSlider(
              288,
              initTime,
              endTime,
              height: 260.0, //Height of Circle
              width: 260.0, //Width of Circle
              primarySectors: 0, //Main Axis cuts
              secondarySectors: 0, // Secondary Axis Cuts
              baseColor: Color(0XFFA5E6ED), //Unselected Ring Color
              selectionColor: Colors.red, // Selection Ring Color
              handlerColor: Colors.blue,
              handlerOutterRadius: 32.0,
              onSelectionChange: _updateLabels,
              onSelectionEnd: (a, b, c) => print('onSelectionEnd $a $b $c'),
              sliderStrokeWidth: 30.0,
              shouldCountLaps: false,
              showHandlerOutter: false,
              handlerImage: _image,
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            _formatBedTime('IN THE', inBedTime),
            _formatBedTime('OUT OF', outBedTime),
          ]),
          FlatButton(
            child: Text('S H U F F L E'),
            color: baseColor,
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
            onPressed: (){
              setState(() {
                initTime = _generateRandomTime();
                endTime = _generateRandomTime();
                inBedTime = initTime;
                outBedTime = endTime;
                print("InitTime:$initTime");
                print("InitTime:$endTime");
                print("ShuffleCalled");
                setState(() { forceRebuild = ValueKey(DateTime.now()); });
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _formatBedTime(String pre, int time) {
    return Column(
      children: [
        Text(pre, style: TextStyle(color: baseColor)),
        Text('BED AT', style: TextStyle(color: baseColor)),
        Text(
          '${_formatTime(time)}',
          style: TextStyle(color: Colors.white),
        )
      ],
    );
  }

  String _formatTime(int time) {

    if (time == 0 || time == null) {
      return '00:00';
    }
    var hours = time ~/ 12;
    var minutes = (time % 12) * 5;

    return '$hours:$minutes';
  }

  int _generateRandomTime() => Random().nextInt(288);

}


class ImageEditor extends CustomPainter {
  ui.Image image;

  ImageEditor(this.image) : super();

  @override
  Future paint(Canvas canvas, Size size) async {
    if (image != null) {
      canvas.drawImage(image, Offset(0.0, 0.0), Paint());
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return image != (oldDelegate as ImageEditor).image;
  }
}