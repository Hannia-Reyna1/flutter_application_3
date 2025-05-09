import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController _nameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController.text = user?.displayName ?? '';
  }

  Future<void> _cambiarFotoPerfil() async {
    final XFile? imagenSeleccionada = await _picker.pickImage(source: ImageSource.gallery);
    if (imagenSeleccionada != null) {
      final File imagenFile = File(imagenSeleccionada.path);
      final Reference storageRef = FirebaseStorage.instance.ref().child('perfil/${user!.uid}.jpg');

      await storageRef.putFile(imagenFile);
      final String urlImagen = await storageRef.getDownloadURL();
      await user?.updatePhotoURL(urlImagen);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Foto de perfil actualizada')));
      setState(() {});
    }
  }

  void _actualizarPerfil() {
    if (user != null) {
      user?.updateDisplayName(_nameController.text);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Perfil actualizado')));
      setState(() {});
    }
  }

  Future<void> _cerrarSesion() async {
    await FirebaseAuth.instance.signOut(); // ✅ Cierra sesión
    Navigator.pop(context); // ✅ Regresa a la pantalla anterior
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: _cambiarFotoPerfil, // ✅ Tocar para cambiar foto
              child: CircleAvatar(
                radius: 50,
                backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                child: user?.photoURL == null ? const Icon(Icons.person, size: 50) : null,
              ),
            ),
            const SizedBox(height: 10),
            const Text('Toca la imagen para cambiarla', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 20),
            Text(user?.email ?? 'No hay usuario', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nombre')),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _actualizarPerfil, child: const Text('Actualizar Perfil')),
            const SizedBox(height: 20), 
            ElevatedButton(onPressed: _cerrarSesion, child: const Text('Cerrar sesión')), // ✅ Botón de cerrar sesión
          ],
        ),
      ),
    );
  }
}