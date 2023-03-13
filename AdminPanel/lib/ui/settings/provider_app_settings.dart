import 'dart:typed_data';
import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ondemand_admin/model/model.dart';
import 'package:provider/provider.dart';
import '../elements/color.dart';
import '../strings.dart';
import '../theme.dart';

class ProviderAppSettingsScreen extends StatefulWidget {
  @override
  _ProviderAppSettingsScreenState createState() => _ProviderAppSettingsScreenState();
}

class _ProviderAppSettingsScreenState extends State<ProviderAppSettingsScreen> {

  late MainModel _mainModel;
  Uint8List? bytesImage;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      waitInMainWindow(true);
      await _mainModel.serviceApp.init(context);
      waitInMainWindow(false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: (theme.darkMode) ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(theme.radius),
          ),
          child: ListView(
            children: _getList(),
    ),);
  }

  _getList(){

    List<Widget> list = [];
    list.add(SizedBox(height: 10,));
    list.add(Row(
      children: [
        Expanded(child: SelectableText(strings.get(417),                       /// "Provider App Settings",
          style: theme.style25W800,)),
      ],
    ));
    list.add(SizedBox(height: 20,));
    list.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
    list.add(SizedBox(height: 10,));

    Widget _mainColor = Row(
      children: [
        SelectableText(strings.get(103), style: theme.style14W400,),          /// "Main color",
        SizedBox(width: 10,),
        Container(
          width: 150,
          child: ElementSelectColor(getColor: (){return appSettings.providerMainColor;},
            setColor: (Color value){
              appSettings.providerMainColor = value;
              _redraw();
            },),
        )
      ],
    );

    bool _needDelete = false;
    Widget _image = Image.asset("assets/applogo2.png");
    if (bytesImage != null) {
      _image = Image.memory(bytesImage!);
      _needDelete = true;
    }else {
      if (appSettings.providerLogoServer.isNotEmpty) {
        _image = Image.network(appSettings.providerLogoServer);
        _needDelete = true;
      }
    }

    Widget _logoImg = Row(
      children: [
        SelectableText(strings.get(119), style: theme.style14W400,),          /// "Logo image",
        SizedBox(width: 10,),
        button2b(strings.get(75), () async {  /// "Select image"
          XFile? pickedFile;
          try{
            pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
          } catch (e) {
            return messageError(context, e.toString());
          }
          if (pickedFile != null) {
            bytesImage = await pickedFile.readAsBytes();
            _redraw();
          }
        }),
        SizedBox(width: 10,),
        Container(width: 100,
          child: _image
        ),
        SizedBox(width: 10,),
        if (_needDelete)
          button2b(strings.get(420), () async {  /// "Delete image"
            if (bytesImage != null){
              bytesImage = null;
              _redraw();
            }else{
              if (appSettings.providerLogoServer.isNotEmpty){
                await deleteImage("providerAppLogo");
                _redraw();
              }
            }
          }),
      ],
    );


    if (isMobile()){
      list.add(_mainColor);
      list.add(SizedBox(height: 10,));
      list.add(_logoImg);
    }else
      list.add(Row(
        children: [
          Expanded(child: _mainColor),
          SizedBox(width: 10,),
          Expanded(child: _logoImg),
        ],
      ));

    list.add(SizedBox(height: 20,));
    list.add(Center(child: button2b(strings.get(421), () async { /// Restore settings
      appSettings.providerMainColor = Color(0xff69c4ff);
      bytesImage = null;
      if (appSettings.providerLogoServer.isNotEmpty)
        await deleteImage("providerAppLogo");
      var ret = await saveSettings();
      if (ret != null)
        messageError(context, ret);
      _redraw();
    })));

    list.add(SizedBox(height: 20,));
    list.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
    list.add(SizedBox(height: 50,));
    list.add(Center(child: button2b(strings.get(9), () async {  /// "Save"
      if (bytesImage != null){
        var ret = await uploadImage("providerAppLogo", bytesImage!);
        if (ret != null)
          return messageError(context, ret);
      }
      var ret = await saveSettings();
      if (ret != null)
        messageError(context, ret);
      else
        messageOk(context, strings.get(81)); /// "Data saved",
    })));

    return list;
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

}


