
import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/model/model.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../strings.dart';
import '../theme.dart';

class TreeCategoryInOffers extends StatefulWidget {
  @override
  _TreeCategoryInOffersState createState() => _TreeCategoryInOffersState();
}

class _TreeCategoryInOffersState extends State<TreeCategoryInOffers> {

  final ScrollController _controllerTree = ScrollController();

  @override
  void dispose() {
    _controllerTree.dispose();
    super.dispose();
  }

  bool _onlySelected = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> list2 = [];

    list2.add(SizedBox(height: 10,));
    list2.add(checkBox1a(context, strings.get(168), /// "Only selected"
        theme.mainColor, theme.style14W400, _onlySelected,
            (val) {
          if (val == null) return;
          _onlySelected = val;
          setState(() {
          });
        }));
    list2.add(SizedBox(height: 10,));

    getListTree(list2, "", 0,);

    return treeWindow(list2);
  }

  String selectId = "";

  treeWindow(List<Widget> list2){
    return Container(
            decoration: BoxDecoration(
              color: (theme.darkMode) ? dashboardColorCardDark : dashboardColorCardGrey,
              borderRadius: BorderRadius.circular(theme.radius),
            ),
            width: (windowWidth/2 < 600) ? 600 : windowWidth/2,
            height: windowHeight*0.4,
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Scrollbar(
              controller: _controllerTree,
              isAlwaysShown: true,
              child: ListView(
                controller: _controllerTree,
                children: list2,
              ),
            )
    );
  }

  getListTree(List<Widget> list2, String parent, double align){

    for (var item in categories){
      if (item.parent == parent) {
        if (_onlySelected && !item.select) {
          getListTree(list2, item.id, align+30);
          continue;
        }
        Widget _image = (item.serverPath.isNotEmpty) ? Image.network(item.serverPath, fit: BoxFit.contain) : Container();
        list2.add(Stack(
          children: [
            Container(
                key: item.dataKey2,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(left: align, top: 5, bottom: 5),
                decoration: BoxDecoration(
                  color: (selectId == item.id) ? theme.mainColor.withAlpha(120) : (theme.darkMode) ? Colors.black : dashboardColorCardGreenGrey,
                  borderRadius: BorderRadius.circular(theme.radius),
                ),
                child: Row(children: [
                  Container(
                      width: 40,
                      height: 40,
                      child: _image),
                  SizedBox(width: 20,),
                  Expanded(child: Text(Provider.of<MainModel>(context,listen:false).getTextByLocale(item.name), style: theme.style14W400,)),
                ],)),
            Positioned.fill(
              child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.grey[400],
                    onTap: (){
                      //Provider.of<ProviderModel>(context,listen:false).setSelectedId(item);
                    },
                  )),
            ),
            Positioned.fill(
                child: Container(
                  margin: EdgeInsets.only(left: 40, right: 40),
                  alignment: Alignment.centerRight,
                 child: checkBox0(theme.mainColor, item.select, (val) {
                   item.select = val!;
                   Provider.of<MainModel>(context,listen:false).offer.changeCategory();
                   setState(() {});
                 })
                )
            )
          ],
        )
        );
        getListTree(list2, item.id, align+30);
      }
    }
  }
}
