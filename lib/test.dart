import 'package:flutter/material.dart';

class MyTestWidget extends StatefulWidget {
  @override
  _MyTestWidgetState createState() => _MyTestWidgetState();
}

class _MyTestWidgetState extends State<MyTestWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("this is plugin text", style: TextStyle(color: Colors.red),),
    );
  }
}
