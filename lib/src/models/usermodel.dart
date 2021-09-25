import 'package:firebase_database/firebase_database.dart';

class User {
  var userName;
  var id;
  var timeStamp;
  var email;

  User(this.email, this.id, this.timeStamp, this.userName);
  User.fromSnapshot(DataSnapshot snapshot)
      : email = snapshot.value['email'],
        userName = snapshot.value['username'],
        timeStamp = snapshot.value['TimeStamp'],
        id = snapshot.value['id'];

  toJson() {
    return {
      "email": email,
      "username": userName,
      "TimeStamp": timeStamp,
      "id": id,
    };
  }
}
