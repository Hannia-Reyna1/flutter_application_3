import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _registerUser() async {
    try {
      if (!_isValidEmail(emailController.text)) { // ✅ Validamos el correo antes de registrarlo
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Correo inválido. Usa un formato correcto.')),
        );
        return;
      }

      if (passwordController.text.length < 6) { // ✅ Validamos que la contraseña tenga al menos 6 caracteres
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('La contraseña debe tener al menos 6 caracteres.')),
        );
        return;
      }

      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      User? user = userCredential.user;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        debugPrint('📩 Correo de verificación enviado a ${user.email}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Correo de verificación enviado. Revisa tu bandeja de entrada.')),
        );
      }

      Navigator.pushReplacementNamed(context, '/auth'); // ✅ Redirige a inicio de sesión después del registro
    } catch (e) {
      debugPrint('❌ Error de registro: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(email); // ✅ Expresión regular para validar correos
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _registerUser,
              child: const Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }
}