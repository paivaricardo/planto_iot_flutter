import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:planto_iot_flutter/components/planto_iot_appbar_background.dart';
import 'package:planto_iot_flutter/components/planto_iot_background_builder.dart';
import 'package:planto_iot_flutter/components/planto_iot_title_component.dart';
import 'package:provider/provider.dart';

class SensoresScreen extends StatefulWidget {
  const SensoresScreen({Key? key}) : super(key: key);

  @override
  State<SensoresScreen> createState() => _SensoresScreenState();
}

class _SensoresScreenState extends State<SensoresScreen> {
  @override
  Widget build(BuildContext context) {
    final User? loggedInUser = Provider.of<User?>(context);

    return Scaffold(
      appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              PlantoIOTTitleComponent(size: 18),
              Text("Sensores",
                  style: TextStyle(fontSize: 18.0, fontFamily: 'FredokaOne')),
            ],
          ),
          flexibleSpace: const PlantoIOTAppBarBackground()),
      body: Container(
        width: double.infinity,
        decoration: PlantoIoTBackgroundBuilder().buildPlantoIoTAppBackGround(
            firstRadialColor: 0xFF0D6D0B, secondRadialColor: 0xFF0B3904),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Text(
                  "Esta funcionalidade ainda não está disponível em nossa aplicação! Volte em breve para mais novidades 😉",
                  style: TextStyle(
                      fontFamily: 'Josefin Sans',
                      color: Colors.white,
                      fontSize: 18.0)),
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Voltar")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
