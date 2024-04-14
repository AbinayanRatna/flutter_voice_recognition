import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speech_to_text/speech_to_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (_, child) {
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: MyHomePage(),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SpeechToText speechToText = SpeechToText();
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    checkMicrophoneAvailability();
  }

  void checkMicrophoneAvailability() async {
    bool available = await speechToText.initialize();
    if (available) {
      setState(() {
        if (kDebugMode) {
          print('Microphone available: $available');
        }
      });
    } else {
      if (kDebugMode) {
        print("Error : No access to microphone.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalHeight = MediaQuery.of(context).size.height;
    double totalWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 55.w,
        backgroundColor: Colors.blue,
        title: Text(
          "Voice app",
          style: TextStyle(
              fontSize: 20.w, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.w),
        child: Container(
          width: totalWidth,
          height: totalHeight,
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: Text(
                  _text,
                  style: TextStyle(fontSize: 20.w, color: Colors.black),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(30.w))),
                    child: Padding(
                      padding: EdgeInsets.all(5.w),
                      child: IconButton(
                        onPressed: ()  async {
                          if (!_isListening) {

                            // Call your function repeatedly while the button is pressed

                              bool available = await speechToText.initialize(
                                onStatus: (val) => print('onStatus: $val'),
                                onError: (val) => print('onError: $val'),
                              );
                              if (available) {
                                setState(() => _isListening = true);
                                _timer = Timer.periodic(Duration(milliseconds: 500), (_)  {
                                speechToText.listen(
                                  onResult: (val) => setState(() {
                                    _text = val.recognizedWords;
                                    print(_text);
                                  }),
                                );
                              });
                            }
                          }else {
                            setState(() => _isListening = false);
                            speechToText.stop();
                            _timer?.cancel();
                          }

                        },
                        icon: Icon(
                          _isListening? Icons.mic:Icons.mic_off,
                          size: 40.w,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
