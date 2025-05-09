import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final CollectionReference<Map<String, dynamic>> _products = FirebaseFirestore.instance.collection('products');

  Future<void> addProduct(String name, double price, String imageUrl) async {
    await _products.add(<String, dynamic>{'nombre': name, 'precio': price, 'imagen': imageUrl});
  }

  Future<void> deleteProduct(String id) async {
    await _products.doc(id).delete();
  }
}