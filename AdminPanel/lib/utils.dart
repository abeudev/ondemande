import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'ui/strings.dart';
import 'ui/theme.dart';

openDialogDelete(Function() callback, BuildContext context){
  EasyDialog(
      colorBackground: Colors.white,
      body: Column(
        children: [
          Text(strings.get(63)), // "Do you want to delete this item? You will can't recover this item."
          SizedBox(height: 40,),
          Row(
            children: [
              Flexible(child: button2(strings.get(61), // "No",
                  theme.mainColor,
                      (){
                    // print("button pressed");
                    Navigator.pop(context); // close dialog
                  })),
              SizedBox(width: 10,),
              Flexible(child: button2(strings.get(62), // "Delete",
                  dashboardErrorColor, callback)),
            ],
          )
        ],
      )
  ).show(context);
}

Widget horizontalScroll(Widget _child, ScrollController? controller) {
  return ScrollConfiguration(
      behavior: MyCustomScrollBehavior(),
      child:
      Scrollbar(
          isAlwaysShown: true,
          controller: controller,
          child: SingleChildScrollView(
            controller: controller,
              scrollDirection: Axis.horizontal,
              child: Container(
                padding: EdgeInsets.only(bottom: 10),
                  child: _child)
          ))
  );
}


