import 'package:chat_app/model/chat_message.dart';
import 'package:chat_app/model/recent_chat.dart';
import 'package:chat_app/utils/firestore_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore firebaseFirestore;
  ChatService({required this.firebaseFirestore});

  sendChatMessage(
      {required String content,
      required String type,
      required String groupChatId,
      required String currentUserId,
      required String peerId}) async {
    DocumentReference documentReference = firebaseFirestore
        .collection(FireStoreConstant.chatCollectionPath)
        .doc(groupChatId)
        .collection(FireStoreConstant.messageCollectionPath)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());
    ChatMessage chatMessages = ChatMessage(
        idFrom: currentUserId,
        idTo: peerId,
        timestamp: DateTime.now().toString(),
        content: content,
        type: type);
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(documentReference, chatMessages.toJson());
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> loadChatMessages(
      {required String groupChatId, int limit = 20}) {
    return firebaseFirestore
        .collection(FireStoreConstant.chatCollectionPath)
        .doc(groupChatId)
        .collection(FireStoreConstant.messageCollectionPath)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> loadMoreChatMessages(
      {required String groupChatId,
      required DocumentSnapshot lastdocumentSnapshot,
      int limit = 20}) {
    return firebaseFirestore
        .collection(FireStoreConstant.chatCollectionPath)
        .doc(groupChatId)
        .collection(FireStoreConstant.messageCollectionPath)
        .orderBy('timestamp', descending: true)
        .startAfterDocument(lastdocumentSnapshot)
        .limit(limit)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> loadRecentChats(
      {required String currentUserId, int limit = 15}) {
    return firebaseFirestore
        .collection(FireStoreConstant.recentChatCollectionPath)
        .doc(currentUserId)
        .collection(FireStoreConstant.recentPeerCollectionPath)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots();
  }

  addRecentChat(
      {required String content,
      required String currentUserId,
      required String peerId}) async {
    try {
      _addRecentChatFromId(
          content: content, currentUserId: currentUserId, peerId: peerId);
      _addRecentChatToId(
          content: content, currentUserId: currentUserId, peerId: peerId);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  _addRecentChatFromId(
      {required String content,
      required String currentUserId,
      required String peerId}) async {
    DocumentReference documentReference = firebaseFirestore
        .collection(FireStoreConstant.recentChatCollectionPath)
        .doc(currentUserId)
        .collection(FireStoreConstant.recentPeerCollectionPath)
        .doc(peerId);
    RecentChat recentChat = RecentChat(
      idFrom: currentUserId,
      idTo: peerId,
      timestamp: DateTime.now().toString(),
      content: content,
    );
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(documentReference, recentChat.toJson());
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  _addRecentChatToId(
      {required String content,
      required String currentUserId,
      required String peerId}) async {
    DocumentReference documentReference = firebaseFirestore
        .collection(FireStoreConstant.recentChatCollectionPath)
        .doc(peerId)
        .collection(FireStoreConstant.recentPeerCollectionPath)
        .doc(currentUserId);
    RecentChat recentChat = RecentChat(
      idFrom: peerId,
      idTo: currentUserId,
      timestamp: DateTime.now().toString(),
      content: content,
    );
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(documentReference, recentChat.toJson());
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
