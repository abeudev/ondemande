import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemandservice/model/model.dart';
import '../strings.dart';
import '../theme.dart';

int paymentMethod = 1;
late Function() _book2;
late MainModel _mainModel;
late BuildContext _context;

paymentsList(ProviderData provider, List<Widget> list, Function() _redraw){

  if (provider.acceptPaymentInCash)
  list.add(Container(
    margin: EdgeInsets.only(left: 10, right: 10, top: 30, bottom: 10),
    padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
    decoration: BoxDecoration(
      color: (theme.darkMode) ? Colors.black : Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: checkBox43(strings.get(81), // "Cash payment",
        theme.booking4CheckBoxColor, "assets/cache.png",
        theme.style14W800,
        paymentMethod == 1, (val) {
          if (val) {
            paymentMethod = 1;
            _redraw();
          }
        }),
  ));

  //
  // Apple Pay and Google Pay
  //
  // const _paymentItems = [
  //   PaymentItem(
  //     label: 'Total',
  //     amount: '15.0',
  //     status: PaymentItemStatus.final_price,
  //   )
  // ];
  // list.add(GooglePayButton(
  //   paymentConfigurationAsset: 'payment_profile_google_pay.json',
  //   paymentItems: _paymentItems,
  //   style: GooglePayButtonStyle.black,
  //   type: GooglePayButtonType.pay,
  //   margin: const EdgeInsets.only(top: 15.0),
  //   onPaymentResult: (Map<String, dynamic> result) {
  //     print(result["paymentMethodData"]["description"]);
  //   },
  //   loadingIndicator: const Center(
  //     child: CircularProgressIndicator(),
  //   ),
  // ));


  //
  // Stripe
  //
  if (appSettings.stripeEnable)
    list.add(Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: (theme.darkMode) ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: checkBox43("Stripe",
          theme.booking4CheckBoxColor, "assets/stripe.png",
          theme.style14W800,
          paymentMethod == 2, (val) {
            if (val) {
              paymentMethod = 2;
              _redraw();
            }
          }),
    ));

  //
  // Razorpay
  //
  if (appSettings.razorpayEnable)
    list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        decoration: BoxDecoration(
          color: (theme.darkMode) ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: checkBox43("Razorpay",
            theme.booking4CheckBoxColor, "assets/razorpay.png",
            theme.style14W800,
            paymentMethod == 3, (val) {
              if (val) {
                paymentMethod = 3;
                _redraw();
              }
            })));

  //
  // Paypal
  //
  if (appSettings.paypalEnable)
    list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        decoration: BoxDecoration(
          color: (theme.darkMode) ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: checkBox43("Pay Pal",
            theme.booking4CheckBoxColor, "assets/paypal.png",
            theme.style14W800,
            paymentMethod == 4, (val) {
              if (val) {
                paymentMethod = 4;
                _redraw();
              }
            })));

  //
  // Flutterwave
  //
  if (appSettings.flutterWaveEnable)
    list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        decoration: BoxDecoration(
          color: (theme.darkMode) ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: checkBox43("Flutterwave",
            theme.booking4CheckBoxColor, "assets/flutterwave.png",
            theme.style14W800,
            paymentMethod == 5, (val) {
              if (val) {
                paymentMethod = 5;
                _redraw();
              }
            })));

  //
  // Paystack
  //
  if (appSettings.payStackEnable)
    list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        decoration: BoxDecoration(
          color: (theme.darkMode) ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: checkBox43("Paystack",
            theme.booking4CheckBoxColor, "assets/paystack.png",
            theme.style14W800,
            paymentMethod == 6, (val) {
              if (val) {
                paymentMethod = 6;
                _redraw();
              }
            })));

  //
  // MercadoPago
  //
  if (appSettings.mercadoPagoEnable)
    list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        decoration: BoxDecoration(
          color: (theme.darkMode) ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: checkBox43("MercadoPago",
            theme.booking4CheckBoxColor, "assets/mercadopago.png",
            theme.style14W800,
            paymentMethod == 7, (val) {
              if (val) {
                paymentMethod = 7;
                _redraw();
              }
            })));

  //
  // Instamojo
  //
  if (appSettings.instamojoEnable)
    list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        decoration: BoxDecoration(
          color: (theme.darkMode) ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: checkBox43("Instamojo",
            theme.booking4CheckBoxColor, "assets/instamojo.png",
            theme.style14W800,
            paymentMethod == 8, (val) {
              if (val) {
                paymentMethod = 8;
                _redraw();
              }
            })));

  //
  // Payu
  //
  if (appSettings.payUEnable)
    list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        decoration: BoxDecoration(
          color: (theme.darkMode) ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: checkBox43("PayU",
            theme.booking4CheckBoxColor, "assets/payu.png",
            theme.style14W800,
            paymentMethod == 9, (val) {
              if (val) {
                paymentMethod = 9;
                _redraw();
              }
            })));

  //
  // Paymob
  //
  if (appSettings.payMobEnable)
    list.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        decoration: BoxDecoration(
          color: (theme.darkMode) ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: checkBox43("PayMob",
            theme.booking4CheckBoxColor, "assets/paymob.png",
            theme.style14W800,
            paymentMethod == 10, (val) {
              if (val) {
                paymentMethod = 10;
                _redraw();
              }
            })));
}

paymentProcess(double _amount, String _desc,
    Function(bool) _waits, BuildContext context, Function() book2, MainModel mainModel) async {

  _mainModel = mainModel;
  _context = context;
  _book2 = book2;

  // double _amount = getTotal();
  double _total = _amount * 100;
  int _totalInt = _total.toInt();
  // String _totalString = getTotal().toStringAsFixed(appSettings.digitsAfterComma);
  String _totalString = _amount.toStringAsFixed(appSettings.digitsAfterComma);

  String _currencyCode = appSettings.code;
  String _userName = getCurrentAddress().name;
  // String _userAddress = _mainModel.account.getCurrentAddress().address;
  String _userPhone = getCurrentAddress().phone;
  String _userEmail = userAccountData.userEmail;
  //
  //
  //
  if (paymentMethod == 1)
    _appointment(strings.get(81)); /// "Cash payment",
  //
  // Stripe
  //
  if (paymentMethod == 2){
    StripeMobile _stripe = StripeMobile();
    _waits(true);
    try {
      _stripe.init(appSettings.stripeKey);
      _stripe.openCheckoutCard(_totalInt, // amount
          _desc,
          _userPhone,
          strings.get(0),
          _currencyCode,
          appSettings.stripeSecretKey,
          _appointment);
    }catch(ex){
      _waits(false);
      print(ex.toString());
      messageError(context, ex.toString());
    }

    // StripeModel _stripe = StripeModel();
    // _waits(true);
    // try {
    //   _stripe.init(_mainModel.localAppSettings.stripeKey);
    //   var t = _total.toInt();
    //   _stripe.openCheckoutCard(t, "", "",
    //       _mainModel.localAppSettings.razorpayName,
    //       _mainModel.localAppSettings.code,
    //       _mainModel.localAppSettings.stripeSecretKey, _appointment);
    // }catch(ex){
    //   _waits(false);
    //   print(ex.toString());
    //   messageError(context, ex.toString());
    // }
  }
  if (paymentMethod == 3){
    _waits(true);
    RazorpayMobile _razorpayModel = RazorpayMobile();
    _razorpayModel.init();
    _razorpayModel.openCheckout(
        _totalInt.toString(),
        _desc,
        _userPhone,
        appSettings.razorpayName,
        _currencyCode,
        appSettings.razorpayKey,
        _appointment, (String err){messageError(context, err);}
    );

    // _waits(true);
    // RazorpayModel _razorpayModel = RazorpayModel();
    // _razorpayModel.init();
    //
    // var t = _total.toInt();
    // _razorpayModel.openCheckout(t.toString(), "", "",
    //     _mainModel.localAppSettings.razorpayName,
    //     _mainModel.localAppSettings.code,
    //     _mainModel.localAppSettings.razorpayKey,
    //     _appointment, (String err){messageError(context, err);}
    // );
  }
  if (paymentMethod == 4){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaypalPayment(
            currency: _currencyCode,
            userFirstName: _userName,
            userLastName: "",
            userEmail: _userEmail,
            payAmount: _totalString,
            secret: appSettings.paypalSecretKey,
            clientId: appSettings.paypalClientId,
            sandBoxMode: appSettings.paypalSandBox.toString(),
            onFinish: (w){
              _appointment("PayPal: $w");
            }
        ),
      ),
    );

    // String _total = localSettings.getTotalString(_mainModel);
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => PaypalPayment(
    //         currency: _mainModel.localAppSettings.code,
    //         userFirstName: "",
    //         userLastName: "",
    //         userEmail: "",
    //         payAmount: _total,
    //         secret: _mainModel.localAppSettings.paypalSecretKey,
    //         clientId: _mainModel.localAppSettings.paypalClientId,
    //         sandBoxMode: _mainModel.localAppSettings.paypalSandBox.toString(),
    //         onFinish: (w){
    //           _appointment("PayPal: $w");
    //         }
    //     ),
    //   ),
    // );
  }
  //
  // Flutterwave
  //
  if (paymentMethod == 5){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlutterwaveMobile(
            onFinish: (String w){
              _appointment("Flutterwave: $w");
              _waits(false);
            },
            desc: _desc,
            amount: _totalString, //getTotal().toStringAsFixed(appSettings.digitsAfterComma),
            code: _currencyCode, // currency code
            flutterWavePublicKey: appSettings.flutterWavePublicKey,
            userName: _userName,
            userEmail: _userEmail,
            userPhone: _userPhone
        ),
      ),
    );
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => FlutterwavePayment(
    //         onFinish: (String w){
    //           _appointment("Flutterwave: $w");
    //           _waits(false);
    //         }
    //     ),
    //   ),
    // );
  }
  //
  // Paystack
  //
  if (paymentMethod == 6){
    var ret = await PayStackMobile().handleCheckout(_amount, _userEmail,
        context, appSettings.payStackKey);
    if (ret != null)
      _appointment(ret);
    // var _total = localSettings.getTotal(_mainModel);
    // var paystack = PayStackModel();
    // var ret = await paystack.handleCheckout(_total, _mainModel.userEmail, context, _mainModel.localAppSettings.payStackKey);
    // if (ret != null)
    //   _appointment(ret);
  }
  //
  // Mercadopago
  //
  if (paymentMethod == 7){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MercadoPagoMobile(
          onFinish: (String w){
            _appointment("MercadoPago: $w");
            _waits(false);
          },
          desc: _desc,
          amount: _amount,
          accessToken: appSettings.mercadoPagoAccessToken,
          publicKey: appSettings.mercadoPagoPublicKey,
          code: appSettings.demo ? "BRL" : appSettings.code,
        ),
      ),
    );
  }
  //
  // Instamojo
  //
  if (paymentMethod == 8){
    String _total = _totalString; //_amount.toStringAsFixed(appSettings.digitsAfterComma);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InstaMojoMobile(
            userName: _userName,
            email: _userEmail,
            phone: _userPhone,
            payAmount: _total,
            token: appSettings.instamojoToken, // PrivateToken
            apiKey: appSettings.instamojoApiKey, // ApiKey
            sandBoxMode: appSettings.instamojoSandBoxMode.toString(), // SandBoxMode
            onFinish: (w){
              _appointment("INSTAMOJO: $w");
            }
        ),
      ),
    );
  }
  //
  // Payu
  //
  if (paymentMethod == 9){
    // String _total = _totalPrice.total.toStringAsFixed(_mainModel.localAppSettings.digitsAfterComma);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PayUMobile(
            userName: _userName,
            email: _userEmail,
            phone: _userPhone,
            payAmount: _totalString,
            apiKey: appSettings.payUApiKey, // ApiKey
            merchantId: appSettings.payUMerchantId,
            sandBoxMode: appSettings.payUSandBoxMode.toString(),
            onFinish: (w){
              dprint("PayU: $w");
              _appointment("PayU: $w");
            }
        ),
      ),
    );
  }
  //
  // PayMob
  //
  if (paymentMethod == 10){
    // String _total = _totalPrice.total.toStringAsFixed(_mainModel.localAppSettings.digitsAfterComma);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PayMobMobile(
          userFirstName: _userName,
          userEmail: _userEmail,
          userPhone: _userPhone,
          payAmount: _totalString,
          apiKey: appSettings.payMobApiKey, // ApiKey
          frame: appSettings.payMobFrame, // MobFrame
          integrationId: appSettings.payMobIntegrationId, // IntegrationId
          onFinish: (w){
            dprint("PayMob: $w");
            _appointment("PayMob: $w");
          },
          code: appSettings.code,
          userName: userAccountData.userName,
          mainColor: theme.mainColor,
        ),
      ),
    );
  }
  _waits(false);
}

_appointment(String paymentMethod) async {
  dprint("_appointment $paymentMethod");
  waitInMainWindow(true);
  var ret = await _mainModel.finish(paymentMethod);
  waitInMainWindow(false);
  if (ret != null)
    return messageError(_context, ret);
  _book2();
}



