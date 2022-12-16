import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyDryMatterBasisPage extends StatefulWidget {
  const MyDryMatterBasisPage({Key? key, required this.title, required this.isDarkModeEnabled}) : super(key: key);//constructor
  final String title; //attribute
  final bool isDarkModeEnabled;

  @override
  State<MyDryMatterBasisPage> createState() => _MyDryMatterBasisPageState();

}

class _MyDryMatterBasisPageState extends State<MyDryMatterBasisPage> {  //home screen actions
  TextEditingController proteinController = TextEditingController();
  TextEditingController fatController = TextEditingController();
  TextEditingController fiberController = TextEditingController();
  TextEditingController moistureController = TextEditingController();

  Map<String, String> dry_matter_basis = {};
  bool _isVisible = false;
  bool _isInvalid = false;

  @override
  Widget build(BuildContext context) {//entire UI
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme(),
      darkTheme: darkTheme(),
      themeMode: widget.isDarkModeEnabled ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              splashRadius: 0.5,
              padding: EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              onPressed:(){
                //reset data before going back to results page
                dry_matter_basis.clear();
                _isVisible = false;
                _isInvalid = false;
                resultsPage();
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 27,
              ),
            ),
          ],
          title: Text(widget.title),
        ),

        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  AutoSizeText(
                      "Dry Matter Basis",
                      style: TextStyle(fontSize: 15, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900], fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center
                  ),

                  Padding(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0, top: 10.0),
                      child:
                      Container(
                        child:AutoSizeText(
                            "This moisture-free approach to stating the true nutrient content of any food is known as Dry Matter Basis.",
                            style: TextStyle(fontSize: 15, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                            textAlign: TextAlign.center
                        ),
                        color: widget.isDarkModeEnabled ?Colors.grey[600]: Colors.grey[100],
                        padding: EdgeInsets.all(8),
                      )
                  ),

                  Padding(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 4.0, top: 10.0),
                      child:
                      Container(
                        child:AutoSizeText(
                            "This is very useful when comparing dry food and wet food or seeing a more accurate percentage value of the "
                                "guaranteed analysis",
                            style: TextStyle(fontSize: 15, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900]),
                            textAlign: TextAlign.center
                        ),
                        color: widget.isDarkModeEnabled ?Colors.grey[600]: Colors.grey[100],
                        padding: EdgeInsets.all(8),
                      )
                  ),

                  Container(  //maximum space you can use
                      margin: EdgeInsets.symmetric(horizontal: 50),
                      child: TextFormField(
                        controller: proteinController,
                        obscureText: false,
                        decoration: InputDecoration(hintText: "Protein(%)"),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}')),
                        ], // Only numbers can be entered,
                      )
                  ),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 50),
                    child: TextFormField(
                      controller: fatController,
                      obscureText: false,
                      decoration: InputDecoration(hintText: "Fat(%)"),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}')),
                      ], // Only numbers can be entered,
                    )
                  ),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 50),
                    child: TextFormField(
                      controller: fiberController,
                      obscureText: false,
                      decoration: InputDecoration(hintText: "Fiber(%)"),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}')),
                      ], // Only numbers can be entered,
                    )
                  ),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 50),
                    child: TextFormField(
                      controller: moistureController,
                      obscureText: false,
                      decoration: InputDecoration(hintText: "Moisture(%)"),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}')),
                      ], // Only numbers can be entered,
                    )
                  ),

                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width /3,
                    margin: EdgeInsets.only(top: 5, bottom: 10),
                    child: ElevatedButton(
                        onPressed: () {
                          calculateDryMatterBasis();
                        },
                        child: Text("Calculate")
                    ),
                  ),

                  //Once calculations are finished, display results
                  if(dry_matter_basis.isNotEmpty)
                    Visibility(
                        visible: _isVisible,
                        child:  Container(
                            color: widget.isDarkModeEnabled ?Colors.grey[600]: Colors.purple.shade50,
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.symmetric(horizontal: 50),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 4.0),
                                    child: AutoSizeText(
                                        "Results",
                                        style: TextStyle(fontSize: 20, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900], fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left
                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.only(bottom: 4.0),
                                    child: AutoSizeText(
                                        dry_matter_basis.keys.elementAt(0) + ": " + dry_matter_basis.values.elementAt(0) + "%",
                                        style: TextStyle(fontSize: 18, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900], fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center
                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.only(bottom: 4.0),
                                    child: AutoSizeText(
                                        dry_matter_basis.keys.elementAt(1) + ": " + dry_matter_basis.values.elementAt(1) + "%",
                                        style: TextStyle(fontSize: 18, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900], fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left
                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.only(bottom: 4.0),
                                    child: AutoSizeText(
                                        dry_matter_basis.keys.elementAt(2) + ": " + dry_matter_basis.values.elementAt(2) + "%",
                                        style: TextStyle(fontSize: 18, color: widget.isDarkModeEnabled ?Colors.white: Colors.blueGrey[900], fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left
                                    ),
                                  ),

                              ],
                            )
                        ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                AutoSizeText(
                    'You must fill out entire fields before pressing calculate.\n',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.left
                ),
                AutoSizeText(
                    'Please try again',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //Calculation for Dry Matter Basis based on https://www.dogfoodinsider.com/understanding-guaranteed-analysis-panel/
  void calculateDryMatterBasis(){
    //Prompt pop-up to display to user that input is invalid
    if(proteinController.text.isEmpty || fatController.text.isEmpty || fiberController.text.isEmpty || moistureController.text.isEmpty ){
      setInvalid();
      return;
    }
    else{
      _isInvalid = false;
    }

    double guaranteed_crude_protein = double.parse(proteinController.text);
    double guaranteed_crude_fat = double.parse(fatController.text);
    double guaranteed_crude_fiber = double.parse(fiberController.text);
    double moisture = double.parse(moistureController.text);

    // print(moistureController.text);
    double dry_matter = 100 - moisture;

    //Calculations
    double true_protein = (guaranteed_crude_protein / dry_matter) * 100;
    double true_fat = (guaranteed_crude_fat / dry_matter) * 100;
    double true_fiber = (guaranteed_crude_fiber / dry_matter) * 100;

    //Map of results
    dry_matter_basis = {
      //round to first decimal place
      "True Protein" : true_protein.toStringAsFixed(1),
      "True Fat" : true_fat.toStringAsFixed(1),
      "True Fiber" : true_fiber.toStringAsFixed(1),
    };

    print("Results: " + dry_matter_basis.toString());
    displayResults();
  }

  void displayResults(){
    setState((){
      _isVisible = true;
    });
  }

  void setInvalid(){
    setState((){
      //display pop up alert
        showMyDialog();
      _isInvalid = !_isInvalid;
    });
  }



  void resultsPage(){
    setState((){
      //Go back to the results page
      Navigator.pop(context);
      print("Now on Main Page");//debug
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
}