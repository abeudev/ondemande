import 'package:universal_html/html.dart';
import 'dart:core';
import 'package:abg_utils/payments_web.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/mainModel/filter.dart';
import 'package:ondemand_admin/mainModel/payments/instamojo/instamojo_payment.dart';
import 'package:ondemand_admin/mainModel/payments/paypal.dart';
import 'package:ondemand_admin/ui/products.dart';
import 'package:ondemand_admin/ui/profile.dart';
import 'package:ondemand_admin/ui/provider.dart';
import 'package:ondemand_admin/ui/providers_all.dart';
import 'package:ondemand_admin/ui/account/register.dart';
import 'package:ondemand_admin/ui/rate.dart';
import 'package:ondemand_admin/ui/search.dart';
import 'package:ondemand_admin/ui/service.dart';
import 'package:ondemand_admin/widgets/menu4.dart';
import 'package:provider/provider.dart';
import '../mainModel/model.dart';
import '../theme.dart';
import 'account/mobile_phone.dart';
import 'account/otp.dart';
import 'address/add.dart';
import 'address/add_address_dialog.dart';
import 'address/add_map.dart';
import 'address/details.dart';
import 'address/list.dart';
import 'app_bar.dart';
import 'article.dart';
import 'blog.dart';
import 'blog_all.dart';
import 'booking/booking1.dart';
import 'booking/booking2.dart';
import 'booking/booking3.dart';
import 'booking/booking4a.dart';
import 'booking/cancel.dart';
import 'booking/checkout1.dart';
import 'booking/checkout2.dart';
import 'bookings.dart';
import 'bottom.dart';
import 'cart.dart';
import 'category.dart';
import 'documents.dart';
import 'account/forgot.dart';
import 'favorite.dart';
import 'favorite_providers.dart';
import 'home.dart';
import 'strings.dart';
import 'account/login.dart';
import 'jobinfo.dart';
import 'notify.dart';
import 'package:abg_utils/abg_utils.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

double windowWidth = 0;
double windowHeight = 0;
bool isTable() => (windowWidth >= 800 && windowWidth <= 1200);

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin{

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late MainModel _mainModel;
  bool _openMenuAccount = false;
  bool _openMenuLang = false;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    window.history.pushState(_state, _state, '$currentHost/#/$_state');
    _mainModel.setMainWindow(_redraw, _route, _openDialog, _waits, context);
    _init();
    _getWorkspaceHeight();
    initialFilter(_mainModel);
    super.initState();
  }

  bool _needOpenGallery = false;

  _openGallery(){
    _needOpenGallery = true;
    _redraw();
  }

  _init() async {
    var ret = await _mainModel.init(context, _redraw);
    if (ret != null)
      messageError(context, ret);
    _redraw();
  }

  List<Menu4Data> menu1 = [];

  _initMenu(User? user){
    menu1 = [];

    if (user != null){
      menu1.add(Menu4Data("booking", strings.get(124), icon: null));              /// "Booking",
      menu1.add(Menu4Data("profile", strings.get(125), icon: null));              /// "Profile",
      menu1.add(Menu4Data("favorite", strings.get(126), icon: null));             /// "Favorites",
      menu1.add(Menu4Data("provider_favorite", strings.get(185), icon: null));    /// "Favorite Providers",
      menu1.add(Menu4Data("notify", strings.get(127), icon: null));               /// "Notifications",
      menu1.add(Menu4Data("address_list", strings.get(128), icon: null));         /// "My Address",
      menu1.add(Menu4Data("divider", ""));
      menu1.add(Menu4Data("logout", strings.get(40), icon: null));                /// "Sign Out",
    }else{
      menu1.add(Menu4Data("login", strings.get(179), icon: null));                /// "Login",
    }

    menu1.add(Menu4Data("divider", ""));
    menu1.add(Menu4Data("documents:policy", strings.get(27), icon: null));         /// "Privacy Policy",
    menu1.add(Menu4Data("documents:about", strings.get(28), icon: null));         /// "About Us",
    menu1.add(Menu4Data("documents:terms", strings.get(29), icon: null));         /// "Terms & Conditions",

    List<Menu4Data> menuLang = [];
    for (var item in _mainModel.lang.appLangs)
      menuLang.add(Menu4Data("lang:${item.locale}", item.name));

    menu1.add(Menu4Data("divider", ""));
    menu1.add(Menu4Data("lang", "${strings.get(180)}: English", icon: Icons.language,  /// "Current"
        child: menuLang)); //
  }

  var _state = "home";   // initial route

  final GlobalKey _rowKey = GlobalKey();
  double _rowHeight = 0;

  final GlobalKey _searchKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    openGallery = _openGallery;

    User? user = FirebaseAuth.instance.currentUser;

    _initMenu(user);

    if (_mainModel.payPalSuccess || _mainModel.stripeSuccess || _mainModel.flutterwave
        || _mainModel.razorpaySuccess || _mainModel.mercadoPagoSuccess) {
      _state = "payment_success";
      // dprint("build _mainModel.mercadoPagoSuccess=${_mainModel.mercadoPagoSuccess}");
    }

    if (_mainModel.payPalCancel || _mainModel.stripeCancel)
      _state = "payment_cancel";

    Widget _child = Container();
    if (_state == "home")
      _child = HomeScreen();
    if (_state == "providers_all")
      _child = ProvidersAllScreen();
    if (_state == "provider")
      _child = ProviderScreen();
    if (_state == "service")
      _child = ServiceScreen();
    if (_state == "blog_all")
      _child = BlogsAllScreen();
    if (_state == "blog_details")
      _child = BlogScreen();
    if (_state == "category")
      _child = CategoryScreen();
    if (_state == "documents")
      _child = DocumentsScreen();
    if (_state == "login")
      _child = LoginScreen();
    if (_state == "forgot")
      _child = ForgotScreen();
    if (_state == "register")
      _child = RegisterScreen();
    if (_state == "otp")
      _child = OTPScreen();
    if (_state == "address_list")
      _child = AddressListScreen();
    if (_state == "address_add")
      _child = AddressAddScreen();
    if (_state == "address_add_map")
      _child = AddressAddMapScreen();
    if (_state == "address_details")
      _child = AddressDetailsMapScreen();
    if (_state == "book")
      _child = BookNowScreen();
    if (_state == "book1")
      _child = BookNow2Screen();
    if (_state == "book2")
      _child = BookNow3Screen();
    if (_state == "payment_success")
      _child = BookNow4aScreen();
    if (_state == "payment_cancel")
      _child = BookNowCancelScreen();
    if (_state == "profile")
      _child = ProfileScreen();
    if (_state == "favorite")
      _child = FavoriteScreen();
    if (_state == "provider_favorite")
      _child = FavoriteProvidersScreen();
    if (_state == "notify")
      _child = NotifyScreen();
    if (_state == "booking")
      _child = BookingScreen();
    if (_state == "jobinfo")
      _child = JobInfoScreen();
    if (_state == "rate")
      _child = RatingScreen();
    if (_state == "article")
      _child = ArticleScreen();
    if (_state == "cart")
      _child = CartScreen();
    if (_state == "checkout1")
      _child = CheckOut1Screen();
    if (_state == "checkout2")
      _child = CheckOut2Screen();
    if (_state == "products")
      _child = ProductsScreen();

    if (needOTPParam && _state != "otp" && user != null)
      _child = MobilePhoneScreen();

    drawState(_state, _route, context, _redraw, strings.locale, _waits, windowWidth, windowHeight);

    var _child2 = (_state == "home" || _state == "service"
        || _state == "address_add_map" || _state == "address_details"
        || _state == "book2" || _state == "booking")
      ? Container(
          margin: EdgeInsets.only(top: isMobile() ? 120 : 80),
          child: _child
      )
        :
    Container(
        margin: EdgeInsets.only(top: isMobile() ? 120 : 80),
        child: ListView(
          children: [
            Container(
              key: _rowKey,
              margin: isMobile() ? EdgeInsets.only(left: 10, right: 10)
                  : EdgeInsets.only(left: windowWidth*0.1, right: windowWidth*0.1),
              child: _child,
            ),
            Container(height: _rowHeight,),
            getBottomWidget(_mainModel)
          ],
        ));

    if (_mainModel.searchActivate)
      _child2 = Container(
        key: _searchKey,
        margin: EdgeInsets.only(top: isMobile() ? 120 : 80),
        child: SearchScreen(),
      );

    // print("_child2=${_child2.child.toString()}");

    return WillPopScope(
        onWillPop: () async {
          dprint("WillPopScope _mainModel.goBack()");
          goBack();
          return false;
        },
    child: Scaffold(
          key: _scaffoldKey,
          drawer: Menu4(context: context, callback: _menuRoute, data: menu1,
              header: Container(height: 50, color: theme.mainColor,), noPop: false,
              style: theme.style14W400, hoverStyle: theme.style14W800,
              iconColor: Colors.grey, hoverIconColor: Colors.blue,
              bgkColor: (theme.darkMode) ? Colors.black : Colors.white,
              hoverBkgColor: (theme.darkMode) ? Colors.black : Color(0xfff0f0f0),
              select : _state, bkgColor: Colors.white
          ),
          backgroundColor: Colors.white,
          body: Directionality(
              textDirection: strings.direction,
              child: ScrollConfiguration(
                  behavior: MyCustomScrollBehavior(),
                  child: GestureDetector(
                    onTap: (){
                      _openMenuAccount = false;
                      _openMenuLang = false;
                      _redraw();
                    },
                    child: Stack(
                    children: <Widget>[

                      _child2,

                      Column(
                        children: [
                          TopAppBar(
                            openMenuLangs: (){
                              _openMenuLang = true;
                              _openMenuAccount = false;
                              _redraw();
                            },
                            openMenuAccount: (){
                              _openMenuLang = false;
                              _openMenuAccount = true;
                              _redraw();
                            },
                            openMobileMenu: (){
                              _scaffoldKey.currentState!.openDrawer();
                            },
                          ),
                          Container(color: Colors.grey, height: 1,),
                        ],
                      ),

                      if (_needOpenGallery)
                        InkWell(
                            onTap: (){
                              _needOpenGallery = false;
                              _redraw();
                            },
                            child: Container(
                              width: windowWidth,
                              height: windowHeight,
                              color: Colors.black.withAlpha(200),
                              child: GalleryScreenWeb(),
                            )
                        ),

                      if (_addAddressDialogOpen)
                        InkWell(
                            onTap: (){
                              _addAddressDialogOpen = false;
                              _redraw();
                            },
                            child: Container(
                              width: windowWidth,
                              height: windowHeight,
                              color: Colors.black.withAlpha(200),
                              child: AddAddressScreen(close: (){
                                _addAddressDialogOpen = false;
                                _redraw();
                              },),
                            )
                        ),

                      if (_wait)
                        Positioned.fill(
                          child: Center(child: Container(child: Loader7(color: theme.mainColor,))),
                        ),

                      if (_mainModel.flutterwaveShow)
                        FlutterwavePayment(amount: _mainModel.total, desc: _mainModel.desc,
                            close: (){
                              finishDelete();
                              _mainModel.flutterwaveShow = false;
                              _redraw();
                            }),
                      if (_mainModel.payPalShow)
                        PayPalPayment(amount: _mainModel.total, desc: _mainModel.desc),
                      if (_mainModel.instamojoShow)
                        InstaMojoPayment(
                            userName: userAccountData.userName,
                            email: userAccountData.userEmail,
                            phone: userAccountData.userPhone,
                            payAmount: getTotal().toStringAsFixed(appSettings.digitsAfterComma),
                            token: appSettings.instamojoToken, // PrivateToken
                            apiKey: appSettings.instamojoApiKey, // ApiKey
                            sandBoxMode: appSettings.instamojoSandBoxMode.toString(), // SandBoxMode
                      ),

                      if (_openMenuAccount)
                        accountMenu(_mainModel, (String _state){
                          _openMenuAccount = false;
                          _route(_state);
                        }),
                      if (_openMenuLang)
                        langMenu(_mainModel, (){
                          _openMenuLang = false;
                        }, context),


                    ],
                  )
              ))
      )
    ));

  }

  bool _wait = false;
  _waits(bool value){
    _wait = value;
    _redraw();
  }
  _redraw(){
    if (mounted)
      setState(() {
      });
  }


  // bool routeCanBack = true;
  String _lastState = "home";

  _route(String state){
    _state = state;

    window.history.pushState(state, state, '$currentHost/#/$state');
    window.onPopState.listen((PopStateEvent e) {
      print("onPopState.listen ${e.state}");
      if (_lastState != e.state){
        goBack();
        _lastState = e.state;
        print("_lastState = $_lastState");
      }
    });

    if (_state.isEmpty)
      _state = "home";

    if (_state != "payment_success") {
      _mainModel.stripeSuccess = false;
      _mainModel.payPalSuccess = false;
      _mainModel.razorpaySuccess = false;
      _mainModel.flutterwave = false;
      _mainModel.mercadoPagoSuccess = false;
      // print("_route _mainModel.mercadoPagoSuccess=${_mainModel.mercadoPagoSuccess}");
    }
    if (_state != "payment_cancel") {
      _mainModel.stripeCancel = false;
      _mainModel.payPalCancel = false;
    }

    _getWorkspaceHeight();
    _openMenuAccount = false;
    _openMenuLang = false;
    _mainModel.searchActivate = false;

    _wait = false;
    _redraw();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _redraw();
    });
  }

  _getWorkspaceHeight(){
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_rowKey.currentContext != null){
        _rowHeight = _rowKey.currentContext!.size!.height;
        setState(() {});
        _rowHeight = windowHeight-_rowHeight-280;
        if (_rowHeight < 0)
          _rowHeight = 0;
        // print("_rowHeight=$_rowHeight");
      }
    });
  }

  bool _addAddressDialogOpen = false;

  _openDialog(String dialogName){
    if (dialogName == "addAddress"){
      _addAddressDialogOpen = true;
      _redraw();
    }
  }

  _menuRoute(String _state){
    if (_state.startsWith("documents")){
      if (_state.endsWith("policy"))
        _mainModel.openDocument = "policy";
      if (_state.endsWith("about"))
        _mainModel.openDocument = "about";
      if (_state.endsWith("terms"))
        _mainModel.openDocument = "terms";
      _state = "documents";
    }
    if (_state == "lang")
      _state = "home";
    if (_state == "logout") {
      logout();
      _state = "home";
    }
    if (_state.startsWith("lang")){
      var index = _state.indexOf(":");
      var _locale = _state.substring(index+1);
      _mainModel.lang.setAppLang(_locale, context);
      return;
    }

    _route(_state);
  }
}



