import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:planto_iot_flutter/components/auth_wrapper/auth_wrapper_component.dart';
import 'package:planto_iot_flutter/screens/configuracoes/configuracoes_screen.dart';
import 'package:planto_iot_flutter/screens/dashboard/dashboard_screen.dart';
import 'package:planto_iot_flutter/screens/sensores/sensores_screen.dart';
import 'package:planto_iot_flutter/screens/sobre/sobre_screen.dart';
import 'package:planto_iot_flutter/services/firebase_auth_service.dart';
import 'package:provider/provider.dart';

// Este é a classe principal da aplicação
class PlantoIoTApp extends StatefulWidget {
  const PlantoIoTApp({super.key});

  @override
  State<PlantoIoTApp> createState() => _PlantoIoTAppState();
}

class _PlantoIoTAppState extends State<PlantoIoTApp> {
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
          routes: {
            '/dashboard': (context) => const DashboardScreen(),
            '/sensores': (context) => const SensoresScreen(),
            '/sobre': (context) => const SobreScreen(),
            '/configuracoes': (context) => const ConfiguracoesScreen(),
          }),
    );
  }
}
