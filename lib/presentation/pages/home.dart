import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../../data/models/GlobalFeedModel.dart';
import '../bloc/global_feed_bloc.dart';
import '../widgets/default_loader.dart';
import '../widgets/feedViews.dart';
import '../widgets/no_connection.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  StreamSubscription? connection;
  bool? isoffline;
  String? _chosenValue = "Recent";
  final GlobalFeedBloc _globalFeedBloc = GlobalFeedBloc();
  List<Data>? dataList;
  Future<GlobalFeedModel?>? myFuture;


  @override
  void initState() {
    _getData();
    super.initState();
  }

  _getData() async {
    connection = await Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      print(result.toString());
      // whenevery connection status is changed.
      if (result == ConnectivityResult.none) {
        //there is no any connection
        setState(() {
          isoffline = true;
        });
        // showDialog(
        //     context: context,
        //     builder: (context) {
        //       return AlertDialog(
        //         title: const Text('No Internet Connection'),
        //         content: const Text('Do you want to proceed?'),
        //         actions: <Widget>[
        //           FlatButton(
        //             onPressed: () {
        //               Navigator.of(context, rootNavigator: true)
        //                   .pop(false);
        //             },
        //             child: const Text('No'),
        //           ),
        //           FlatButton(
        //             onPressed: () {
        //               Navigator.of(context, rootNavigator: true)
        //                   .pop(
        //                   true); // dismisses only the dialog and returns true
        //             },
        //             child: const Text('Yes'),
        //           ),
        //         ],
        //       );
        //     });
      } else {
        //connection is from bluetooth threatening
        setState(() {
          isoffline = false;
        });
        _getGlobalFeedBlocData();
      }
    });
  }

  _getGlobalFeedBlocData() async {
    myFuture = _globalFeedBloc.fetchGlobalFeedFromURL();
  }

  @override
  void dispose() {
    connection!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: FutureBuilder<GlobalFeedModel?>(
              future: myFuture,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return NoConnectionWidget();
                  case ConnectionState.waiting:
                    return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0.0,
                            vertical: 3.0
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(top:50.0),
                          child: Center(
                            child: DefaultLoaderWidget(),
                          ),
                        ));
                  default:
                    if (snapshot.hasData) {
                      dataList = snapshot.data!.data!;
                      return Column(
                        children: [
                          AppBar(
                            backgroundColor: Colors.black,
                            actions: [
                              Row(
                                children: [
                                  const Text(
                                    "Sort By: ",
                                    style: TextStyle(fontSize: 16, color: Colors.grey),
                                  ),
                                  DropdownButton<String>(
                                    focusColor: Colors.black,
                                    dropdownColor: Colors.black,
                                    value: _chosenValue, //selected
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    iconSize: 34,
                                    elevation: 16,
                                    style: const TextStyle(color: Colors.white, fontSize: 18),
                                    underline: Container(
                                      height: 0,
                                      color: Colors.black,
                                    ),
                                    onChanged: (String? newValue) {
                                      _chosenValue = newValue;
                                      if (newValue == "Recent") {
                                        dataList!.sort((b,a) => a.id!.compareTo(b.id!));
                                      } else {
                                        dataList!.sort((b,a) => b.id!.compareTo(a.id!));
                                      }
                                      setState(() {});
                                    },
                                    items: <String>["Recent", "Oldest"]
                                        .map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value.toString()),
                                      );
                                    }).toList(),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.center,
                            child: SingleChildScrollView(
                                child: feedView(context, dataList!)),
                          )
                        ],
                      );
                    } else {
                      return const SizedBox(
                        height: 100,
                        child: Text("No Data from API", style: TextStyle(color: Colors.white)),
                      );
                    }
                }
              }),
        ));
  }



}
