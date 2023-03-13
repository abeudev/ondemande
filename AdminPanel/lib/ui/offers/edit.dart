import 'package:abg_utils/abg_utils.dart';

import 'package:flutter/material.dart';
import 'package:ondemand_admin/model/model.dart';
import 'package:provider/provider.dart';
import 'package:ondemand_admin/ui/elements/datetime.dart';
import 'package:ondemand_admin/ui/offers/tree_category.dart';
import '../main.dart';
import '../strings.dart';
import '../theme.dart';
import 'list_providers.dart';
import 'list_services.dart';

class EditInOffers extends StatefulWidget {
  @override
  _EditInOffersState createState() => _EditInOffersState();
}

class _EditInOffersState extends State<EditInOffers> {
  final _controllerCode = TextEditingController();
  final _controllerDesc = TextEditingController();
  final _controllerDiscount = TextEditingController();
  //
  late MainModel _mainModel;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    super.initState();
  }

  @override
  void dispose() {
    _controllerCode.dispose();
    _controllerDesc.dispose();
    _controllerDiscount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _listener();

    List<Widget> list = [];
    //
    // visible and language
    //
    list.add(Row(
      children: [
        Expanded(child: checkBox1a(context, strings.get(70), /// "Visible",
            theme.mainColor, theme.style14W400, _mainModel.offer.current.visible,
                (val) {
              if (val == null) return;
              Provider.of<MainModel>(context,listen:false).offer.setVisible(val);
              _noReceive = true;
            })),
        Expanded(child: SizedBox(width: 10,)),
        Text(strings.get(108), style: theme.style14W400,), /// "Select language",
        Expanded(child: Container(
              width: 120,
              child: Combo(inRow: true, text: "",
                data: _mainModel.langDataCombo,
                value: _mainModel.langEditDataComboValue,
                onChange: (String value){
                  _mainModel.langEditDataComboValue = value;
                  setState(() {
                  });
                },))),
        ],
    ));
    //
    list.add(SizedBox(height: 10,));


    //
    // providers + ...
    //
    if (isMobile()) {
      list.add(_list());
      list.add(SizedBox(height: 10,));
      list.add(_providers());
      list.add(SizedBox(height: 10,));
      list.add(_category());
      list.add(SizedBox(height: 10,));
      list.add(_service());
    } else {
      list.add(
          Row(
            children: [
              Expanded(child: _list()),
              SizedBox(width: 10,),
              Expanded(child: _providers()),
            ],
          )
      );
      list.add(SizedBox(height: 10,));
      list.add(
          Row(
            children: [
              Expanded(child: _category()),
              SizedBox(width: 5,),
              Expanded(child: _service()),
            ],
          )
      );
    }

    //
    list.add(SizedBox(height: 20,));
    list.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
    list.add(SizedBox(height: 10,));

    //
    // save
    //
    list.add(SizedBox(height: 20,));
    if (_mainModel.offer.current.id.isEmpty)
      list.add(button2b(strings.get(169), () async {        /// "Create new offer",
        _noReceive = true;
        var ret = await _mainModel.offer.create();
        if (ret == null)
          messageOk(context, strings.get(81)); /// "Data saved",
        else
          messageError(context, ret);
      }));
    else
      list.add(Row(
        children: [
          Expanded(child: button2b(strings.get(170), () async {
            _noReceive = true;
            var ret = await Provider.of<MainModel>(context,listen:false).offer.save();
            if (ret == null)
              messageOk(context, strings.get(81)); /// "Data saved",
            else
              messageError(context, ret);
          })), /// "Save current offer",
          button2b(strings.get(171), (){                 /// "Add New offer",
            _mainModel.offer.emptyCurrent();
          })
        ],
      ));
    return Stack(
      children: [
        Container(
            width: (windowWidth < 900) ? 900 : (windowWidth > 1200) ? windowWidth-400 : windowWidth-80,
            decoration: BoxDecoration(
              color: (theme.darkMode) ? theme.blackColorTitleBkg : Colors.white,
              borderRadius: BorderRadius.circular(theme.radius),
            ),
            child: Stack(
            children: [
              Positioned.fill(child: AnimatedContainer(
                  decoration: BoxDecoration(
                    color: (_select) ? Colors.grey.withAlpha(100) : Colors.transparent,
                    borderRadius: BorderRadius.circular(theme.radius),
                  ),
                  duration: Duration(seconds: 1))),
              Container(
                  margin: EdgeInsets.all(20),
                  child: Column(
                children: list,
              ))
            ],
            )
        ),
      ],
    );
  }

  _list(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        textElement2(strings.get(163), "", _controllerCode, (String val){         /// "CODE",
          _mainModel.offer.setCode(val);
          _noReceive = true;
        }),
        SizedBox(height: 10,),
        textElement2(strings.get(73), "", _controllerDesc, (String val){           /// Description
          Provider.of<MainModel>(context,listen:false).offer.setDesc(val);
          _noReceive = true;
        }),
        SizedBox(height: 10,),
        _mainModel.offer.current.discountType == "fixed" ?
        numberElement2Price(strings.get(164), /// Discount
            "123", appSettings.symbol,
            _controllerDiscount, (String val){
              Provider.of<MainModel>(context,listen:false).offer.setDiscount(val);
              _noReceive = true;
            }, appSettings.digitsAfterComma) :
        numberElement2Percentage(strings.get(164), /// Discount
            "123",
            _controllerDiscount, (String val){
              Provider.of<MainModel>(context,listen:false).offer.setDiscount(val);
              _noReceive = true;
            }),
        SizedBox(height: 10,),
        Row(
          children: [
            SelectableText(strings.get(166), style: theme.style14W400,), /// "Discount type",
            SizedBox(width: 10,),
            Expanded(child: Combo(inRow: true, text: "",
              data: _mainModel.offer.discountTypeCombo,
              value: _mainModel.offer.current.discountType,
              onChange: (String value){
                if (value == "percentage")
                  if (toInt(_controllerDiscount.text) > 100)
                    _controllerDiscount.text = "100";
                Provider.of<MainModel>(context,listen:false).offer.setDiscountType(value);
                _noReceive = true;
              },)),
          ],
        ),
        SizedBox(height: 10,),
        Row(
          children: [
            SelectableText(strings.get(167), style: theme.style14W400,), /// "Expire",
            SizedBox(width: 10,),
            Expanded(child: Container(
              //width: 150,
              child: ElementSelectDateTime(getText: (){
                var expired = _mainModel.offer.current.expired;
                return appSettings.getDateTimeString(expired);
              },
                setDateTime: (DateTime val) {
                  Provider.of<MainModel>(context,listen:false).offer.setExpiredDate(val);
                  _noReceive = true;
                },),
            )),
          ],
        )
      ],
    );
  }

  _providers(){
    return Column(
      children: [
        Text(strings.get(96), style: theme.style14W800,), /// "Providers",
        SizedBox(height: 5,),
        ListProvidesInOffers()
      ],
    );
  }

  _category(){
    return Column(
      children: [
        Text(strings.get(56), style: theme.style14W800,), /// "Categories",
        SizedBox(height: 5,),
        TreeCategoryInOffers()
      ],
    );
  }

  _service(){
    return Column(
      children: [
        Text(strings.get(142), style: theme.style14W800,), /// "Services",
        SizedBox(height: 5,),
        ListServicesInOffers()
      ],
    );
  }

  _listener(){
    if (_noReceive){
      _noReceive = false;
      return;
    }
    // print("_listener");
    _nowEdit(context.watch<MainModel>().offer.current);
    if (_initListen){
      _initListen = false;
      return;
    }
    _select = true;
    _initListen = true;
    Future.delayed(const Duration(milliseconds: 1000), () {
      _select = false;
      setState(() {
      });
    });

  }

  bool _initListen = false;
  bool _select = false;
  bool _noReceive = false;

  _nowEdit(OfferData data){
    _controllerCode.text = data.code;
    textFieldToEnd(_controllerCode);
    _controllerDesc.text = Provider.of<MainModel>(context,listen:false).getTextByLocale(data.desc);
    textFieldToEnd(_controllerDesc);
    _controllerDiscount.text = data.discount.toString();
    textFieldToEnd(_controllerDiscount);
  }
}