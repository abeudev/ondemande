// import 'dart:io';
//
// import 'package:abg_utils/abg_utils.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:ondprovider/ui/strings.dart';
// import 'package:uuid/uuid.dart';
// import 'model.dart';
//
// class ProviderInfo{
//   final MainModel parent;
//   ProviderInfo({required this.parent});
//
//   ProviderData currentProvider = ProviderData.createEmpty();
//   String editItem = "";
//
//   String edit(String item){
//     editItem = item;
//     if (item == "phone")
//       return currentProvider.phone;
//     if (item == "www")
//       return currentProvider.www;
//     if (item == "instagram")
//       return currentProvider.instagram;
//     if (item == "telegram")
//       return currentProvider.telegram;
//     return "";
//   }
//
//   String getHint(){
//     if (editItem == "phone")
//       return strings.get(135); /// "Enter your Phone",
//     if (editItem == "www")
//       return strings.get(136); /// "Enter your Web Page address",
//     if (editItem == "instagram")
//       return strings.get(137); /// "Enter your Instagram address",
//     if (editItem == "telegram")
//       return strings.get(138); /// "Enter your Telegram address",
//     return "";
//   }
//
//   save(String value) async {
//     try{
//       if (editItem == "phone"){
//         currentProvider.phone = value;
//         await FirebaseFirestore.instance.collection("provider").doc(currentProvider.id).set({
//             "phone": value,}, SetOptions(merge: true));
//       }
//       if (editItem == "www"){
//         currentProvider.www = value;
//         await FirebaseFirestore.instance.collection("provider").doc(currentProvider.id).set({
//           "www": value,}, SetOptions(merge: true));
//       }
//       if (editItem == "instagram"){
//         currentProvider.instagram = value;
//         await FirebaseFirestore.instance.collection("provider").doc(currentProvider.id).set({
//           "instagram": value,}, SetOptions(merge: true));
//       }
//       if (editItem == "telegram"){
//         currentProvider.telegram = value;
//         await FirebaseFirestore.instance.collection("provider").doc(currentProvider.id).set({
//           "telegram": value,}, SetOptions(merge: true));
//       }
//       editItem = "";
//     }catch(ex){
//       return "provider info save " + ex.toString();
//     }
//     return null;
//   }
//
//   String getDesc(){
//     return getTextByLocale(currentProvider.desc, parent.customerAppLangsComboValue);
//   }
//
//   String getDescTitle(){
//     return getTextByLocale(currentProvider.descTitle, parent.customerAppLangsComboValue);
//   }
//
//   String getName(){
//     return getTextByLocale(currentProvider.name, parent.customerAppLangsComboValue);
//   }
//
//   saveDesc(String title, String desc){
//     dprint("saveDesc parent.customerAppLangsComboValue=${parent.customerAppLangsComboValue}, title=$title");
//     var _found = false;
//     for (var item in currentProvider.descTitle)
//       if (item.code == parent.customerAppLangsComboValue) {
//         item.text = title;
//         _found = true;
//       }
//     if (!_found)
//       currentProvider.descTitle.add(StringData(code: parent.customerAppLangsComboValue, text: title));
//     //
//     _found = false;
//     for (var item in currentProvider.desc)
//       if (item.code == parent.customerAppLangsComboValue) {
//         item.text = desc;
//         _found = true;
//       }
//     if (!_found)
//       currentProvider.desc.add(StringData(code: parent.customerAppLangsComboValue, text: desc));
//   }
//
//   saveName(String name){
//     var _found = false;
//     for (var item in currentProvider.name)
//       if (item.code == parent.customerAppLangsComboValue) {
//         item.text = name;
//         _found = true;
//       }
//     if (!_found)
//       currentProvider.name.add(StringData(code: parent.customerAppLangsComboValue, text: name));
//   }
//
//   Future<String?> saveDescToDB() async {
//     try{
//       await FirebaseFirestore.instance.collection("provider").doc(currentProvider.id).set({
//         'descTitle': currentProvider.descTitle.map((i) => i.toJson()).toList(),
//         'desc': currentProvider.desc.map((i) => i.toJson()).toList(),
//       }, SetOptions(merge: true));
//     }catch(ex){
//       return "saveDescToDB " + ex.toString();
//     }
//     return null;
//   }
//
//   Future<String?> saveNameToDB() async {
//     try{
//       await FirebaseFirestore.instance.collection("provider").doc(currentProvider.id).set({
//         'name': currentProvider.name.map((i) => i.toJson()).toList(),
//       }, SetOptions(merge: true));
//     }catch(ex){
//       return "saveName " + ex.toString();
//     }
//     return null;
//   }
//
//   Future<String?> saveAddress(String value) async {
//     currentProvider.address = value;
//     try{
//       await FirebaseFirestore.instance.collection("provider").doc(currentProvider.id).set({
//         'address': currentProvider.address,
//       }, SetOptions(merge: true));
//     }catch(ex){
//       return "saveAddress " + ex.toString();
//     }
//     return null;
//   }
//
//   Future<String?> uploadIcon(String _imageFile) async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user == null)
//       return "uploadIcon user == null";
//     try{
//       var f = Uuid().v4();
//       var name = "provider/$f.jpg";
//       var firebaseStorageRef = FirebaseStorage.instance.ref().child(name);
//       TaskSnapshot s = await firebaseStorageRef.putFile(File(_imageFile));
//       currentProvider.logoServerPath = await s.ref.getDownloadURL();
//       currentProvider.logoLocalFile = name;
//       await FirebaseFirestore.instance.collection("provider").doc(currentProvider.id).set({
//         "logoLocalFile":   name,
//         "logoServerPath": currentProvider.logoServerPath
//       }, SetOptions(merge:true));
//     } catch (e) {
//       return "uploadIcon " + e.toString();
//     }
//     return null;
//   }
//
//   Future<String?> uploadLogo(String _imageFile) async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user == null)
//       return "uploadLogo user == null";
//     try{
//       var f = Uuid().v4();
//       var name = "provider/$f.jpg";
//       var firebaseStorageRef = FirebaseStorage.instance.ref().child(name);
//       TaskSnapshot s = await firebaseStorageRef.putFile(File(_imageFile));
//       currentProvider.imageUpperServerPath = await s.ref.getDownloadURL();
//       currentProvider.imageUpperLocalFile = name;
//       await FirebaseFirestore.instance.collection("provider").doc(currentProvider.id).set({
//         "imageUpperLocalFile": name,
//         "imageUpperServerPath": currentProvider.logoServerPath
//       }, SetOptions(merge:true));
//     } catch (e) {
//       return "uploadLogo " + e.toString();
//     }
//     return null;
//   }
//
//   Future<String?> deleteFromGallery(String serverPath, String localFile) async {
//     try{
//       ImageData? forDelete;
//       for (var item in currentProvider.gallery)
//         if (item.localFile == localFile)
//           forDelete = item;
//       if (forDelete != null)
//         currentProvider.gallery.remove(forDelete);
//       await FirebaseFirestore.instance.collection("provider").doc(currentProvider.id).set({
//         'gallery': currentProvider.gallery.map((i) => i.toJson()).toList(),
//       }, SetOptions(merge:true));
//     } catch (e) {
//       return "deleteFromGallery " + e.toString();
//     }
//     return null;
//   }
//
//   Future<String?> uploadToGallery(String _imageFile) async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user == null)
//       return "uploadToGallery user == null";
//     try{
//       var f = Uuid().v4();
//       var name = "provider/$f.jpg";
//       var firebaseStorageRef = FirebaseStorage.instance.ref().child(name);
//       TaskSnapshot s = await firebaseStorageRef.putFile(File(_imageFile));
//       currentProvider.gallery.add(ImageData(localFile: name, serverPath: await s.ref.getDownloadURL()));
//       await FirebaseFirestore.instance.collection("provider").doc(currentProvider.id).set({
//         'gallery': currentProvider.gallery.map((i) => i.toJson()).toList(),
//       }, SetOptions(merge:true));
//     } catch (e) {
//       return "uploadToGallery " + e.toString();
//     }
//     return null;
//   }
// }
