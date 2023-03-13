import 'package:flutter/material.dart';
import 'package:ondemand_admin/model/model.dart';
import 'package:abg_utils/abg_utils.dart';
import '../ui/strings.dart';
import '../ui/theme.dart';

bool comboPopupShow = false;

double dialogPositionX = 0;
double dialogPositionY = 0;
double dialogWidth = 0;
GlobalKey popupKey = GlobalKey();
// ignore: prefer_function_declarations_over_variables
Function() _redraw = (){};
List<ComboData> _data = [];
// ignore: prefer_function_declarations_over_variables
Function(String) _setValue = (String _){};
ScrollController _controllerScroll = ScrollController();
var _controllerSearch = TextEditingController();
String _searchText = "";

Widget popupWidget(double windowWidth, List<ComboData> data, String _currentValue, Function(String) setValue){
  _setValue = setValue;
  _data = data;
  String _text = "";
  String _email = "";
  for (var item in _data)
    if (item.id == _currentValue) {
      _text = item.text;
      _email = item.email;
    }

  return Container(
      key: popupKey,
      height: 40,
      decoration: BoxDecoration(
        // color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(theme.radius),
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      child: InkWell(
        onTap: (){
          openListPopup(windowWidth);
        },
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Row(
          children: [
            Expanded(child: Row(
              children: [
                Text(_text, style: theme.style14W400,),
                SizedBox(width: 10,),
                Text(_email, style: theme.style12W600Grey,),
              ],
            )),
            Icon(Icons.arrow_downward_sharp, color: Colors.black, size: 20,)
          ],
        )),
      ),
  );
}

openListPopup(double windowWidth){
  final RenderBox? renderBox = popupKey.currentContext!.findRenderObject() as RenderBox;
  Offset position = renderBox!.localToGlobal(Offset.zero); // this is global position
  dialogPositionY = position.dy;
  dialogPositionX = position.dx;
  if (windowWidth - position.dx < 200)
    dialogPositionX = windowWidth - 200;
  dialogWidth = renderBox.size.width;
  comboPopupShow = true;
  _redraw();
}

showPopup(MainModel _mainModel, Function() redraw){

  _redraw = redraw;
  if (!comboPopupShow)
    return Container();

    _item(ComboData item){
      return Stack(
        children: [

          Container(
              padding: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
              child: Row(
              children: [
                Text(item.text, style: item.selected ? theme.style14W800 : theme.style14W400,),
                SizedBox(width: 20,),
                Expanded(child: Text(item.email, style: theme.style12W600Grey, overflow: TextOverflow.ellipsis,)),
              ],
            )),

          Positioned.fill(
            child: Material(
                color: Colors.transparent,
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  splashColor: Colors.black.withOpacity(0.2),
                  onTap: (){
                    _setValue(item.id);
                    comboPopupShow = false;
                    _redraw();
                  }, // needed
                )),
          )
        ],
      );
    }

    if (dialogPositionY == 0)
      return Container();
    List<Widget> list = [];

    list.add(SizedBox(height: 10,));
    list.add(Container(
      margin: EdgeInsets.all(10),
      child: Edit41web(controller: _controllerSearch,
      hint: strings.get(60), /// search
      onChange: (String val){
        _searchText = val;
        _redraw();
      }
    )));
    list.add(SizedBox(height: 10,));

    for (var item in _data) {
      if (item.divider){
        list.add(Divider(color: (theme.darkMode) ? Colors.white : Colors.grey,));
        continue;
      }
      if (_searchText.isNotEmpty) {
        if (item.text.contains(_searchText) || item.email.contains(_searchText))
          list.add(_item(item));
      }
      else
        list.add(_item(item));
    }

    list.add(SizedBox(height: 10,));

    return Container(
      decoration: BoxDecoration(
        color: (theme.darkMode) ? Colors.black : Colors.white,
        border: Border.all(color: Colors.grey.withAlpha(80)),
        borderRadius: BorderRadius.circular(3),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(3, 3),
          ),
        ],
      ),
      margin: EdgeInsets.only(top: dialogPositionY, left: dialogPositionX),
      width: dialogWidth,
      child: ListView(
        controller: _controllerScroll,
        shrinkWrap: true,
        children: list,
      ),);
}