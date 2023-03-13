import 'package:abg_utils/abg_utils.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_admin/model/model.dart';
import 'package:provider/provider.dart';
import 'package:ondemand_admin/ui/strings.dart';
import 'package:ondemand_admin/ui/theme.dart';
import '../../../utils.dart';
import 'edit.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:convert';

class OffersScreen extends StatefulWidget {
  @override
  _OffersScreenState createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {

  late MainModel _mainModel;
  final ScrollController _controllerScroll = ScrollController();

  @override
  void dispose() {
    _controllerScroll.dispose();
    _mainModel.offer.current = OfferData.createEmpty();
    super.dispose();
  }

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      waitInMainWindow(true);
      var ret = await _mainModel.offer.load();
      if (ret != null)
        messageError(context, ret);
      // ret = await _mainModel.provider.load(context);
      // if (ret != null)
      //   messageError(context, ret);
      ret = await _mainModel.service.load(context);
      if (ret != null)
        messageError(context, ret);
      waitInMainWindow(false);
    });
    super.initState();
  }

  _redraw(){
    if (mounted)
      setState(() {
      });
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
          ),
    );
  }

  _getList(){
    // ignore: unnecessary_statements
    context.watch<MainModel>().offer.current;

    List<Widget> list = [];
    list.add(SizedBox(height: 10,));
    list.add(Row(
      children: [
        Expanded(child: SelectableText(strings.get(156),                       /// "Offers",
          style: theme.style25W800,)),
      ],
    ));
    list.add(SizedBox(height: 20,));
    list.add(Divider(thickness: 0.2, color: (theme.darkMode) ? Colors.white : Colors.black,));
    list.add(SizedBox(height: 10,));

    addButtonsCopyExportSearch(list, _copy, _csv, strings.langCopyExportSearch, _onSearch);
    pagingStart();

    List<DataRow> _cells = [];
    for (var item in _mainModel.offer.offers){
      if (!item.code.toUpperCase().contains(_searchedValue.toUpperCase()))
        continue;
      if (isNotInPagingRange())
        continue;
      _cells.add(DataRow(cells: [
        /// code
        DataCell(Container(child: Text(item.code, overflow: TextOverflow.ellipsis, style: theme.style14W400,))),
        /// "Discount",
        DataCell(Container(child: Text('${_mainModel.offer.getDiscountText(item)}', overflow: TextOverflow.ellipsis, style: theme.style14W400))),
        /// Expire
        DataCell(Container(child: Text(appSettings.getDateTimeString(item.expired),
            overflow: TextOverflow.ellipsis, style: theme.style14W400))),
        /// action
        DataCell(Center(child:Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 5,),
                button2small(strings.get(68), (){ /// "Edit",
                  _notEditorCreate = false;
                  _mainModel.offer.select(item);
                }, color: theme.mainColor.withAlpha(150)),
                SizedBox(width: 5,),
                button2small(strings.get(62),
                    (){_openDialogDelete(item);}, color: dashboardErrorColor.withAlpha(150)), // "Delete",
                SizedBox(width: 5,),
              ],
            )
        ))
        ]));
    }

    List<DataColumn> _column = [
      DataColumn(label: Expanded(child: Text(strings.get(163), style: theme.style14W600Grey))), /// Code
      DataColumn(label: Expanded(child: Text(strings.get(164), style: theme.style14W600Grey))), /// "Discount",
      DataColumn(label: Expanded(child: Text(strings.get(167), style: theme.style14W600Grey))), /// "Expire",
      DataColumn(label: Expanded(child: Center(child: Text(strings.get(66), style: theme.style14W600Grey)))), /// action
    ];

    list.add(Container(
        color: (theme.darkMode) ? Colors.black : Colors.white,
        child: horizontalScroll(DataTable(
            columns: _column,
            rows: _cells,
      ), _controllerScroll))
    );

    paginationLine(list, _redraw, strings.get(88)); /// from
    //
    //
    //

    list.add(SizedBox(height: 40));
    list.add((!_notEditorCreate)
        ? EditInOffers()
        : Center(child: button2b(strings.get(169), (){ /// "Create new offer",
            _notEditorCreate = false;
            _redraw();
          })),
    );

    return list;
  }

  var _notEditorCreate = true;

  _openDialogDelete(OfferData value){
    openDialogDelete(() async {
      Navigator.pop(context); // close dialog
      // demo mode
      if (appSettings.demo)
        return messageError(context, strings.get(65)); /// "This is Demo Mode. You can't modify this section",
      var ret = await _mainModel.offer.delete(value);
      if (ret == null)
        messageOk(context, strings.get(69)); /// "Data deleted",
      else
        messageError(context, ret);
      setState(() {});
    }, context);
  }

  _copy(){
    _mainModel.offer.copy();
    messageOk(context, strings.get(53)); /// "Data copied to clipboard"
  }

  _csv(){
    html.AnchorElement()
      ..href = '${Uri.dataFromString(_mainModel.offer.csv(), mimeType: 'text/plain', encoding: utf8)}'
      ..download = "offers.csv"
      ..style.display = 'none'
      ..click();
  }

  String _searchedValue = "";
  _onSearch(String value){
    _searchedValue = value;
   _redraw();
  }
}
