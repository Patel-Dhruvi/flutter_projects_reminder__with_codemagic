import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reminder_things/AppScreens/AddDetailsScreen.dart';
import 'package:reminder_things/BlocPattern/BlocPattern.dart';
import 'package:reminder_things/ComponentWidget/ReminderDrawer.dart';
import 'package:reminder_things/ComponentWidget/SearchViewcardDesign.dart';
import 'package:reminder_things/ComponentWidget/TabContainer.dart';
import 'package:reminder_things/ComponentWidget/TabMyThingsWidget.dart';
import 'package:reminder_things/ComponentWidget/TabRemindMeWidget.dart';
import 'package:reminder_things/Constants.dart';
import 'package:reminder_things/Model/TextModel.dart';


class Home extends StatefulWidget {

  Home({this.preSelectedTab});

  final int preSelectedTab;
  @override
  _HomeState createState() => _HomeState(this.preSelectedTab);



}

class _HomeState extends State<Home> with TickerProviderStateMixin {

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var tabSelected;

  _HomeState(this.preSelectedTab);


  final int preSelectedTab;
  TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var currentDate = DateTime.now();
    var dateOfDay= setDateFormat(currentDate.day);
    var month=setMonthFormat(currentDate.month);
    date = "$dateOfDay/$month/${currentDate.year}";
    setState(() {
      tabSelected=preSelectedTab;
    });
    tabController = TabController(vsync: this, length: 2);
    tabController.animateTo(preSelectedTab);
  }

  _onTabSelected(int tabNum) {
    setState(() {
      tabSelected = tabNum;
      tabController.animateTo(tabSelected);
    });

  }

  BlocPattern blocPattern = BlocPattern();
  var isSearchViewOpenInTab1 = false;
  var isSearchViewOpenInTab2 = false;
  TextModel selectedInTab1;
  TextModel selectedInTab2;
  var isSearchable = false;
  final dio = new Dio();
  String query = '';
  var itemId = 0;
  var date;
  DateTime currentBackPressTime;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawerEdgeDragWidth: 0,
        resizeToAvoidBottomPadding: false,
        drawer:getDrawer(this.context),
        body: WillPopScope(
          onWillPop: onWillPop,
          child: StreamBuilder(
              stream: blocPattern.data,
              builder: (BuildContext context,
                  AsyncSnapshot<List<TextModel>> snapshot) {
                return Column(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.only(left: 15),
                        decoration: BoxDecoration(
                            color: kAppThemeUpperDarkColor,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      "What would you like to add today?",
                                      style: kMainTextStyle,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: RawMaterialButton(
                                      onPressed: () {
                                        Navigator.pushReplacementNamed(context, '/details',
                                            arguments: AddDetailsScreen(
                                              isListDataTapped: false,
                                              itemId: null,
                                              tabSelected: tabSelected,
                                            ));
                                      },
                                      child: Material(
                                          color: Color(0XFFfff1ce),
                                          elevation: 2.0,
                                          shadowColor: kAppThemeUpperDarkColor,
                                          borderRadius: BorderRadius.circular(22),
                                          child: Icon(
                                            Icons.add_circle_outline,
                                            color: Color(0XFFfccc83),
                                            size: 45,
                                          )),
                                    ),
                                  )
                                ],
                              ),
                            )),
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                      flex: 3,
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 15),
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            color: kSearchBarColor),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 3,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: TextField(
                                                  onTap: () async {
                                                    FocusScope.of(context)
                                                        .requestFocus(FocusNode());
                                                    _openSearchBar(snapshot);

                                                  },
                                                  autofocus: false,
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: "Search Here",
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 0,
                                              child: IconButton(
                                                alignment: Alignment.centerRight,
                                                onPressed: () {
                                                  _openSearchBar(snapshot);
                                                },
                                                icon: const Icon(Icons.search),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 10, top: 15),
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(25),
                                                bottomLeft: Radius.circular(25))),
                                        child: IconButton(
                                          icon: Icon(Icons.menu),
                                          onPressed: () {
                                            _scaffoldKey.currentState
                                                .openDrawer();
                                          },
                                          color: Colors.white,
                                        )),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 4,
                        child: Container(
                          color: Colors.green,
                          child: DefaultTabController(
                            length: 2,
                            child: Scaffold(
                              appBar: PreferredSize(
                                preferredSize: Size.fromHeight(30.0),
                                child: TabBar(
                                  onTap: (int i) {
                                    setState(() {
                                      _onTabSelected(i);
                                    });
                                  },
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  indicatorColor: Colors.transparent,
                                  dragStartBehavior: DragStartBehavior.down,
                                  unselectedLabelColor: kUnSelectedLabelColor,
                                  tabs: [
                                    Tab(
//                                    iconMargin:
//                                        const EdgeInsets.only(bottom: 10.0),
                                      child: TabContainer(
                                        color: tabSelected == 0
                                            ? kRemindColor
                                            : Colors.white,
                                        tabname: "Remind Me",
                                      ),
                                    ),
                                    Tab(
                                      child: TabContainer(
                                        color: tabSelected == 1
                                            ? kRemindColor
                                            : Colors.white,
                                        tabname: "My things",
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              body: TabBarView(
                                controller: tabController,
                                physics: NeverScrollableScrollPhysics(),
                                children: [
                                  tabRemindMeWidget(context, snapshot, date,
                                      selectedInTab1, isSearchViewOpenInTab1,tabSelected),
                                  tabMyThingsWidget(context, snapshot,
                                      selectedInTab2, isSearchViewOpenInTab2,tabSelected),
                                ],
                              ),
                            ),
                          ),
                        ))
                  ],
                );
              }),
        ));
  }

  void _openSearchBar(AsyncSnapshot<List<TextModel>> snapshot) async {
    if (tabSelected == 0) {
      List<TextModel> searchList = List<TextModel>();
      for (int i = 0; i < snapshot.data.length; i++) {
        TextModel textModel = snapshot.data[i];
        if (textModel.date.contains(date)) {
          searchList.add(textModel);
        }
      }
      selectedInTab1 = await showSearch(
          context: context, delegate: _MySearchDelegate(searchList));
      // ignore: unrelated_type_equality_checks
      if (selectedInTab1 != null && selectedInTab1 != query) {
        setState(() {
          query = selectedInTab1.title;
          isSearchViewOpenInTab1 = true;
        });
      } else
        isSearchViewOpenInTab1 = false;
    } else {
      selectedInTab2 = await showSearch(
          context: context, delegate: _MySearchDelegate(snapshot.data));
      // ignore: unrelated_type_equality_checks
      if (selectedInTab2 != null && selectedInTab2 != query) {
        setState(() {
          query = selectedInTab2.title;
          isSearchViewOpenInTab2 = true;
        });
      } else
        isSearchViewOpenInTab2 = false;
    }
  }

 Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Tap back Once more to exit");
      return Future.value(false);
    }
    return Future.value(true);
  }
}

class _MySearchDelegate extends SearchDelegate<TextModel> {
  _MySearchDelegate(this.listOFData);

  final List<TextModel> listOFData;


  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: 'Clear',
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
        child: Text(
      "No Data is found First Add Data",
      style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w500,
          fontFamily: "Roboto"),
    ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    for (int i = 0; i < listOFData.length; i++) {
      TextModel textModel = listOFData[i];
      if (query.contains(textModel.title)) {
        listOFData.add(textModel);
      }
    }

    final suggestions=listOFData.where((c) {
            return c.title.toLowerCase().contains(query);
          }).toList();

    if (listOFData.length == 0)
      showResults(context);

    if(suggestions.length==0)
      return displayInCenter();

    return ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (BuildContext context, int index) {
            TextModel textModel = suggestions[index];
            return GestureDetector(
                onTap: () {
                  close(context, suggestions[index]);
                },
                child: listViewSearchCardDesign(textModel));
          });
  }
}
