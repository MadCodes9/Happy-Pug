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
## Results Page
The overall rating is calculated out of one hundred. When the ingredient list is filtered through the algorithm, it reads the rating of each ingredient and either subtracts or adds points. If a ingredient has a green or blue rating then the algorithm adds points, if a ingredient has a yellow rating then the algorithm add half-points and if the ingredients has a red rating then no points are added. Additional points are either added or subtracted depending in the first five ingredients. If the first five ingredients are all green/blue than a +5 bonus point is added, if there contains a yellow than a -3 bonus point is added and if there contains a red than a -5 bonus point is added. Finally, the overall ingredient rating is compared to a grading scale, which determines the grade. Each individual ingredient rating is calculated with consideration to the AAFCO and AllAboutDogFood.co.uk.

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
