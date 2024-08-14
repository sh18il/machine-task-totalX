import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:totalx/model/user_model.dart';

class AddService {
  String collectionRef = "users";
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference<UserModel> addUserRef =
      firestore.collection(collectionRef).withConverter<UserModel>(
            fromFirestore: (snapshot, options) =>
                UserModel.fromJson(snapshot.data() ?? {}),
            toFirestore: (value, options) => value.toJson(),
          );

  Future addData(UserModel model) async {
    await addUserRef.add(model);
  }

  Stream<QuerySnapshot<UserModel>> getData() {
    return addUserRef.snapshots();
  }
}
