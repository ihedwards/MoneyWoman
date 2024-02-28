import 'package:flutter/material.dart';



class Data extends StatelessWidget {
  const Data({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
          child: Column(
            children:[
          const Text(
            '  Data',
            style: TextStyle(fontSize: 20),
          ),
          Row(
            children: [
            RichText(
              text: TextSpan(
              text: "Total Expenses:",
              style: DefaultTextStyle.of(context).style,
 )),
            RichText(
              text: TextSpan(
              text: "Total Income:",
              style: DefaultTextStyle.of(context).style,
 ))
        ]),]
      ),
    ));
  }
}
