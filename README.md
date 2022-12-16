# Happy Pug

A project created to give pet owners transparency in their animal products\
[Happy Pug Website](https://madrigalceiara.wixsite.com/website)

## Overview
Happy Pug is aimed to give transparency in dog food products. Simply take a picture of the ingredient list of your favorite dog food product and within a short interval view a detailed description, analysis, and rating of the ingredients found. Happy Pug is for people who love their dogs or for people who are simply curious of the unfamiliar ingredients in their dog's food. The rating of each ingredient is created with an unique algorithm and takes into consideration of the standards provided by the AAFCO and Tail Blazers.com. Happy Pug has a database with hundreds of ingredient names, descriptions, ratings, and labels to give accurate results as possible. Download Happy Pug on the Google Play Store to start using today!

**Firebase Firestore Usage**
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
