# Happy Pug

A project created to give pet owners transparency in their animal products\
[Happy Pug Website](https://madrigalceiara.wixsite.com/website)

## Overview
Happy Pug is aimed to give transparency in dog food products. Simply take a picture of the ingredient list of your favorite dog food product and within a short interval view a detailed description, analysis, and rating of the ingredients found. Happy Pug is for people who love their dogs or for people who are simply curious of the unfamiliar ingredients in their dog's food. The rating of each ingredient is created with an unique algorithm and takes into consideration of the standards provided by the AAFCO and Tail Blazers.com. Happy Pug has a database with hundreds of ingredient names, descriptions, ratings, and labels to give accurate results as possible. Download Happy Pug on the Google Play Store to start using today!

## Firebase Firestore Usage & Regular Expressions
This project utilizes the firestore database to store each ingredient description, rating, and label. There are over 500 ingredient data stored in the databse. Once the text recognition scans the ingredient list that the user has captured, the algorithim uses regular expressions to capture each individual ingredient and format it to the same format of the ingredients in the firestore database. That way the ingredients captured and the ingredients in the database can be compared and matching results are then displayed in the results page. 

**Firebase Firestore**
```Dart
  Future<void> _findResults(String scannedIngredient) async{
    await FirebaseFirestore.instance.collection("ingredients")
        .where("lowercaseName", isEqualTo: scannedIngredient).get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        //Add name as key and fields as value
         results[element.data()['name']] = [element.data()['description'],
          element.data()['color'], element.data()['label']];
         return;
        });
      }).catchError((error){
        print("Fail to load all ingredients");
        print(error);
      });
  }
```
**Regular Expressions**
```Dart
 Future _filterIngredients() async {
    //String manipulation to format scanned ingredients the same as database ingredients-lowercaseName
    String trim_ingredients = scannedText.replaceAll(':', ','); //replace any colons with a comma
    trim_ingredients = trim_ingredients.replaceAll('Ingredients', ','); //replace 'Ingredients' with a comma
    trim_ingredients = trim_ingredients.replaceAll('INGREDIENTS', ',');  //replace 'Ingredients' with a comma
    trim_ingredients = trim_ingredients.replaceAll('Vitamins', ''); //replace 'Ingredients' with a comma
    trim_ingredients = trim_ingredients.replaceAll('VITAMINS', '');  //replace 'Ingredients' with a comma
    trim_ingredients = trim_ingredients.replaceAll('Minerals', ''); //replace 'Ingredients' with a comma
    trim_ingredients = trim_ingredients.replaceAll('MINERALS', '');  //replace 'Ingredients' with a comma
    trim_ingredients = trim_ingredients.replaceAll(';', ','); //replace ';' with a comma
    trim_ingredients = trim_ingredients.replaceAll('.', ','); //replace period with a comma
    trim_ingredients = trim_ingredients.replaceAll('[', '');
    trim_ingredients = trim_ingredients.replaceAll(']', '');
    trim_ingredients = trim_ingredients.replaceAll("-", ""); //replace  '-' with a space
    trim_ingredients = trim_ingredients.replaceAll('(', ','); //replace '(' and ')' with commas to get actual ingredient name
    trim_ingredients = trim_ingredients.replaceAll(')', ',');
    trim_ingredients = trim_ingredients.replaceAll(new RegExp(r"\s+"), "").toLowerCase(); //eliminate all spaces and lowercase
    List<String> scannedIngredients = trim_ingredients.split(","); //split ingredients after comma and store in list

    // trim_ingredients = trim_ingredients.replaceAll(new RegExp(r"\([^)]*\)|()"), ""); //remove everything inside parenthesis
    final len = scannedIngredients.length;
    print("Scanned Ingredient Formatted");
    print(scannedIngredients);

    //search for ingredients in database
    for(var i = 0; i < len; i++){
      if(i > len/2){  //timer is triggered when filtering is half-way finished
        setState((){
          timerTriggered = true;
        });
      }
      await _findResults(scannedIngredients[i]);
    }
    print("Finished Filtering");
    print("Common ingredients found: ");
    print(results.keys);
    seperateByColorIngredients();  //filter ingredients by color
    setPieChartData();  //filter ingredients by label
  }
```
## Results Screen
The overall rating is calculated out of one hundred. When the ingredient list is filtered through the algorithm, it reads the rating of each ingredient and either subtracts or adds points. If a ingredient has a green or blue rating then the algorithm adds points, if a ingredient has a yellow rating then the algorithm add half-points and if the ingredients has a red rating then no points are added. Additional points are either added or subtracted depending in the first five ingredients. If the first five ingredients are all green/blue than a +5 bonus point is added, if there contains a yellow than a -3 bonus point is added and if there contains a red than a -5 bonus point is added. Finally, the overall ingredient rating is compared to a grading scale, which determines the grade. Each individual ingredient rating is calculated with consideration to the AAFCO and AllAboutDogFood.co.uk.

The results are display in a list tile format and can be viewed in a pie chart format as well. The pie chart format displays segments that each represents a percentage of ingredients found in a given category. Each segment represents a particular category.

The search tab can be used when a specific ingredient isn't displayed or when the user is curious about a specific ingredient. The search tab allows the user to view the database and provides search filters to easily find ingredients. When the user hits 'apply' the data is displayed on the screen in a list tile format.  

## Dry Matter Basis Calculator Screen
Another tool provided is the Dry Matter Basis Calculator, which can provide the true percentage of protien, fat and fiber from the Guranteed Analysis. This is useful because moisture in the Guranteed Analysis offsets the real values of protien, fat and fiber and since moisture isn't alwasy neccesary to a animal's nutritional requirement, than it can be ignored. The Dry Matter Basis Calculator does this by excluding the offset of moisture and provides the results to the user. 

**Dry Matter Basis Calculation**
```Dart
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
```

## Technologies
Project is created with 
* IDE: Flutter 
* Version: 12.8 
* Language: Dart 

## Download
This app can be downloaded in the google play store
[Happy Pug](https://play.google.com/store/apps/details?id=com.happypug.happy_pug)

## Status 
This is a project created by @MadCodes9 :grinning:
