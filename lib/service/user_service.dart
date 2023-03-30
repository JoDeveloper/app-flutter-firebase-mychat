import 'package:chat_app/utils/firestore_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore firebaseFirestore;
  UserService({required this.firebaseFirestore});
  Future<void> addUser(User user) async {
    firebaseFirestore
        .collection(FireStoreConstant.userCollectionPath)
        .doc(user.uid)
        .set({
      "id": user.uid,
      "photoUrl": user.photoURL,
      "displayName": user.displayName,
      "phoneNumber": user.phoneNumber
    });
  }

  Future<bool> checkUserExist(String userId) async {
    final QuerySnapshot result = await firebaseFirestore
        .collection(FireStoreConstant.userCollectionPath)
        .where("id", isEqualTo: userId)
        .limit(1)
        .get();
    return result.docs.isNotEmpty;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUsers(
      {required String searchText, int limit = 15}) async {
    if (searchText.isNotEmpty) {
      return await firebaseFirestore
          .collection(FireStoreConstant.userCollectionPath)
          .where("displayName", isGreaterThanOrEqualTo: searchText)
          .where("displayName", isLessThan: '${searchText}z')
          .limit(limit)
          .get();
    } else {
      return await firebaseFirestore
          .collection(FireStoreConstant.userCollectionPath)
          .limit(limit)
          .get();
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUsersByIds(
      {List<String> ids = const [], int limit = 10}) async {
    if (ids.isNotEmpty) {
      return await firebaseFirestore
          .collection(FireStoreConstant.userCollectionPath)
          .where("id", whereIn: ids)
          .limit(limit)
          .get();
    } else {
      return await firebaseFirestore
          .collection(FireStoreConstant.userCollectionPath)
          .limit(limit)
          .get();
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> loadUsersByIds(
      {List<String> ids = const [], int limit = 10}) {
    if (ids.isNotEmpty) {
      return firebaseFirestore
          .collection(FireStoreConstant.userCollectionPath)
          .where("id", whereIn: ids)
          .limit(limit)
          .snapshots();
    } else {
      return firebaseFirestore
          .collection(FireStoreConstant.userCollectionPath)
          .limit(limit)
          .snapshots();
    }
  }
}
