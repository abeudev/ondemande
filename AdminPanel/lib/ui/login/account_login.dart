import 'package:abg_utils/abg_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ondemand_admin/ui/login/pref.dart';
import '../strings.dart';

var pref = Pref();

Future<String?> accountLogin(String _email, String _password, bool _ckeckValues) async {
  User? user;
  try{
    user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email,
        password: _password,)).user;
  }catch(ex){
    return ex.toString();
  }

  if (user != null){
    if (_ckeckValues){
      var t = 0;
      String email = "";
      do{
        email = pref.get("email$t");
        if (email == _email)
          break;
        t++;
      }while(email.isNotEmpty);
      if (email != _email) {
        int n = toInt(pref.get(Pref.numPasswords));
        pref.set("email$n", _email);
        pref.set("pass$n", _password);
        n++;
        pref.set(Pref.numPasswords, n.toString());
      }
    }

    // print("user login id=${user.uid}");
    try{
      var querySnapshot = await FirebaseFirestore.instance.collection("listusers").doc(user.uid).get();
      if (!querySnapshot.exists)
        return strings.get(191); /// "Username or password is incorrect"
      else{
        var _data = querySnapshot.data();
        if (_data != null){
          if (_data["role"].isEmpty)
            return strings.get(250); /// "Permission denied"
           else
            return null;
        }else{
          return strings.get(191) + "_data = null"; /// "Username or password is incorrect"
        }
      }
    }catch(ex){
      return strings.get(191); /// "Username or password is incorrect"
    }
  }
  return null;
}

