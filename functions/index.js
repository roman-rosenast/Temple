const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

exports.endDay = functions.https.onRequest((req, res) => {
    var dbRef = admin.database().ref('/History/');
    dbRef.transaction(function(snapshot) {

        console.log(snapshot.val());
        res.status(200).send(snapshot.val());
        var dynamicDay = "Day" + snapshot.val().CurrentDay;
        
        var today = new Date();
        var dd = today.getDate();
        var mm = today.getMonth() + 1; //January is 0!

        var yyyy = today.getFullYear();
        if (dd < 10) {
        dd = '0' + dd;
        } 
        if (mm < 10) {
        mm = '0' + mm;
        } 
        var newDate = dd + '/' + mm + '/' + yyyy;
    
        dbRef.child(dynamicDay).set({
            Date: newDate,
            P1Completed: "False",
            P2Completed: "False",
            P3Completed: "False",
            P4Completed: "False",
            P5Completed: "False"
        });
    })
    res.redirect(200);
});

    
    // dbRef.child('trophies').child(trophy).transaction(function(currentValue) {
    //     return currentValue + 1
    // });

// func endDay() {
        
//     let db = Database.database().reference()
    
//     // Increment CurrentDay
//     var newDay: Int = 0
//     db.child("History/CurrentDay").observeSingleEvent(of: .value, with: { snapshot in
//         let stringValue: String = snapshot.value as! String
//         newDay = Int(stringValue.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())!
//     })
//     newDay += 1
//     db.child("History/CurrentDay").setValue("Day\(newDay)")
    
//     // Make new Day
//     let date = Date()
//     let calendar = Calendar.current
//     let todaysDate: String = String(calendar.component(.month, from: date)) + "/" + String(calendar.component(.day, from: date)) + "/" + String(calendar.component(.year, from: date))
//     // source: https://coderwall.com/p/b8pz5q/swift-4-current-year-mont-day
    
//     db.child("History/Day\(newDay)").setValue(["Date": todaysDate])
//     for i in 1...5 {
//         db.child("History/Day\(newDay)").setValue(["P\(i)Completed": "False"])
//     }

// }