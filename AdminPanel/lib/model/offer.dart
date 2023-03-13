import 'package:abg_utils/abg_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../ui/strings.dart';
import 'model.dart';

class MainDataOffer with DiagnosticableTreeMixin {

  final MainModel parent;

  MainDataOffer({required this.parent});


  OfferData current = OfferData.createEmpty();
  List<OfferData> offers = [];
  String ensureVisible = "";

  //
  // Discount Type
  //
  List<ComboData> discountTypeCombo = [
    ComboData(strings.get(165), "percentage"),
    ComboData(strings.get(150), "fixed"),
  ];
  // String discountTypeComboValue = "percentage";

  setDiscountType(String val){
    current.discountType = val;
    parent.notify();
  }

  getCurrentDiscountText(){
    if (current.discountType == "percentage")
      return "${current.discount}%";
    return "\$${current.discount}";
  }

  getDiscountText(OfferData item){
    if (item.discountType == "percentage")
      return "${item.discount}%";
    return "\$${item.discount}";
  }

  //
  // CATEGORY
  //
  changeCategory(){
    current.category = [];
    for (var item in categories)
      if (item.select)
        current.category.add(item.id);
  }

  //
  // PROVIDERS
  //
  changeProvider(ProviderData item, bool val){
    current.providers = [];
    for (var item in providers)
      if (item.select)
        current.providers.add(item.id);
      parent.notify();
    // if (val)
    //   current.providers.add(item.id);
    // for (var item2 in parent.provider.providers) {
    //   item2.select = false;
    //   if (item2.id == item.id)
    //     item2.select = true;
    // }
  }

  //
  // SERVICES
  //
  changeService(){
    current.services = [];
    for (var item in product)
      if (item.select)
        current.services.add(item.id);
  }

  _setData(){
    for (var item in categories) {
      item.select = false;
      for (var item2 in current.category)
        if (item2 == item.id)
          item.select = true;
    }
    for (var item in providers) {
      item.select = false;
      for (var item2 in current.providers)
        if (item2 == item.id)
          item.select = true;
    }
    for (var item in product) {
      item.select = false;
      for (var item2 in current.services)
        if (item2 == item.id)
          item.select = true;
    }
  }
  //
  //
  //
  setExpiredDate(DateTime val){
    current.expired = val;
    parent.notify();
  }

  Future<String?> load() async{
    _setData();
    if (offers.isNotEmpty)
      return null;
    try{
      var querySnapshot = await FirebaseFirestore.instance.collection("offer").get();
      offers = [];
      for (var result in querySnapshot.docs) {
        var _data = result.data();
        // print("Offer $_data");
        var t = OfferData.fromJson(result.id, _data);
        offers.add(t);
      }
      addStat("admin offer", offers.length);
    }catch(ex){
      return ex.toString();
    }
    return null;
  }

  Future<String?> create() async {
    if (current.code.isEmpty)
      return strings.get(341); /// Please enter code
    try{
      var _data = current.toJson();
      var t = await FirebaseFirestore.instance.collection("offer").add(_data);
      current.id = t.id;
      offers.add(current);
      await FirebaseFirestore.instance.collection("settings").doc("main")
          .set({"offer_count": FieldValue.increment(1)}, SetOptions(merge:true));
      appSettings.offersCount++;
      parent.notify();
    }catch(ex){
      return ex.toString();
    }
    parent.notify();
    return null;
  }

  Future<String?> save() async {
    if (current.code.isEmpty)
      return strings.get(341); /// Please enter code
    try{
      var _data = current.toJson();
      await FirebaseFirestore.instance.collection("offer").doc(current.id).set(_data, SetOptions(merge:true));
    }catch(ex){
      return ex.toString();
    }
    parent.notify();
    return null;
  }

  Future<String?> delete(OfferData val) async {
    try{
      await FirebaseFirestore.instance.collection("offer").doc(val.id).delete();
      await FirebaseFirestore.instance.collection("settings").doc("main")
          .set({"offer_count": FieldValue.increment(-1)}, SetOptions(merge:true));
      appSettings.offersCount--;
      if (val.id == current.id)
        current = OfferData.createEmpty();
      offers.remove(val);
      parent.notify();
    }catch(ex){
      return ex.toString();
    }
    parent.notify();
    return null;
  }

  emptyCurrent(){
    current = OfferData.createEmpty();
    _setData();
    // for (var item in parent.category.category)
    //   item.select = false;
    // for (var item in parent.provider.providers)
    //   item.select = false;
    // for (var item in parent.service.services)
    //   item.select = false;
    parent.notify();
  }

  setList(List<OfferData> _data){
    offers = _data;
  }

  select(OfferData select){
    ensureVisible = select.id;
    current = select;

    for (var item in product) {
      item.select = false;
      if (current.services.contains(item.id))
        item.select = true;
    }
    for (var item in providers) {
      item.select = false;
      if (current.providers.contains(item.id))
        item.select = true;
    }
    for (var item in categories) {
      item.select = false;
      if (current.category.contains(item.id))
        item.select = true;
    }
    _setData();
    parent.notify();
  }

  setCode(String val){
    current.code = val;
    parent.notify();
  }

  setDesc(String val){
    for (var item in current.desc)
      if (item.code == parent.langEditDataComboValue) {
        item.text = val;
        return parent.notify();
      }
    current.desc.add(StringData(code: parent.langEditDataComboValue, text: val));
    parent.notify();
  }

  setDiscount(String val){
    current.discount = double.parse(val);
    parent.notify();
  }

  setVisible(bool val){
    current.visible = val;
    parent.notify();
  }

  copy(){
    var text = "";
    for (var item in offers){
      text = "$text${item.code}\t${getDiscountText(item)}"
          "\t${appSettings.getDateTimeString(item.expired)}"
          "\n";
    }
    Clipboard.setData(ClipboardData(text: text));
  }

  String csv(){
    List<List> t2 = [];
    t2.add([
      strings.get(163), /// "CODE",
      strings.get(164), /// "Discount",
      strings.get(167), /// "Expire",
    ]);
    for (var item in offers){
      t2.add([item.code, getDiscountText(item),
        appSettings.getDateTimeString(item.expired)
      ]);
    }
    return ListToCsvConverter().convert(t2);
  }
}

// class OfferData {
//   String id;
//   String code;
//   List<StringData> desc;
//   double discount;
//   String discountType; // "percentage" or "fixed"
//   bool visible;
//   List<String> services; // Id
//   List<String> providers; // Id
//   List<String> category; // Id
//   DateTime expired;
//
//   OfferData(this.id, this.code, {this.visible = true, required this.desc, this.discountType = "fixed",
//     required this.services, required this.providers, required this.category, this.discount = 0, required this.expired});
//
//   factory OfferData.createEmpty(){
//     return OfferData("", "", services: [], providers: [], category: [], expired: DateTime.now(), desc: []);
//   }
//
//   Map<String, dynamic> toJson() => {
//     'code': code,
//     'desc': desc.map((i) => i.toJson()).toList(),
//     'discount': discount,
//     'discountType': discountType,
//     'visible': visible,
//     'services': services,
//     'providers': providers,
//     'category': category,
//     'expired': expired.millisecondsSinceEpoch,
//   };
//
//   factory OfferData.fromJson(String id, Map<String, dynamic> data){
//     List<StringData> _desc = [];
//     if (data['desc'] != null)
//       for (var element in List.from(data['desc'])) {
//         _desc.add(StringData.fromJson(element));
//       }
//     List<String> _services = [];
//     if (data['services'] != null)
//       for (var element in List.from(data['services'])) {
//         _services.add(element);
//       }
//     List<String> _providers = [];
//     if (data['providers'] != null)
//       for (var element in List.from(data['providers'])) {
//         _providers.add(element);
//       }
//     List<String> _category = [];
//     if (data['category'] != null)
//       for (var element in List.from(data['category'])) {
//         _category.add(element);
//       }
//     return OfferData(
//       id,
//       (data["code"] != null) ? data["code"] : "",
//       desc: _desc,
//       discount: (data["discount"] != null) ? data["discount"] : 0,
//       discountType: (data["discountType"] != null) ? data["discountType"] : "",
//       visible: (data["visible"] != null) ? data["visible"] : true,
//       services: _services,
//       providers: _providers,
//       category: _category,
//       expired: (data["expired"] != null) ? DateTime.fromMillisecondsSinceEpoch(data["expired"]) : DateTime.now(),
//     );
//   }
//
// }