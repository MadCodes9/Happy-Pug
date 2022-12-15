import 'dart:ffi';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:pie_chart/pie_chart.dart';

class MySearchResultsPage extends StatefulWidget {
  const MySearchResultsPage({Key? key, required this.title, required this.foundIngred,
  required this.numOfgreenIngred, required this.numOfredIngred, required this.numOfyellowIngred,
  required this.scannedImage, required this.imageUrl, required this.isDarkModeEnabled,
  required this.grade, required this.gradeColor, required this.pieChartData})
      : super(key: key);//constructor
  final String title; //attribute
  final int numOfgreenIngred;
  final int numOfredIngred;
  final int  numOfyellowIngred;
  final Image scannedImage;
  final bool isDarkModeEnabled;
  final Map<String, List<String>> foundIngred;
  final Map<String, double> grade;
  final Map<String, double> pieChartData;
  final imageUrl;
  final Color gradeColor;

  @override
  State<MySearchResultsPage> createState() => _MySearchResultsState();
}

class _MySearchResultsState extends State<MySearchResultsPage> {
  Map<String, List<String>> results = {};
  List<String> keys = [];

  Map<String, dynamic> databaseDescription = {};
  Map<String, dynamic> databaseRating = {};
  Map<String, dynamic> databaseLabel = {};
  Map<String,Color> databaseColor = {};
  List<String> databaseKeys = [];

  bool _isVisible = true;
  bool _isVisible2 = false;
  bool _isVisible3 = true;
  bool pressed1 = true;
  bool pressed2 = false;
  bool pressed3 = true;
  Text rating = Text("");
  Map<String,Color> btnColor = {};
  var myGroup1 = AutoSizeGroup(); //synchronize font sizes
  var myGroup2 = AutoSizeGroup();
  var myGroup3 = AutoSizeGroup();
  var isPortrait;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState(){
    super.initState();
    setAttributes(); //Access widget attributes
    setButtonColor(); //dynamically set background color

    getDatabase(); //set database variables at the start
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme(),
      darkTheme: darkTheme(),
      themeMode: widget.isDarkModeEnabled ? ThemeMode.dark : ThemeMode.light,
      home:  Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              splashRadius: 0.5,
              padding: EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
                onPressed: () => mainPage(),
                icon: Icon(
                  Icons.home_rounded,
                  color: Colors.white,
                  size: 27,
                ),
            ),
          ],
          title: AutoSizeText(
              "Results",
              textAlign: TextAlign.left,
              maxLines: 1,
              minFontSize: 12,
              presetFontSizes: [20, 18, 14],
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 20)
          ),

        ),
        body: GlowingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              color:  Colors.deepPurple,
              child: Scrollbar(
                controller: _scrollController,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

                        //if in landscape mode display following
                        if(MediaQuery.of(context).orientation == Orientation.landscape)
                          Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      //display pug image
                                      if(widget.imageUrl != null)
                                        Expanded(
                                            child: Container(
                                                alignment: Alignment.center,
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                        width: MediaQuery.of(context).size.width / 2,
                                                        height: MediaQuery.of(context).size.height,
                                                        child: Padding(
                                                          padding: EdgeInsets.all(10),
                                                          child:  Image.network(
                                                            widget.imageUrl,
                                                          ),
                                                        )
                                                    ),
                                                    Expanded(
                                                        child: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                if(MediaQuery.of(context).size.width < 400)
                                                                  Expanded(
                                                                      child: Container(
                                                                        padding: EdgeInsets.only(top: 15),
                                                                        alignment: Alignment.center,
                                                                        child: AutoSizeText(
                                                                            "Overall Rating",
                                                                            maxLines: 1,
                                                                            minFontSize: 12,
                                                                            presetFontSizes: [20, 18, 14],
                                                                            overflow: TextOverflow.ellipsis,
                                                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900],)
                                                                        ),
                                                                      )
                                                                  ),
                                                                if(MediaQuery.of(context).size.width > 400)
                                                                  Container(
                                                                    padding: EdgeInsets.only(top: 15),
                                                                    alignment: Alignment.center,
                                                                    child: AutoSizeText(
                                                                        "Overall Rating",
                                                                        maxLines: 1,
                                                                        minFontSize: 12,
                                                                        presetFontSizes: [20, 18, 14],
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900],)
                                                                    ),
                                                                  ),

                                                                Container(
                                                                    alignment: Alignment.topLeft,
                                                                    padding: EdgeInsets.only(top: 15),
                                                                    height: 30,
                                                                    width: 25,
                                                                    child: IconButton(
                                                                      alignment: Alignment.center,
                                                                      splashRadius: 10,
                                                                      splashColor: Colors.blueAccent,
                                                                      hoverColor: Colors.blueAccent,
                                                                      iconSize: 15,
                                                                      padding: EdgeInsets.all(1),
                                                                      icon: Icon(Icons.info_rounded),
                                                                      color: Colors.blue[400],
                                                                      onPressed: (){
                                                                        showDialog(
                                                                          context: context,
                                                                          builder: (context){
                                                                            return Dialog(
                                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                                                                elevation: 16,
                                                                                child: Container(
                                                                                  height: 500,
                                                                                  decoration: BoxDecoration(  //decorate popup
                                                                                      color: widget.isDarkModeEnabled ?Colors.grey: Colors.white,
                                                                                      boxShadow: [
                                                                                        BoxShadow(
                                                                                          color: Colors.grey.withOpacity(0.5),
                                                                                          spreadRadius: 2,
                                                                                          blurRadius: 7,
                                                                                          offset: Offset(2,3),
                                                                                        ),
                                                                                      ]
                                                                                  ),
                                                                                  //display pop-up description to overall rating
                                                                                  child: GlowingOverscrollIndicator(
                                                                                      axisDirection: AxisDirection.down,
                                                                                      color:  Colors.deepPurple,
                                                                                      child:  ListView(
                                                                                        padding: EdgeInsets.all(10),
                                                                                        shrinkWrap: true,
                                                                                        children: [
                                                                                          Padding(
                                                                                            padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0),
                                                                                            child: Text("How is the Overall Rating calculated?",
                                                                                                style: TextStyle(fontSize: 18, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                                                textAlign: TextAlign.left
                                                                                            ),
                                                                                          ),
                                                                                          Padding(
                                                                                            padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0),
                                                                                            child:  Text("The 'Overall Rating' is calculated out of one hundred. "
                                                                                                "When the ingredient list is filtered through the algorithm, "
                                                                                                "it reads the rating of each ingredient and either adds or "
                                                                                                "subtracts point. If a ingredient is green or blue then the "
                                                                                                "algorithm adds points, if a ingredient is yellow "
                                                                                                "then the algorithm adds half-points and if the ingredient "
                                                                                                "is red then no points are added. Additional points are either "
                                                                                                "added or subtracted depending on the first 5 ingredients. If the "
                                                                                                "first five ingredients are all green/blue than a +5 bonus point is added "
                                                                                                "added, if there contains a yellow then -3 bonus point is subtracted, "
                                                                                                "and if there contains a red a -5 bonus point is subtracted. Finally, "
                                                                                                "the overall ingredient rating is compared to a grading scale.",
                                                                                                style: TextStyle(fontSize: 15, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                                                textAlign: TextAlign.left
                                                                                            ),
                                                                                          ),
                                                                                          Padding(
                                                                                              padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0, top: 10.0),
                                                                                              child:
                                                                                              Container(
                                                                                                child: Text("Each individual ingredient rating is calculated with consideration to AAFCO and "
                                                                                                    "AllAboutDogFood.co.uk",
                                                                                                    style: TextStyle(fontSize: 15,color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                                                    textAlign: TextAlign.left
                                                                                                ),
                                                                                                color: widget.isDarkModeEnabled ?Colors.grey[600]: Colors.grey[100],
                                                                                                padding: EdgeInsets.all(8),
                                                                                              )
                                                                                          ),
                                                                                          Padding(
                                                                                            padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0, top:10.0),
                                                                                            child: Text("Grading Scale",
                                                                                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                                                textAlign: TextAlign.left),

                                                                                          ),
                                                                                          Padding(
                                                                                            padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0),
                                                                                            child:  Text("A+: Above 97% (Excellent)",
                                                                                                style: TextStyle(
                                                                                                    fontSize: 15, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                                                textAlign: TextAlign.left),

                                                                                          ),
                                                                                          Padding(
                                                                                            padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0),
                                                                                            child:
                                                                                            Text("A: 93-96% (Excellent)",
                                                                                                style: TextStyle(
                                                                                                    fontSize: 15, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                                                textAlign: TextAlign.left),


                                                                                          ),
                                                                                          Padding(
                                                                                            padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0),
                                                                                            child: Text("A-: 90-92% (Excellent)",
                                                                                                style: TextStyle(fontSize: 15, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                                                textAlign: TextAlign.left),

                                                                                          ),
                                                                                          Padding(
                                                                                            padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0),
                                                                                            child: Text("B+: 87-89% (Good)",
                                                                                                style: TextStyle(fontSize: 15, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                                                textAlign: TextAlign.left),

                                                                                          ),
                                                                                          Padding(
                                                                                            padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0),
                                                                                            child:  Text("B: 83-86% (Good)",
                                                                                                style: TextStyle(fontSize: 15, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                                                textAlign: TextAlign.left),

                                                                                          ),
                                                                                          Padding(
                                                                                            padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0),
                                                                                            child:Text("B-: 80-82% (Good)",
                                                                                                style: TextStyle(fontSize: 15, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                                                textAlign: TextAlign.left),

                                                                                          ),
                                                                                          Padding(
                                                                                            padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0),
                                                                                            child:Text("C+: 77-79% (Fair)",
                                                                                                style: TextStyle(fontSize: 15, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                                                textAlign: TextAlign.left),

                                                                                          ),
                                                                                          Padding(
                                                                                            padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0),
                                                                                            child:
                                                                                            Text("C: 73-76% (Fair)",
                                                                                                style: TextStyle(fontSize: 15, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                                                textAlign: TextAlign.left),

                                                                                          ),
                                                                                          Padding(
                                                                                            padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0),
                                                                                            child:Text("C-: 70-72% (Fair)",
                                                                                                style: TextStyle(fontSize: 15, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                                                textAlign: TextAlign.left),

                                                                                          ),
                                                                                          Padding(
                                                                                            padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0),
                                                                                            child:Text("D+: 67-69% (Poor)",
                                                                                                style: TextStyle(fontSize: 15, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                                                textAlign: TextAlign.left),

                                                                                          ),
                                                                                          Padding(
                                                                                            padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0),
                                                                                            child:Text("D: 63-66% (Poor)",
                                                                                                style: TextStyle(fontSize: 15, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                                                textAlign: TextAlign.left),

                                                                                          ),
                                                                                          Padding(
                                                                                            padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0),
                                                                                            child:  Text("D-: 60-62% (Poor)",
                                                                                                style: TextStyle(fontSize: 15, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                                                textAlign: TextAlign.left),

                                                                                          ),
                                                                                          Padding(
                                                                                            padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0),
                                                                                            child:    Text("F: Below 60% (Terrible)",
                                                                                                style: TextStyle(fontSize: 15, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                                                textAlign: TextAlign.left),
                                                                                          ),
                                                                                        ],
                                                                                      )
                                                                                  ),
                                                                                )
                                                                            );
                                                                          },
                                                                        );
                                                                        setState((){});
                                                                      },
                                                                    )
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(
                                                                padding: EdgeInsets.only(top: 10, bottom: 0),
                                                                child: InkWell(
                                                                  child:Container(
                                                                    alignment: Alignment.bottomCenter,
                                                                    constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5, maxWidth: MediaQuery.of(context).size.width/2.5),
                                                                    width: MediaQuery.of(context).size.width,
                                                                    height: MediaQuery.of(context).size.height * 0.3,
                                                                    decoration: BoxDecoration(
                                                                        color: widget.gradeColor,
                                                                        shape: BoxShape.circle,
                                                                        boxShadow:[
                                                                          BoxShadow(
                                                                            color: widget.isDarkModeEnabled ?Color(0xFF253341).withOpacity(0.5):Color(0xFFBDBDBD).withOpacity(0.5),
                                                                            spreadRadius: 3,
                                                                            blurRadius: 7,
                                                                            offset: Offset(0, 3), // changes position of shadow
                                                                          ),
                                                                        ]
                                                                    ),
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        Center(
                                                                          child: AutoSizeText(
                                                                            "${widget.grade.keys.elementAt(0)}",
                                                                            maxLines: 1,
                                                                            minFontSize: 12,
                                                                            presetFontSizes: [18, 15, 14],
                                                                            overflow: TextOverflow.ellipsis,
                                                                            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold,),
                                                                            textAlign: TextAlign.center,
                                                                          ),
                                                                        ),
                                                                        Center(
                                                                          child: AutoSizeText(
                                                                            "${widget.grade.values.elementAt(0).toStringAsFixed(1)}%",
                                                                            maxLines: 1,
                                                                            minFontSize: 12,
                                                                            presetFontSizes: [18, 15, 14],
                                                                            overflow: TextOverflow.ellipsis,
                                                                            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                                                                            textAlign: TextAlign.center,
                                                                          ),
                                                                        ),

                                                                      ],
                                                                    ),
                                                                  ),
                                                                  onTap: (){
                                                                    overallRatingPopUp(); //display popup
                                                                  },
                                                                )
                                                            ),
                                                          ],
                                                        )
                                                    ),
                                                  ],
                                                )
                                            )
                                        )
                                    ],
                                  )
                              )
                          ),

                        //if in portrait mode display following
                        if( MediaQuery.of(context).orientation == Orientation.portrait)
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //display pug image
                                    if(widget.imageUrl != null)
                                      Expanded(
                                          child: Container(
                                              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.3, maxWidth: MediaQuery.of(context).size.width),
                                              alignment: Alignment.center,
                                              child:
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(context).size.width / 2,
                                                        height: MediaQuery.of(context).size.height,
                                                        child: Padding(
                                                          padding: EdgeInsets.all(10),
                                                          child:  Image.network(
                                                            widget.imageUrl,
                                                          ),
                                                        )
                                                      ),
                                                      Expanded(
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: [
                                                                  if(MediaQuery.of(context).size.width < 400)
                                                                    Expanded(
                                                                        child: Container(
                                                                          padding: EdgeInsets.only(top: 15),
                                                                          alignment: Alignment.center,
                                                                          child: AutoSizeText(
                                                                              "Overall Rating",
                                                                              maxLines: 1,
                                                                              minFontSize: 12,
                                                                              presetFontSizes: [20, 18, 14],
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900],)
                                                                          ),
                                                                        )
                                                                    ),
                                                                  if(MediaQuery.of(context).size.width > 400)
                                                                    Container(
                                                                      padding: EdgeInsets.only(top: 15),
                                                                      alignment: Alignment.center,
                                                                      child: AutoSizeText(
                                                                          "Overall Rating",
                                                                          maxLines: 1,
                                                                          minFontSize: 12,
                                                                          presetFontSizes: [20, 18, 14],
                                                                          overflow: TextOverflow.ellipsis,
                                                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900],)
                                                                      ),
                                                                    ),

                                                                  Container(
                                                                      alignment: Alignment.topLeft,
                                                                      padding: EdgeInsets.only(top: 15),
                                                                      height: 30,
                                                                      width: 25,
                                                                      child: IconButton(
                                                                        alignment: Alignment.center,
                                                                        splashRadius: 10,
                                                                        splashColor: Colors.blueAccent,
                                                                        hoverColor: Colors.blueAccent,
                                                                        iconSize: 15,
                                                                        padding: EdgeInsets.all(1),
                                                                        icon: Icon(Icons.info_rounded),
                                                                        color: Colors.blue[400],
                                                                        onPressed: (){
                                                                          showDialog(
                                                                            context: context,
                                                                            builder: (context){
                                                                              return Dialog(
                                                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                                                                  elevation: 16,
                                                                                  child: Container(
                                                                                    height: 500,
                                                                                    decoration: BoxDecoration(  //decorate popup
                                                                                        color: widget.isDarkModeEnabled ?Colors.grey: Colors.white,
                                                                                        boxShadow: [
                                                                                          BoxShadow(
                                                                                            color: Colors.grey.withOpacity(0.5),
                                                                                            spreadRadius: 2,
                                                                                            blurRadius: 7,
                                                                                            offset: Offset(2,3),
                                                                                          ),
                                                                                        ]
                                                                                    ),
                                                                                    //display pop-up description to overall rating
                                                                                    child: GlowingOverscrollIndicator(
                                                                                        axisDirection: AxisDirection.down,
                                                                                        color:  Colors.deepPurple,
                                                                                        child:  ListView(
                                                                                          padding: EdgeInsets.all(10),
                                                                                          shrinkWrap: true,
                                                                                          children: [
                                                                                            Padding(
                                                                                              padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0),
                                                                                              child: Text("How is the Overall Rating calculated?",
                                                                                                  style: TextStyle(fontSize: 18, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                                                  textAlign: TextAlign.left
                                                                                              ),
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0),
                                                                                              child:  Text("The 'Overall Rating' is calculated out of one hundred. "
                                                                                                  "When the ingredient list is filtered through the algorithm, "
                                                                                                  "it reads the rating of each ingredient and either adds or "
                                                                                                  "subtracts point. If a ingredient is green or blue then the "
                                                                                                  "algorithm adds points, if a ingredient is yellow "
                                                                                                  "then the algorithm adds half-points and if the ingredient "
                                                                                                  "is red then no points are added. Additional points are either "
                                                                                                  "added or subtracted depending on the first 5 ingredients. If the "
                                                                                                  "first five ingredients are all green/blue than a +5 bonus point is added "
                                                                                                  "added, if there contains a yellow then -3 bonus point is subtracted, "
                                                                                                  "and if there contains a red a -5 bonus point is subtracted. Finally, "
                                                                                                  "the overall ingredient rating is compared to a grading scale.",
                                                                                                  style: TextStyle(fontSize: 15, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                                                  textAlign: TextAlign.left
                                                                                              ),
                                                                                            ),
                                                                                            Padding(
                                                                                                padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0, top: 10.0),
                                                                                                child:
                                                                                                Container(
                                                                                                  child: Text("Each individual ingredient rating is calculated with consideration to AAFCO and "
                                                                                                      "AllAboutDogFood.co.uk",
                                                                                                      style: TextStyle(fontSize: 15,color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                                                      textAlign: TextAlign.left
                                                                                                  ),
                                                                                                  color: widget.isDarkModeEnabled ?Colors.grey[600]: Colors.grey[100],
                                                                                                  padding: EdgeInsets.all(8),
                                                                                                )
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0, top:10.0),
                                                                                              child: Text("Grading Scale",
                                                                                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                                                  textAlign: TextAlign.left),

                                                                                            ),
                                                                                            Padding(
                                                                                              padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0),
                                                                                              child:  Text("A+: Above 97% (Excellent)",
                                                                                                  style: TextStyle(
                                                                                                      fontSize: 15, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                                                  textAlign: TextAlign.left),

                                                                                            ),
                                                                                            Padding(
                                                                                              padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0),
                                                                                              child:
                                                                                              Text("A: 93-96% (Excellent)",
                                                                                                  style: TextStyle(
                                                                                                      fontSize: 15, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                                                  textAlign: TextAlign.left),


                                                                                            ),
                                                                                            Padding(
                                                                                              padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0),
                                                                                              child: Text("A-: 90-92% (Excellent)",
                                                                                                  style: TextStyle(fontSize: 15, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                                                  textAlign: TextAlign.left),

                                                                                            ),
                                                                                            Padding(
                                                                                              padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0),
                                                                                              child: Text("B+: 87-89% (Good)",
                                                                                                  style: TextStyle(fontSize: 15, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                                                  textAlign: TextAlign.left),

                                                                                            ),
                                                                                            Padding(
                                                                                              padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0),
                                                                                              child:  Text("B: 83-86% (Good)",
                                                                                                  style: TextStyle(fontSize: 15, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                                                  textAlign: TextAlign.left),

                                                                                            ),
                                                                                            Padding(
                                                                                              padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0),
                                                                                              child:Text("B-: 80-82% (Good)",
                                                                                                  style: TextStyle(fontSize: 15, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                                                  textAlign: TextAlign.left),

                                                                                            ),
                                                                                            Padding(
                                                                                              padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0),
                                                                                              child:Text("C+: 77-79% (Fair)",
                                                                                                  style: TextStyle(fontSize: 15, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                                                  textAlign: TextAlign.left),

                                                                                            ),
                                                                                            Padding(
                                                                                              padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0),
                                                                                              child:
                                                                                              Text("C: 73-76% (Fair)",
                                                                                                  style: TextStyle(fontSize: 15, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                                                  textAlign: TextAlign.left),

                                                                                            ),
                                                                                            Padding(
                                                                                              padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0),
                                                                                              child:Text("C-: 70-72% (Fair)",
                                                                                                  style: TextStyle(fontSize: 15, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                                                  textAlign: TextAlign.left),

                                                                                            ),
                                                                                            Padding(
                                                                                              padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0),
                                                                                              child:Text("D+: 67-69% (Poor)",
                                                                                                  style: TextStyle(fontSize: 15, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                                                  textAlign: TextAlign.left),

                                                                                            ),
                                                                                            Padding(
                                                                                              padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0),
                                                                                              child:Text("D: 63-66% (Poor)",
                                                                                                  style: TextStyle(fontSize: 15, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                                                  textAlign: TextAlign.left),

                                                                                            ),
                                                                                            Padding(
                                                                                              padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0),
                                                                                              child:  Text("D-: 60-62% (Poor)",
                                                                                                  style: TextStyle(fontSize: 15, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                                                  textAlign: TextAlign.left),

                                                                                            ),
                                                                                            Padding(
                                                                                              padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0),
                                                                                              child:    Text("F: Below 60% (Terrible)",
                                                                                                  style: TextStyle(fontSize: 15, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                                                  textAlign: TextAlign.left),
                                                                                            ),
                                                                                          ],
                                                                                        )
                                                                                    ),
                                                                                  )
                                                                              );
                                                                            },
                                                                          );
                                                                          setState((){});
                                                                        },
                                                                      )
                                                                  ),
                                                                ],
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets.only(top: 10, bottom: 0),
                                                                child: InkWell(
                                                                  child:Container(
                                                                    alignment: Alignment.bottomCenter,
                                                                    constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5, maxWidth: MediaQuery.of(context).size.width/2.5),
                                                                    width: MediaQuery.of(context).size.width,
                                                                    height: MediaQuery.of(context).size.height * 0.15,
                                                                    decoration: BoxDecoration(
                                                                        color: widget.gradeColor,
                                                                        shape: BoxShape.circle,
                                                                        boxShadow:[
                                                                          BoxShadow(
                                                                            color: widget.isDarkModeEnabled ?Color(0xFF253341).withOpacity(0.5):Color(0xFFBDBDBD).withOpacity(0.5),
                                                                            spreadRadius: 3,
                                                                            blurRadius: 7,
                                                                            offset: Offset(0, 3), // changes position of shadow
                                                                          ),
                                                                        ]
                                                                    ),
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        Center(
                                                                          child: AutoSizeText(
                                                                            "${widget.grade.keys.elementAt(0)}",
                                                                            maxLines: 1,
                                                                            minFontSize: 12,
                                                                            presetFontSizes: [18, 15, 14],
                                                                            overflow: TextOverflow.ellipsis,
                                                                            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold,),
                                                                            textAlign: TextAlign.center,
                                                                          ),
                                                                        ),
                                                                        Center(
                                                                          child: AutoSizeText(
                                                                            "${widget.grade.values.elementAt(0).toStringAsFixed(1)}%",
                                                                            maxLines: 1,
                                                                            minFontSize: 12,
                                                                            presetFontSizes: [18, 15, 14],
                                                                            overflow: TextOverflow.ellipsis,
                                                                            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                                                                            textAlign: TextAlign.center,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  onTap: (){
                                                                    overallRatingPopUp(); //display popup
                                                                  },
                                                                )
                                                              ),
                                                            ],
                                                          )
                                                      ),
                                                    ],
                                                  )

                                          )
                                      )
                                  ],
                                )
                            )

                        ),

                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(left: 15, right: 15),
                            color: widget.isDarkModeEnabled ?Colors.blueGrey[900]: Colors.deepPurple[50],
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check_rounded,
                                  color: Colors.lightGreen,
                                ),
                                if(MediaQuery.of(context).size.width < 400)
                                  AutoSizeText(
                                    "${widget.numOfgreenIngred} Healthy",
                                    maxLines: 1,
                                    minFontSize: 12,
                                    overflow: TextOverflow.ellipsis,
                                    group: myGroup1,
                                    style: TextStyle(color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900], fontSize: 12, fontWeight: FontWeight.w500),
                                  ),
                                if(MediaQuery.of(context).size.width > 400)
                                  AutoSizeText(
                                    "${widget.numOfgreenIngred} Healthy",
                                    maxLines: 1,
                                    minFontSize: 12,
                                    presetFontSizes: [15, 14, 12],
                                    overflow: TextOverflow.ellipsis,
                                    group: myGroup1,
                                    style: TextStyle(color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900], fontSize: 15, fontWeight: FontWeight.w500),
                                  ),

                                Icon(
                                  Icons.report_problem_rounded,
                                  color: Colors.amber,
                                ),
                                AutoSizeText(
                                  "${widget.numOfyellowIngred} Caution",
                                  maxLines: 1,
                                  minFontSize: 12,
                                  presetFontSizes: [15, 14, 12],
                                  overflow: TextOverflow.ellipsis,
                                  group: myGroup1,
                                  style: TextStyle(color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900], fontSize: 15,fontWeight: FontWeight.w500),
                                ),

                                Icon(
                                  Icons.close_rounded,
                                  color: Colors.red,
                                ),
                                AutoSizeText(
                                  "${widget.numOfredIngred} Avoid",
                                  maxLines: 1,
                                  minFontSize: 12,
                                  presetFontSizes: [15, 14, 12],
                                  overflow: TextOverflow.ellipsis,
                                  group: myGroup1,
                                  style: TextStyle(color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900], fontSize: 15, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        Row(
                          children: [
                            Padding(
                              padding:  EdgeInsets.only(left: 10, top: 10),
                              child: ButtonTheme(
                                child: TextButton.icon(
                                  label: AutoSizeText(
                                      "Analysis",
                                      maxLines: 1,
                                      minFontSize: 12,
                                      presetFontSizes: [15, 14, 12],
                                      overflow: TextOverflow.ellipsis,
                                      group: myGroup2,
                                      style: TextStyle(color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900], fontSize: 15, fontWeight: FontWeight.bold)),
                                  onPressed: (){
                                    setState((){
                                      pressed1 = !pressed1;
                                      _isVisible = false;
                                      _isVisible3 = false;
                                    });
                                    //Analysis btn is pressed so un-press Ingredient btn and search btn
                                    pressed2 = true;
                                    pressed3 = true;
                                    showPieChart();
                                  },
                                  style: pressed1 //Analysis btn decoration on press
                                      ?TextButton.styleFrom(
                                    shape: BeveledRectangleBorder(),

                                  ): TextButton.styleFrom(
                                    shape: BeveledRectangleBorder(),
                                    backgroundColor: widget.isDarkModeEnabled ?Colors.grey[800]: Colors.deepPurple[100],
                                  ),

                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: pressed1 ?Colors.grey: Color(0xFF212121),
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child:  ButtonTheme(
                                child: TextButton.icon(
                                  label: AutoSizeText(
                                      "Ingredient List",
                                      maxLines: 1,
                                      minFontSize: 12,
                                      presetFontSizes: [15, 14, 12],
                                      overflow: TextOverflow.ellipsis,
                                      group: myGroup2,
                                      style:
                                      TextStyle(color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900], fontSize: 15, fontWeight: FontWeight.bold)),
                                  onPressed: (){
                                    setState((){
                                      pressed2 = !pressed2;
                                      _isVisible2 = false;
                                      _isVisible3 = false;
                                    });
                                    //Ingredient btn is pressed so un-press Analysis btn and search btn
                                    pressed1 = true;
                                    pressed3 = true;
                                    showIngredients(); //Controls visibility
                                  },
                                  style: pressed2 //Ingredients btn decoration on press
                                      ?TextButton.styleFrom(
                                    shape: BeveledRectangleBorder(),

                                  ): TextButton.styleFrom(
                                    shape: BeveledRectangleBorder(),
                                    primary: Colors.blueGrey[900],
                                    backgroundColor: widget.isDarkModeEnabled ?Colors.grey[800]: Colors.deepPurple[100],
                                  ),
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: pressed2 ?Colors.grey: Color(0xFF212121),
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding:  EdgeInsets.only(top: 10),
                              child: ButtonTheme(
                                child: TextButton.icon(
                                  label: AutoSizeText(
                                      "Search",
                                      maxLines: 1,
                                      minFontSize: 12,
                                      presetFontSizes: [15, 14, 12],
                                      overflow: TextOverflow.ellipsis,
                                      group: myGroup3,
                                      style: TextStyle(color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900], fontSize: 15, fontWeight: FontWeight.bold)),
                                  onPressed: (){
                                    setState((){
                                      pressed3 = !pressed3;
                                      _isVisible3 = false;
                                      _isVisible = false;
                                      _isVisible2 = false;
                                    });
                                    //Search btn is pressed so un-press Ingredient btn and Analysis btn
                                    pressed1 = true;
                                    pressed2 = true;
                                    showDatabase();


                                  },
                                  style: pressed3 //Search btn decoration on press
                                      ?TextButton.styleFrom(
                                    shape: BeveledRectangleBorder(),

                                  ): TextButton.styleFrom(
                                    shape: BeveledRectangleBorder(),
                                    backgroundColor: widget.isDarkModeEnabled ?Colors.grey[800]: Colors.deepPurple[100],
                                  ),

                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: pressed3 ?Colors.grey: Color(0xFF212121),
                                  ),
                                ),
                              ),
                            ),


                          ],
                        ),

                        Stack(  //shows analysis btn info or ingredients btn info
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child:
                              Visibility(
                                visible: _isVisible2,
                                child: SingleChildScrollView(
                                    padding: EdgeInsets.all(8.0),
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(top: 5, bottom: 10),
                                              child: AutoSizeText(
                                                  "Ingredient List Categories",
                                                  maxLines: 1,
                                                  minFontSize: 12,
                                                  presetFontSizes: [18, 15, 14],
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900], fontSize: 18)
                                              ),
                                            ),
                                            SizedBox(
                                              height: 30,
                                              width: 25,
                                              child: IconButton(
                                                splashRadius: 10,
                                                splashColor: Colors.blueAccent,
                                                hoverColor: Colors.blueAccent,
                                                iconSize: 15,
                                                padding: EdgeInsets.all(1),
                                                icon: Icon(Icons.info_rounded),
                                                color: Colors.blue[400],
                                                onPressed: (){
                                                  showDialog(
                                                    context: context,
                                                    builder: (context){
                                                      return Dialog(
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                                          elevation: 16,
                                                          child: Container(
                                                            height: 500,
                                                            decoration: BoxDecoration(  //decorate popup
                                                                color: widget.isDarkModeEnabled ?Colors.grey: Colors.white,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors.grey.withOpacity(0.5),
                                                                    spreadRadius: 2,
                                                                    blurRadius: 7,
                                                                    offset: Offset(2,3),
                                                                  ),
                                                                ]
                                                            ),
                                                            child: GlowingOverscrollIndicator(
                                                              axisDirection: AxisDirection.down,
                                                              color:  Colors.deepPurple,
                                                              child: ListView(
                                                                padding: EdgeInsets.all(10),
                                                                shrinkWrap: true,
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0),
                                                                    child: AutoSizeText(
                                                                        "What is the Ingredient List Categories?",
                                                                        style: TextStyle(fontSize: 18, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                        textAlign: TextAlign.left
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0),
                                                                    child: AutoSizeText("The 'Ingredient List Categories' displays segments that each "
                                                                        "represents a percentage of ingredients found in a given category. Each "
                                                                        "segment represents a particular category, which is explained below.",
                                                                        style: TextStyle(fontSize: 15, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                        textAlign: TextAlign.left
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                      padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0, top: 10.0),
                                                                      child:
                                                                      Container(
                                                                        child:  RichText(
                                                                            text: TextSpan(
                                                                              children:[
                                                                                WidgetSpan(
                                                                                    child: Padding(
                                                                                        padding: EdgeInsets.only(right: 3),
                                                                                        child: Icon(
                                                                                          Icons.circle_rounded,
                                                                                          color: Color(0xFFFF5252),
                                                                                          size: 15,
                                                                                        )
                                                                                    )
                                                                                ),
                                                                                TextSpan(
                                                                                  text: "Meats - includes all meat ingredients and animal by-products except fish ingredients",
                                                                                  style: TextStyle(fontSize: 15, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                                )
                                                                              ],
                                                                            )
                                                                        ),
                                                                        color: widget.isDarkModeEnabled ?Colors.grey[600]: Colors.grey[100],
                                                                        padding: EdgeInsets.all(8),
                                                                      )
                                                                  ),
                                                                  Padding(
                                                                      padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0, top: 10.0),
                                                                      child: Container(
                                                                        child: RichText(
                                                                            text: TextSpan(
                                                                              children:[
                                                                                WidgetSpan(
                                                                                    child: Padding(
                                                                                        padding: EdgeInsets.only(right: 3),
                                                                                        child: Icon(
                                                                                          Icons.circle_rounded,
                                                                                          color: Color(0xFF80D8FF),
                                                                                          size: 15,
                                                                                        )
                                                                                    )
                                                                                ),
                                                                                TextSpan(
                                                                                  text: "Supplements - includes vitamins, minerals, and probiotics",
                                                                                  style: TextStyle(fontSize: 15, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                                )
                                                                              ],
                                                                            )
                                                                        ),
                                                                        color: widget.isDarkModeEnabled ?Colors.grey[600]: Colors.grey[100],
                                                                        padding: EdgeInsets.all(8),
                                                                      )
                                                                  ),
                                                                  Padding(
                                                                      padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0, top: 10.0),
                                                                      child: Container(
                                                                        child:  RichText(
                                                                            text: TextSpan(
                                                                              children:[
                                                                                WidgetSpan(
                                                                                    child: Padding(
                                                                                        padding: EdgeInsets.only(right: 3),
                                                                                        child: Icon(
                                                                                          Icons.circle_rounded,
                                                                                          color: Color(0xFF69F0AE),
                                                                                          size: 15,
                                                                                        )
                                                                                    )
                                                                                ),
                                                                                TextSpan(
                                                                                  text: "Other - all other ingredients that do not fall under any ingredient category. "
                                                                                      "Mostly includes compounds of an ingredient or chemical forms",
                                                                                  style: TextStyle(fontSize: 15, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                                )
                                                                              ],
                                                                            )
                                                                        ),
                                                                        color: widget.isDarkModeEnabled ?Colors.grey[600]: Colors.grey[100],
                                                                        padding: EdgeInsets.all(8),
                                                                      )
                                                                  ),
                                                                  Padding(
                                                                      padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0, top: 10.0),
                                                                      child:  Container(
                                                                        child:  RichText(
                                                                            text: TextSpan(
                                                                              children:[
                                                                                WidgetSpan(
                                                                                    child: Padding(
                                                                                        padding: EdgeInsets.only(right: 3),
                                                                                        child: Icon(
                                                                                          Icons.circle_rounded,
                                                                                          color: Color(0xFFFFFF00),
                                                                                          size: 15,
                                                                                        )
                                                                                    )
                                                                                ),
                                                                                TextSpan(
                                                                                  text: "Fish & Shellfish - includes all fish ingredients and fish by-products",
                                                                                  style: TextStyle(fontSize: 15, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                                )
                                                                              ],
                                                                            )
                                                                        ),
                                                                        color: widget.isDarkModeEnabled ?Colors.grey[600]: Colors.grey[100],
                                                                        padding: EdgeInsets.all(8),
                                                                      )
                                                                  ),
                                                                  Padding(
                                                                      padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0, top: 10.0),
                                                                      child: Container(
                                                                        child:  RichText(
                                                                            text: TextSpan(
                                                                              children:[
                                                                                WidgetSpan(
                                                                                    child: Padding(
                                                                                        padding: EdgeInsets.only(right: 3),
                                                                                        child: Icon(
                                                                                          Icons.circle_rounded,
                                                                                          color: Color(0xFFB388FF),
                                                                                          size: 15,
                                                                                        )
                                                                                    )
                                                                                ),
                                                                                TextSpan(
                                                                                  text: "Grains - includes wheat, corn, rice, barely or any other cereal grain",
                                                                                  style: TextStyle(fontSize: 15, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                                )
                                                                              ],
                                                                            )
                                                                        ),
                                                                        color: widget.isDarkModeEnabled ?Colors.grey[600]: Colors.grey[100],
                                                                        padding: EdgeInsets.all(8),
                                                                      )
                                                                  ),
                                                                  Padding(
                                                                      padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0, top: 10.0),
                                                                      child: Container(
                                                                        child: RichText(
                                                                            text: TextSpan(
                                                                              children:[
                                                                                WidgetSpan(
                                                                                    child: Padding(
                                                                                        padding: EdgeInsets.only(right: 3),
                                                                                        child: Icon(
                                                                                          Icons.circle_rounded,
                                                                                          color: Color(0xFFFF80AB),
                                                                                          size: 15,
                                                                                        )
                                                                                    )
                                                                                ),
                                                                                TextSpan(
                                                                                  text: "Vegetables - includes all whole vegetables and vegetable oils, "
                                                                                      " excluding seed oils",
                                                                                  style: TextStyle(fontSize: 15, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                                )
                                                                              ],
                                                                            )
                                                                        ),
                                                                        color: widget.isDarkModeEnabled ?Colors.grey[600]: Colors.grey[100],
                                                                        padding: EdgeInsets.all(8),
                                                                      )
                                                                  ),
                                                                  Padding(
                                                                      padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0, top: 10.0),
                                                                      child: Container(
                                                                        child: RichText(
                                                                            text: TextSpan(
                                                                              children:[
                                                                                WidgetSpan(
                                                                                    child: Padding(
                                                                                        padding: EdgeInsets.only(right: 3),
                                                                                        child: Icon(
                                                                                          Icons.circle_rounded,
                                                                                          color: Color(0xFFFFAB40),
                                                                                          size: 15,
                                                                                        )
                                                                                    )
                                                                                ),
                                                                                TextSpan(
                                                                                  text: "Fruits, Beans, & Seeds - includes all whole fruits, legumes, and oil seeds",
                                                                                  style: TextStyle(fontSize: 15, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                                )
                                                                              ],
                                                                            )
                                                                        ),
                                                                        color: widget.isDarkModeEnabled ?Colors.grey[600]: Colors.grey[100],
                                                                        padding: EdgeInsets.all(8),
                                                                      )
                                                                  ),
                                                                  Padding(
                                                                      padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0, top: 10.0),
                                                                      child: Container(
                                                                        child: RichText(
                                                                            text: TextSpan(
                                                                              children:[
                                                                                WidgetSpan(
                                                                                    child: Padding(
                                                                                        padding: EdgeInsets.only(right: 3),
                                                                                        child: Icon(
                                                                                          Icons.circle_rounded,
                                                                                          color: Color(0xFFB2FF59),
                                                                                          size: 15,
                                                                                        )
                                                                                    )
                                                                                ),
                                                                                TextSpan(
                                                                                  text: "Herbs - includes any plants with leaves, seeds, or flowers used for "
                                                                                      "their flavour, aroma, nutritional constituents or medicinal properties ",
                                                                                  style: TextStyle(fontSize: 15, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                                )
                                                                              ],
                                                                            )
                                                                        ),
                                                                        color: widget.isDarkModeEnabled ?Colors.grey[600]: Colors.grey[100],
                                                                        padding: EdgeInsets.all(8),
                                                                      )
                                                                  ),
                                                                  Padding(
                                                                      padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0, top: 10.0),
                                                                      child: Container(
                                                                        child: RichText(
                                                                            text: TextSpan(
                                                                              children:[
                                                                                WidgetSpan(
                                                                                    child: Padding(
                                                                                        padding: EdgeInsets.only(right: 3),
                                                                                        child: Icon(
                                                                                          Icons.circle_rounded,
                                                                                          color: Color(0xFF536DFE),
                                                                                          size: 15,
                                                                                        )
                                                                                    )
                                                                                ),
                                                                                TextSpan(
                                                                                  text: "Additives - includes preservatives, added colouring, and added flavours",
                                                                                  style: TextStyle(fontSize: 15, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                                )
                                                                              ],
                                                                            )
                                                                        ),
                                                                        color: widget.isDarkModeEnabled ?Colors.grey[600]: Colors.grey[100],
                                                                        padding: EdgeInsets.all(8),
                                                                      )
                                                                  ),
                                                                ],
                                                              ),
                                                            ),

                                                          )
                                                      );
                                                    },
                                                  );
                                                  setState((){});
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                        Padding(padding: EdgeInsets.only(top: 15),
                                          child: PieChart(
                                            chartType: ChartType.ring,
                                            chartLegendSpacing: 32,
                                            colorList: [
                                              Color(0xFFFF5252),
                                              Color(0xFF80D8FF),
                                              Color(0xFF69F0AE),
                                              Color(0xFFFFFF00),
                                              Color(0xFFB388FF),
                                              Color(0xFFFF80AB),
                                              Color(0xFFFFAB40),
                                              Color(0xFFB2FF59),
                                              Color(0xFF536DFE),
                                            ],
                                            ringStrokeWidth: 20,
                                            chartRadius:  MediaQuery.of(context).size.width * 0.6,  //determines the size of the chart
                                            legendOptions: LegendOptions(
                                              showLegendsInRow: false,
                                              legendPosition: LegendPosition.bottom,
                                              showLegends: true,
                                              legendTextStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  overflow: TextOverflow.ellipsis,
                                                  color:  widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]
                                              ),
                                            ),
                                            chartValuesOptions: ChartValuesOptions(
                                              showChartValueBackground: true,
                                              showChartValues: true,
                                              showChartValuesInPercentage: true,
                                              showChartValuesOutside: false,
                                              decimalPlaces: 1,
                                            ),
                                            dataMap: widget.pieChartData,
                                          )
                                        )
                                      ],
                                    )
                                ),
                              ),
                            ),

                            Align(
                              alignment: Alignment.topCenter,
                              child: Visibility( //show and hide ingredients
                                  visible: _isVisible,
                                  child: SingleChildScrollView(
                                    padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 3, bottom: 3),
                                    scrollDirection: Axis.vertical,
                                    child: Column(  //dynamically display ingredients
                                        mainAxisSize: MainAxisSize.min,
                                        children:
                                        keys.map((String ingredient) => TextButton.icon(
                                          onPressed: (){  //popup show description, rating when ingredient is pressed
                                            showDialog(
                                                context: context,
                                                builder: (context){
                                                  return Dialog(
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                                    elevation: 16,
                                                    child: Container(
                                                      decoration: BoxDecoration(  //decorate popup
                                                          color: widget.isDarkModeEnabled ?Colors.grey[800]: Colors.white,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey.withOpacity(0.5),
                                                              spreadRadius: 2,
                                                              blurRadius: 7,
                                                              offset: Offset(2,3),
                                                            ),
                                                          ]
                                                      ),
                                                      child: GlowingOverscrollIndicator(
                                                        axisDirection: AxisDirection.down,
                                                        color:  Colors.deepPurple,
                                                        child: ListView(
                                                          padding: EdgeInsets.all(10),
                                                          shrinkWrap: true,
                                                          children: [
                                                            SizedBox(height: 20),
                                                            Center( //display ingredient name
                                                                child: AutoSizeText(
                                                                    ingredient,
                                                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]))
                                                            ),
                                                            Column( //display ingredient description
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                SizedBox(height: 12),
                                                                Container(height: 2),
                                                                Row(
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsets.only(left: 4.0),
                                                                      child:  Icon(
                                                                        Icons.lightbulb,
                                                                        color: Colors.amber,
                                                                      ),
                                                                    ),
                                                                    AutoSizeText(
                                                                        "Description",
                                                                        maxLines: 1,
                                                                        minFontSize: 12,
                                                                        presetFontSizes: [15, 14, 12],
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                        textAlign: TextAlign.left
                                                                    ),
                                                                  ],
                                                                ),
                                                                Padding(
                                                                    padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0),
                                                                    child: AutoSizeText(
                                                                      "${results[ingredient]?.elementAt(0)}",
                                                                      style: TextStyle(height: 1.5, fontSize: 15, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),

                                                                    )
                                                                ),
                                                                Row(  //display ingredient rating
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsets.only(left: 4.0),
                                                                      child: Icon(
                                                                        Icons.health_and_safety_rounded,
                                                                        color: btnColor[ingredient],
                                                                      ),
                                                                    ),
                                                                    displayRating(ingredient),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets.only(right: 10.0, bottom: 4.0),
                                                              child: Row( //display ingredient label
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets.only(left: 4.0),
                                                                    child:  Icon(
                                                                      Icons.label,
                                                                      color: Colors.purple[400],
                                                                    ),
                                                                  ),
                                                                  AutoSizeText(
                                                                    "${results[ingredient]?.elementAt(2)}",
                                                                    maxLines: 1,
                                                                    minFontSize: 12,
                                                                    presetFontSizes: [15, 14, 12],
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: TextStyle(height: 1.5, fontSize: 15, fontWeight: FontWeight.bold, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                  )
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),

                                                      ),
                                                    ),
                                                  );
                                                }
                                            );
                                          },
                                          style: ButtonStyle( //display ingredient btn color
                                            backgroundColor: MaterialStateProperty.all(btnColor[ingredient]),
                                            alignment: Alignment.center,
                                            elevation: MaterialStateProperty.all(3),
                                            shadowColor:MaterialStateProperty.all(Colors.grey), //Defines shadowColor
                                          ),
                                          label: Align( //display ingredient name button
                                              alignment: Alignment.topLeft,
                                              child: AutoSizeText(
                                                  ingredient,
                                                  maxLines: 1,
                                                  minFontSize: 12,
                                                  presetFontSizes: [15, 14, 12],
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)
                                              )
                                          ),
                                          icon: Icon(
                                              Icons.arrow_drop_down,
                                              color: Colors.black54
                                          ),
                                        )).toList()
                                    ),

                                  )
                              ),
                            ),

                            //FOR SEARCHHHH
                            Align(
                              alignment: Alignment.topCenter,
                              child:  Visibility(
                                  visible: _isVisible3,
                                  child: SingleChildScrollView(
                                    padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 3, bottom: 3),
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                        children: databaseKeys.map((String ingredient) => TextButton.icon(
                                          onPressed: (){  //popup show description, rating when ingredient is pressed
                                            showDialog(
                                                context: context,
                                                builder: (context){
                                                  return Dialog(
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                                    elevation: 16,
                                                    child: Container(
                                                      decoration: BoxDecoration(  //decorate popup
                                                          color: widget.isDarkModeEnabled ?Colors.grey[800]: Colors.white,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey.withOpacity(0.5),
                                                              spreadRadius: 2,
                                                              blurRadius: 7,
                                                              offset: Offset(2,3),
                                                            ),
                                                          ]
                                                      ),
                                                      child: GlowingOverscrollIndicator(
                                                        axisDirection: AxisDirection.down,
                                                        color:  Colors.deepPurple,
                                                        child: ListView(
                                                          padding: EdgeInsets.all(10),
                                                          shrinkWrap: true,
                                                          children: [
                                                            SizedBox(height: 20),
                                                            Center( //display ingredient name
                                                                child: AutoSizeText(
                                                                    ingredient,
                                                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]))
                                                            ),
                                                            Column( //display ingredient description
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                SizedBox(height: 12),
                                                                Container(height: 2),
                                                                Row(
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsets.only(left: 4.0),
                                                                      child:  Icon(
                                                                        Icons.lightbulb,
                                                                        color: Colors.amber,
                                                                      ),
                                                                    ),
                                                                    AutoSizeText(
                                                                        "Description",
                                                                        maxLines: 1,
                                                                        minFontSize: 12,
                                                                        presetFontSizes: [15, 14, 12],
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                        textAlign: TextAlign.left
                                                                    ),
                                                                  ],
                                                                ),
                                                                Padding(
                                                                    padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0),
                                                                    child: AutoSizeText(
                                                                      "${databaseDescription[ingredient]}",
                                                                      style: TextStyle(height: 1.5, fontSize: 15, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),

                                                                    )
                                                                ),
                                                                Row(  //display ingredient rating
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsets.only(left: 4.0),
                                                                      child: Icon(
                                                                        Icons.health_and_safety_rounded,
                                                                        color: databaseColor[ingredient],
                                                                      ),
                                                                    ),
                                                                    displayDatabaseRating(ingredient),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets.only(right: 10.0, bottom: 4.0),
                                                              child: Row( //display ingredient label
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets.only(left: 4.0),
                                                                    child:  Icon(
                                                                      Icons.label,
                                                                      color: Colors.purple[400],
                                                                    ),
                                                                  ),
                                                                  AutoSizeText(
                                                                    "${databaseLabel[ingredient]}",
                                                                    maxLines: 1,
                                                                    minFontSize: 12,
                                                                    presetFontSizes: [15, 14, 12],
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: TextStyle(height: 1.5, fontSize: 15, fontWeight: FontWeight.bold, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                                                                  )
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),

                                                      ),
                                                    ),
                                                  );
                                                }
                                            );
                                          },
                                          label: Align( //display ingredient name button
                                              alignment: Alignment.topLeft,
                                              child: AutoSizeText(
                                                  ingredient,
                                                  maxLines: 1,
                                                  minFontSize: 12,
                                                  presetFontSizes: [15, 14, 12],
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(color: Colors.blueGrey, fontSize: 15, fontWeight: FontWeight.bold)
                                              )
                                          ),

                                          style: ButtonStyle( //display ingredient btn color
                                            backgroundColor: MaterialStateProperty.all(databaseColor[ingredient]),
                                            alignment: Alignment.center,
                                            elevation: MaterialStateProperty.all(3),
                                            shadowColor:MaterialStateProperty.all(Colors.grey), //Defines shadowColor
                                          ),

                                          icon: Icon(
                                              Icons.arrow_drop_down,
                                              color: Colors.black54
                                          ),

                                          )).toList()
                                    ),
                                ),
                              ),
                            ),

                          ],
                        ),



                        //FOR FUTURE USE
                        // ElevatedButton(
                        //     onPressed: (){  //load data from fire store database
                        //       FirebaseFirestore.instance.collection("ingredients").get()
                        //           .then((querySnapshot) {
                        //         print("Successfully load all ingredients");
                        //         //print querySnapshot
                        //         querySnapshot.docs.forEach((element) {
                        //           //print(element.data());
                        //           print(element.data()['name']);
                        //         });
                        //       }).catchError((error){
                        //         print("Fail to load all ingredients");
                        //         print(error);
                        //       });
                        //     },
                        //     child: Text("List all ingredients")
                        // )
                      ]
                  ),
                ),
              ),
            ),
      ),
    );
  }

  void setAttributes() {
      results = widget.foundIngred;
      keys = widget.foundIngred.keys.toList();

  }

  //store ingredient name and color pair in Map to set the color of the dynamic buttons
  void setButtonColor(){
    for(var i = 0; i < keys.length; i++){
      if(results.values.elementAt(i).elementAt(1) == "green"){
        btnColor[keys[i]] = Colors.green;
      }
      else if (results.values.elementAt(i).elementAt(1) == "yellow"){
        btnColor[keys[i]] = Colors.amber;
      }
      else if (results.values.elementAt(i).elementAt(1) == "red"){
        btnColor[keys[i]] = Colors.red;
      }
      else{
        btnColor[keys[i]] = Colors.lightBlueAccent;
      }
    }
  }

  AutoSizeText displayDatabaseRating(ingredient){
    if(databaseRating[ingredient] == "green"){
      return AutoSizeText(
          "Recommended",
          maxLines: 1,
          minFontSize: 12,
          presetFontSizes: [15, 14, 12],
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 15 , fontWeight: FontWeight.bold, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900])
      );
    }
    else if(databaseRating[ingredient] == "yellow"){
      return AutoSizeText(
          "Not Recommended",
          maxLines: 1,
          minFontSize: 12,
          presetFontSizes: [15, 14, 12],
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900])
      );

    }
    else if(databaseRating[ingredient] == "red"){
      return AutoSizeText(
          "Avoid",
          maxLines: 1,
          minFontSize: 12,
          presetFontSizes: [15, 14, 12],
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900])
      );

    }
    else if(databaseRating[ingredient] == "neutral"){
      return AutoSizeText(
          "General ingredient definition",
          maxLines: 1,
          minFontSize: 12,
          presetFontSizes: [15, 14, 12],
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900])
      );
    }
    else{
      return AutoSizeText(
          "Not Found",
          maxLines: 1,
          minFontSize: 12,
          presetFontSizes: [15, 14, 12],
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900])
      );
    }
  }
  AutoSizeText displayRating(ingredient){
    if(results[ingredient]?.elementAt(1) == "green"){
      return AutoSizeText(
          "Recommended",
          maxLines: 1,
          minFontSize: 12,
          presetFontSizes: [15, 14, 12],
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 15 , fontWeight: FontWeight.bold, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900])
      );
    }
    else if(results[ingredient]?.elementAt(1) == "yellow"){
      return AutoSizeText(
          "Not Recommended",
          maxLines: 1,
          minFontSize: 12,
          presetFontSizes: [15, 14, 12],
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900])
      );

    }
    else if(results[ingredient]?.elementAt(1) == "red"){
      return AutoSizeText(
          "Avoid",
          maxLines: 1,
          minFontSize: 12,
          presetFontSizes: [15, 14, 12],
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900])
      );

    }
    else if(results[ingredient]?.elementAt(1) == "neutral"){
      return AutoSizeText(
          "General ingredient definition",
          maxLines: 1,
          minFontSize: 12,
          presetFontSizes: [15, 14, 12],
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900])
      );
    }
   else{
      return AutoSizeText(
          "Not Found",
          maxLines: 1,
          minFontSize: 12,
          presetFontSizes: [15, 14, 12],
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900])
      );
    }
  }

  void overallRatingPopUp(){
    List<String> descriptionRating =["Excellent", "Good", "Fair", "Poor", "Terrible"];
    String title;
    if(widget.grade.values.elementAt(0) >= 90.0){
      title = descriptionRating.elementAt(0);
    }
    else if(widget.grade.values.elementAt(0) >= 80.0){
      title = descriptionRating.elementAt(1);
    }
    else if(widget.grade.values.elementAt(0) >= 70.0){
      title = descriptionRating.elementAt(2);
    }
    else if(widget.grade.values.elementAt(0) >= 60.0){
      title = descriptionRating.elementAt(3);
    }
    else {
      title = descriptionRating.elementAt(4);
    }
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context){
          return  AlertDialog(
            elevation: 16,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            buttonPadding: EdgeInsets.all(0.8),
            backgroundColor: widget.gradeColor,
            title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  if(title == "Excellent")
                    Text("This product contains a significant amount of healthy ingredients and is pug approved! ", style: TextStyle(fontSize: 15, color: Colors.white)),
                  if(title == "Good")
                    Text("This product contains a few undesirable ingredients, but mostly contains"
                        " healthy ingredients and is pug approved!", style: TextStyle(fontSize: 15, color: Colors.white)),
                  if(title == "Fair")
                    Text("This product should be used with caution. There are concerning ingredients found that may"
                        " be lacking in studies or should be consumed in moderation. Read ingredient definitions"
                        " carefully.", style: TextStyle(fontSize: 15, color: Colors.white)),
                  if(title == "Poor")
                    Text("This product contains a significant amount of unhealthy ingredients and is not pug approved."
                        " In some cases, ingredients may be harmful or not appropriate to consume daily in large quantities.", style: TextStyle(fontSize: 15, color: Colors.white)),
                  if(title == "Terrible")
                    Text("This product should be avoided and is not pug approved.", style: TextStyle(fontSize: 15, color: Colors.white))
                ],
              ),
            ),
          );
        }
    );
  }

  void showIngredients(){
    setState((){
      _isVisible = !_isVisible;
    });
  }
  void showPieChart(){
    setState((){
      _isVisible2 = !_isVisible2;
    });
  }

  void showDatabase(){
    setState((){
      _isVisible3 = !_isVisible3;
    });
  }

  getDatabase() async {
    dynamic data = await FirebaseFirestore.instance.collection("ingredients").get()
        .then((querySnapshot) {
      print("Successfully load all ingredients");
      //print querySnapshot
      querySnapshot.docs.forEach((element) {
        //print(element.data());
        // print(element.data()['name']);

        //Add database results to be displayed
        databaseDescription[element.data()['name']] = element.data()["description"];
        databaseRating[element.data()['name']] =  element.data()["color"];
        databaseLabel[element.data()['name']] = element.data()["label"];
        databaseKeys.add(element.data()['name']);

        if(databaseRating[element.data()['name']] == "green"){
          databaseColor[element.data()['name']] = Colors.green;
        }
        else if (databaseRating[element.data()['name']] == "yellow"){
          databaseColor[element.data()['name']] = Colors.amber;
        }
        else if (databaseRating[element.data()['name']]  == "red"){
          databaseColor[element.data()['name']] = Colors.red;
        }
        else{
          databaseColor[element.data()['name']] = Colors.lightBlueAccent;
        }


      });
    }).catchError((error){
      print("Fail to load all ingredients");
      print(error);
    });
  }

  ThemeData lightTheme(){
    return ThemeData(
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary:Color(0xFF7E57C2),

      ),
      scaffoldBackgroundColor: Colors.grey[50],
      primaryColor: Colors.white,
      brightness: Brightness.light,
      dividerColor: Colors.white54,
    );
  }
  ThemeData darkTheme(){
    return ThemeData(
      appBarTheme: AppBarTheme(color: const Color(0xFF253341),),
      scaffoldBackgroundColor: const Color(0xFF15202B),
      primarySwatch: Colors.grey,
      primaryColor: const Color(0xFF253341),
      brightness: Brightness.dark,
      backgroundColor: const Color(0xFF212121),
      dividerColor: Colors.black12,
    );
  }

  void mainPage(){
    setState((){
      Navigator.pushAndRemoveUntil( //on back reset screen //use .pop to keep content
        context,
        MaterialPageRoute(builder: (context) => MyHomePage(title: 'Home', isDarkModeEnabled: widget.isDarkModeEnabled,)),
            (Route<dynamic> route) => false,
      );
      print("Now on Main Page");//debug
    });
  }
}

