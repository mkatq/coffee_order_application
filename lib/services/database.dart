import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firestorage = FirebaseStorage.instance;
  Future AddProduct(Map<String, dynamic> ProductInfoMap) async {
    return await _firestore
        .collection('coffeeshops')
        .doc(_auth.currentUser!.uid)
        .collection('items')
        .doc()
        .set(ProductInfoMap);
  }

  Future BlockAndUnblock(Map<String, dynamic> BlockInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Block")
        .doc(id)
        .set(BlockInfoMap);
  }

  Future<Stream<QuerySnapshot>> getProduct() async {
    return await FirebaseFirestore.instance
        .collection('coffeeshops')
        .doc(_auth.currentUser!.uid)
        .collection('items')
        .snapshots();
  }

  Future DeleteProduct(String id) async {
    return await FirebaseFirestore.instance
        .collection('coffeeshops')
        .doc(_auth.currentUser!.uid)
        .collection('items')
        .doc(id)
        .delete();
  }

  Future UpdateProduct(String id, Map<String, dynamic> updateInfo) async {
    return await _firestore
        .collection('coffeeshops')
        .doc(_auth.currentUser!.uid)
        .collection('items')
        .doc(id)
        .update(updateInfo);
  }
}
