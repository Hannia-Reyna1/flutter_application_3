import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/auth_screen.dart'; // ✅ Importación de pantalla de autenticación
import 'services/cart_provider.dart'; // ✅ Importación del proveedor de carrito

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final CartProvider cartProvider = CartProvider();
  await cartProvider.cargarCarrito(); // ✅ Recupera los productos guardados

  runApp(
    MultiProvider(
      providers: <ChangeNotifierProvider<CartProvider>>[
        ChangeNotifierProvider<CartProvider>(create: (BuildContext context) => cartProvider),
      ],
      child: const TermoApp(),
    ),
  );
}

class TermoApp extends StatelessWidget {
  const TermoApp({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('🔹 Construyendo la aplicación...');

    return MultiProvider(
      providers: <ChangeNotifierProvider<CartProvider>>[
        ChangeNotifierProvider<CartProvider>(create: (BuildContext context) => CartProvider()), // ✅ Estado global del carrito
      ],
      child: MaterialApp(
        title: 'Venta de Termos',
        debugShowCheckedModeBanner: false, // ✅ Oculta el banner de debug
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true, // ✅ Habilitar Material 3
        ),
        initialRoute: '/home',
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => const HomeScreen(),
          '/cart': (BuildContext context) => const CartScreen(),
          '/login': (BuildContext context) => AuthScreen(), // ✅ Agregamos la ruta de login
        },
        builder: (BuildContext context, Widget? child) {
          return SafeArea( // ✅ Evita interferencias con barras de estado y gestos
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.1), // ✅ Escalado para mejorar legibilidad
              ),
              child: child ?? Container(),
            ),
          );
        },
      ),
    );
  }
}