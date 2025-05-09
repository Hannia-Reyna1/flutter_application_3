import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: 'AIzaSyBvMzfpC1tBe6hAKNFxBqQWIp_XL87a8a4', // ✅ Usa la clave API que obtuviste de Firebase
      appId: '1:989549273358:web:367b8e3aafca56ac05775f',
      messagingSenderId: '989549273358',
      projectId: 'venta-de-termos',
      storageBucket: 'venta-de-termos.appspot.com', // ✅ Corrige el dominio de Firebase Storage
    );
  }
}