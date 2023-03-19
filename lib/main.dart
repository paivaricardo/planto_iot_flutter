import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:planto_iot_flutter/firebase_options.dart';
import 'package:planto_iot_flutter/planto_iot_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar o Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Rodar o app
  runApp(const PlantoIoTApp());
}
