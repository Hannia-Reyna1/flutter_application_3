import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final CollectionReference<Map<String, dynamic>> _products = FirebaseFirestore.instance.collection('products');
  final CollectionReference<Map<String, dynamic>> _users = FirebaseFirestore.instance.collection('usuarios');

  User? user = FirebaseAuth.instance.currentUser;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    verificarAdmin();
  }

  Future<void> verificarAdmin() async {
    if (user != null) {
      final DocumentSnapshot<Map<String, dynamic>> doc = await _users.doc(user!.uid).get();
      setState(() {
        isAdmin = doc.exists && doc.data()?['role'] == 'admin'; // ✅ Verifica si el usuario es admin
      });
    }
  }

  void addProduct() {
    if (!isAdmin) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('❌ No tienes permisos para agregar productos')));
      return;
    }

    if (nameController.text.isEmpty || priceController.text.isEmpty || imageUrlController.text.isEmpty || descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('❌ Todos los campos son obligatorios')));
      return;
    }

    try {
      _products.add(<String, dynamic>{
        'nombre': nameController.text,
        'precio': double.parse(priceController.text),
        'imagen': imageUrlController.text,
        'reseña': descriptionController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Producto agregado correctamente')));
      nameController.clear();
      priceController.clear();
      imageUrlController.clear();
      descriptionController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Error al agregar el producto: $e')));
    }
  }

  void deleteProduct(String id) {
    if (!isAdmin) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('❌ No tienes permisos para eliminar productos')));
      return;
    }

    try {
      _products.doc(id).delete();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Producto eliminado')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Error al eliminar el producto: $e')));
    }
  }

  void assignAdmin(String userId) {
    if (!isAdmin) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('❌ Solo administradores pueden asignar otros administradores')));
      return;
    }

    try {
      _users.doc(userId).update(<String, dynamic>{'role': 'admin'});
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Administrador asignado correctamente')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Error al asignar administrador: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Administrar Productos')),
      body: isAdmin
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nombre del producto')),
                  TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Precio'), keyboardType: TextInputType.number),
                  TextField(controller: imageUrlController, decoration: const InputDecoration(labelText: 'URL de la imagen')),
                  TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Descripción del producto')),
                  const SizedBox(height: 20),
                  ElevatedButton(onPressed: addProduct, child: const Text('Agregar Producto')),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: _products.snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                        final List<QueryDocumentSnapshot<Map<String, dynamic>>> productos = snapshot.data!.docs;

                        return ListView.builder(
                          itemCount: productos.length,
                          itemBuilder: (BuildContext context, int index) {
                            final QueryDocumentSnapshot<Map<String, dynamic>> product = productos[index];

                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                leading: Image.network(
                                  product['imagen'],
                                  width: 60,
                                  height: 60,
                                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) => const Icon(Icons.image_not_supported, color: Colors.red),
                                ),
                                title: Text(product['nombre'], style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('\$${product['precio']}', style: const TextStyle(color: Colors.blueAccent)),
                                    Text(product['reseña'] ?? 'Sin descripción', style: const TextStyle(color: Colors.grey)),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => deleteProduct(product.id),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          : const Center(child: Text('❌ No tienes permisos para acceder a esta pantalla', style: TextStyle(fontSize: 16, color: Colors.red))),
    );
  }
}