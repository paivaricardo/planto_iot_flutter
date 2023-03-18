import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:planto_iot_flutter/components/auth_wrapper/auth_wrapper_component.dart';
import 'package:planto_iot_flutter/firebase_options.dart';
import 'package:planto_iot_flutter/services/firebase_auth_service.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar o Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Rodar o app
  runApp(const PlantoIoTApp());
}

class PlantoIoTApp extends StatelessWidget {
  const PlantoIoTApp({super.key});

  @override
  Widget build(BuildContext context) {
    // O StreamProvider é um wiget gerenciador de estado que fornece o usuário que está logado no Firebase para qualquer Widget filho
    return StreamProvider<User?>.value(
      value: FirebaseAuthService.authStateChanges,
      initialData: null,
      child: MaterialApp(
        title: 'Planto App',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        debugShowCheckedModeBanner: false,
        home: const AuthWrapperComponent(),
      ),
    );
  }
}
