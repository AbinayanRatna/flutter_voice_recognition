import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SecondPage extends StatefulWidget{
  const SecondPage ({super.key});

  @override
  State<StatefulWidget> createState() =>_StateSecondPage();
}

class _StateSecondPage extends State<SecondPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text("Second page",style: TextStyle(fontSize: 20.w,color: Colors.white),),
        backgroundColor: Colors.red,
      ),
      backgroundColor: Colors.yellow,
    );
  }

}