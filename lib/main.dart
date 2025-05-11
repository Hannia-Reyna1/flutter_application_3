import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'screens/cart_screen.dart'; // ✅ Se asegura que el carrito esté disponible

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('🚀 Inicializando la aplicación...');

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('✅ Firebase inicializado correctamente.');
    runApp(TermoApp());
  } catch (e) {
    debugPrint('❌ Error al inicializar Firebase: $e');
  }
}

class TermoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint('🔹 Construyendo la aplicación...');

    return MaterialApp(
      debugShowCheckedModeBanner: false, // ✅ Desactiva el banner de debug/
      title: 'Venta de Termos',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/home',
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => HomeScreen(),
        '/cart':
            (BuildContext context) => CartScreen(
              carrito: <Map<String, dynamic>>[],
            ), // ✅ El carrito se mantiene accesible
      },
    );
  }
}
