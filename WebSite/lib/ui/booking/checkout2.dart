import 'dart:math';
import 'package:abg_utils/abg_utils.dart';
import 'package:abg_utils/payments_web.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/mainModel/model.dart';
import 'package:ondemand_admin/ui/booking/payment.dart';
import 'package:provider/provider.dart';
import '../../theme.dart';
import '../strings.dart';

class CheckOut2Screen extends StatefulWidget {
  @override
  _CheckOut2ScreenState createState() => _CheckOut2ScreenState();
}

class _CheckOut2ScreenState extends State<CheckOut2Screen> {

  double windowWidth = 0;
  double windowHeight = 0;
  double windowSize = 0;
  bool _razorPayNeed = false;
  // final ScrollController _scrollController = ScrollController();
  final _editControllerCoupon = TextEditingController();
  final _editControllerHint = TextEditingController();
  final ScrollController _scrollController2 = ScrollController();
  // double _show = 0;
  late MainModel _mainModel;
  late PriceTotalForCardData _totalPrice;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    _editControllerHint.text = localSettings.hint;
    super.initState();
  }

  @override
  void dispose() {
    _scrollController2.dispose();
    _editControllerHint.dispose();
    _editControllerCoupon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    windowSize = min(windowWidth, windowHeight);

    List<Widget> list = [];
    list.add(SizedBox(height: 20,));
    paymentsList(cartCurrentProvider != null ? cartCurrentProvider! : ProviderData.createEmpty(), list, _redraw, true);

    list.add(Container(
      alignment: Alignment.bottomCenter,
      child: button2(strings.get(62), /// "CONTINUE"
          theme.mainColor, (){
            // String _desc = "";
            // if (price.name.isNotEmpty)
            //   _desc = getTextByLocale(price.name, strings.locale);
            _mainModel.cartUser = true;
            String _desc = "none";
            List<PriceForCardData> _t = cartGetPriceForAllServices();
            if (_t.isNotEmpty)
              _desc = _t[0].name;
            paymentProcess(_totalPrice.total, _desc, _mainModel, context, (){
              _razorPayNeed = true;
              _redraw();
            });

          }, radius: 0),
    ));

    String _desc = "none";
    List<PriceForCardData> _t = cartGetPriceForAllServices();
    if (_t.isNotEmpty)
      _desc = _t[0].name;

    return Stack(
      children: [
        ListView(
            shrinkWrap: true,
            children: [
              Row(
                children: [
                  Expanded(child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: _body())),
                  SizedBox(width: 20,),
                  Expanded(child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: list,
                  )),
                ],
              ),
            ]
        ),
        if (_razorPayNeed)
          Container(
            height: windowHeight,
            child: RazorpayPayment(
                amount: _totalPrice.total,
                desc: _desc,
                success: (String id) async {
                  paymentMethodId = "Razorpay $id";
                  _mainModel.razorpaySuccess = true;
                  dprint("mainModel.paymentMethodId=$paymentMethodId");
                  var ret = await _mainModel.finish(false);
                  if (ret != null)
                    return messageError(context, ret);
                  _mainModel.clearBookData();
                  _mainModel.route("payment_success");
                }, close: (){
              _razorPayNeed = false; _redraw();
            }),)
      ],
    );
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  // Widget _getDialogBody(){
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       UnconstrainedBox(
  //           child: Container(
  //             height: windowWidth/3,
  //             width: windowWidth/3,
  //             child: image11(
  //                 theme.booking5LogoAsset ? Image.asset("assets/ondemands/ondemand33.png", fit: BoxFit.contain) :
  //                 CachedNetworkImage(
  //                     imageUrl: theme.booking5Logo,
  //                     imageBuilder: (context, imageProvider) => Container(
  //                       decoration: BoxDecoration(
  //                         image: DecorationImage(
  //                           image: imageProvider,
  //                           fit: BoxFit.contain,
  //                         ),
  //                       ),
  //                     )
  //                 ),
  //                 //Image.asset("assets/ondemands/ondemand33.png", fit: BoxFit.contain)
  //                 20),
  //           )),
  //       SizedBox(height: 20,),
  //       Text(strings.get(116), // "Thank you!",
  //           textAlign: TextAlign.center, style: theme.style20W800),
  //       SizedBox(height: 20,),
  //       Text(strings.get(115), // "Your booking has been successfully submitted, you will receive a confirmation soon."
  //           textAlign: TextAlign.center, style: theme.style14W400),
  //       SizedBox(height: 40,),
  //       Text("${strings.get(232)} $cartLastAddedId", /// "Booking ID",
  //           textAlign: TextAlign.center, style: theme.style14W400),
  //       SizedBox(height: 40,),
  //       Container(
  //           alignment: Alignment.center,
  //           child: Container(
  //               width: windowWidth/2,
  //               child: button2(strings.get(114), theme.mainColor, // "Ok",
  //                       (){
  //                     setState(() {
  //                       _show = 0;
  //                     });
  //                     goBack();
  //                     goBack();
  //                   }))
  //       ),
  //       SizedBox(height: 20,),
  //     ],
  //   );
  // }

  _body(){
    List<Widget> list = [];

    _totalPrice = cartGetTotalForAllServices();
    tablePricesV4(list, cart,
        strings.get(23), /// "Addons"
        strings.get(181), /// "Subtotal"
        strings.get(182), /// "Discount"
        strings.get(208), /// "VAT/TAX"
        strings.get(196)  /// "Total amount"
    );

    // List<Widget> listPrices = [];
    // for (var item in cartGetPriceForAllServices()){
    //   listPrices.add(Column(
    //     children: [
    //
    //       SizedBox(height: 10,),
    //       Row(
    //         children: [
    //           Expanded(child: Text(item.name, style: theme.style13W400,)),
    //           Text(item.priceString, style: theme.style13W400,)
    //         ],
    //       ),
    //
    //       if (item.priceAddons != 0)
    //         SizedBox(height: 10,),
    //       if (item.priceAddons != 0)
    //         Row(
    //           children: [
    //             Expanded(child: Text(strings.get(23), style: theme.style13W400,)), /// "Addons"
    //             Text("(+) ${item.priceAddons}", style: theme.style13W400,)
    //           ],
    //         ),
    //
    //       if (!item.isArticle && item.subTotal != item.priceWithCount)
    //         SizedBox(height: 10,),
    //       if (!item.isArticle && item.subTotal != item.priceWithCount)
    //         Row(
    //           children: [
    //             Expanded(child: Text(strings.get(181), style: theme.style13W400,)), /// "Subtotal"
    //             Text(item.subTotalString, style: theme.style13W400,)
    //           ],
    //         ),
    //       SizedBox(height: 10,),
    //       Divider(height: 0.5, color: Colors.grey,),
    //       // SizedBox(height: 10,),
    //     ],
    //   ));
    // }
    //
    // _totalPrice = cartGetTotalForAllServices();
    //
    // list.add(Container(
    //     color: (theme.darkMode) ? Colors.black : Colors.white,
    //     child: Container(
    //         padding: EdgeInsets.all(10),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             SizedBox(height: 10,),
    //
    //             //
    //             // price
    //             //
    //             ...listPrices,
    //             SizedBox(height: 10,),
    //
    //             Row(
    //               children: [
    //                 Expanded(child: Text(strings.get(182), style: theme.style13W400,)), /// "Discount"
    //                 Text("(-) ${_totalPrice.discountString}", style: theme.style13W400,)
    //               ],
    //             ),
    //             SizedBox(height: 10,),
    //             Row(
    //               children: [
    //                 Expanded(child: Text(strings.get(208), style: theme.style13W400,)), /// "VAT/TAX"
    //                 Text("(+) ${_totalPrice.taxString}", style: theme.style13W400,)
    //               ],
    //             ),
    //             SizedBox(height: 10,),
    //             Divider(height: 0.5, color: Colors.grey,),
    //             SizedBox(height: 10,),
    //             Row(
    //               children: [
    //                 Expanded(child: Text(strings.get(196), style: theme.style14W800MainColor,)), /// "Total amount"
    //                 Text(_totalPrice.totalString, style: theme.style14W800MainColor,)
    //               ],
    //             ),
    //             SizedBox(height: 10,),
    //           ],
    //         )
    //     )));

    list.add(SizedBox(height: 150,));
    return list;
  }
  //
  // bool _booking = false;
  // double _show = 0;
  //
  // _book2(){
  //   _booking = true;
  //   setState(() {
  //     _show = 1;
  //   });
  // }
}
