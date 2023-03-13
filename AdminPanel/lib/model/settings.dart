import 'package:abg_utils/abg_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../ui/strings.dart';
import '../ui/theme.dart';
import '../utils.dart';
import 'initData/statuses.dart';
import 'model.dart';

class MainDataModelSettings {

  final MainModel parent;

  MainDataModelSettings({required this.parent});

  int _lastBookingNewCount = -1;

  Future<String?> settings(BuildContext context, Function()? _redrawMenu) async {

    parent.callback(strings.get(203)); /// "Loading settings ...",

    await loadSettings(() async {
      parent.langEditDataComboValue = appSettings.defaultServiceAppLanguage;
      parent.statusesCombo = [];
      parent.statusesComboForBookingSearch = [];
      parent.statusesComboForBookingSearch.add(ComboData(strings.get(254), "-1"));  // "All"
      if (appSettings.statusesFound){
        for (var item in appSettings.statuses){
          parent.statusesCombo.add(ComboData(getTextByLocale(item.name, strings.locale), item.id));
          parent.statusesComboForBookingSearch.add(ComboData(getTextByLocale(item.name, strings.locale), item.id));
        }
      }else{
        await uploadStatusImages(parent.callback);
        await saveStatuses();
      }
      statusesGetCompleted();
      theme = AppTheme(appSettings.adminDarkMode);
      if (_redrawMenu != null)
        _redrawMenu();

      if (_lastBookingNewCount == 0)
        if (_lastBookingNewCount != appSettings.bookingCountUnread){
          _lastBookingNewCount = appSettings.bookingCountUnread;
          parent.playSound();
        }
      if (_lastBookingNewCount == -1)
        _lastBookingNewCount = 0;
    });


    if (!appSettings.bookingToCashMigrate){
     // await FirebaseFirestore.instance.collection("cache").doc("orders").delete();
      parent.callback(strings.get(454)); /// "Convert bookings ... ",
      await bookingToCashMigrate((String error) async {
        if (error.isNotEmpty)
          messageError(context, error);
      });
    }
  }

  Future<String?> saveProviderAreaMap() async{
    try{
      var _data = {
        "providerAreaMapZoom": appSettings.providerAreaMapZoom,
        "providerAreaMapLat" : appSettings.providerAreaMapLat,
        "providerAreaMapLng" : appSettings.providerAreaMapLng,
      };
      await FirebaseFirestore.instance.collection("settings").doc("main").set(_data, SetOptions(merge:true));
    }catch(ex){
      return "saveProviderAreaMap " + ex.toString();
    }
    return null;
  }

  statusesGetCompleted(){
    appSettings.statuses.sort((a, b) => a.position.compareTo(b.position));
    parent.completeStatus = "";
    // List<StringData> name = [];
    for (var item in appSettings.statuses)
      if (!item.cancel) {
        parent.completeStatus = item.id;
        // name = item.name;
      }
    // print("statusesGetCompleted ${parent.completeStatus} $name" );
  }

  moveUp(StatusData item){
    StatusData? _last;
    for (var item2 in appSettings.statuses){
      if (item2.id == item.id){
        if (_last == null)
          return;
        var _position = item.position;
        item.position = _last.position;
        _last.position = _position;
        appSettings.statuses.sort((a, b) => a.position.compareTo(b.position));
        return parent.notify();
      }
      _last = item2;
    }
  }

  delete(StatusData item, BuildContext context, Function() _redraw){
    openDialogDelete(() {
      Navigator.pop(context); // close dialog
      // demo mode
      if (appSettings.demo)
        return messageError(context, strings.get(65)); /// "This is Demo Mode. You can't modify this section",
      appSettings.statuses.remove(item);
      appSettings.statuses.sort((a, b) => a.position.compareTo(b.position));
      _redraw();
    }, context);
  }

  moveDown(StatusData item){
    bool searched = false;
    for (var item2 in appSettings.statuses){
      if (item2.id == item.id){
        searched = true;
        continue;
      }
      if (searched) {
        var _position = item2.position;
        item2.position = item.position;
        item.position = _position;
        appSettings.statuses.sort((a, b) => a.position.compareTo(b.position));
        return parent.notify();
      }
    }
  }

  select(StatusData select){
    parent.currentStatus = select;
    parent.notify();
  }

  setName(String val){
    for (var item in parent.currentStatus.name)
      if (parent.langEditDataComboValue == item.code) {
        item.text = val;
        return;
      }
    parent.currentStatus.name.add(StringData(code: parent.langEditDataComboValue, text: val));
  }

  create(){
    var pos = 0;
    for (var item in appSettings.statuses)
      if (item.position >= pos)
        pos = item.position + 1;

    parent.currentStatus.position = pos;
    parent.currentStatus.id = UniqueKey().toString();
    appSettings.statuses.add(parent.currentStatus);
    appSettings.statuses.sort((a, b) => a.position.compareTo(b.position));
  }

  Future<String?> saveStatuses() async{
    statusesGetCompleted();
    var _data = {
      "statuses": appSettings.statuses.map((i) => i.toJson()).toList(),
    };
    try{
      await FirebaseFirestore.instance.collection("settings").doc("main").set(_data, SetOptions(merge:true));
    }catch(ex){
      return ex.toString();
    }
    return null;
  }
}

