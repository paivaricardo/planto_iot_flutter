import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:planto_iot_flutter/components/planto_iot_appbar_background.dart';
import 'package:planto_iot_flutter/components/planto_iot_background_builder.dart';
import 'package:planto_iot_flutter/components/planto_iot_title_component.dart';
import 'package:planto_iot_flutter/services/firebase_auth_service.dart';
import 'package:provider/provider.dart';

import '../../components/dashboard_button.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final User? loggedInUser = Provider.of<User?>(context);

    return Scaffold(
      appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              PlantoIOTTitleComponent(size: 18),
              Text("Dashboard",
                  style: TextStyle(fontSize: 18.0, fontFamily: 'FredokaOne')),
            ],
          ),
          flexibleSpace: const PlantoIOTAppBarBackground()),
      body: Container(
        width: double.infinity,
        decoration: PlantoIoTBackgroundBuilder().buildPlantoIoTAppBackGround(
            firstRadialColor: 0xFF0D6D0B, secondRadialColor: 0xFF0B3904),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Bem vindo(a), ${loggedInUser?.displayName}!',
                style: const TextStyle(
                    fontFamily: 'Josefin Sans',
                    color: Colors.white,
                    fontSize: 18.0),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Selecione a opção desejada abaixo:',
                style: TextStyle(
                    fontFamily: 'Josefin Sans',
                    color: Colors.white,
                    fontSize: 18.0),
              ),
            ),
            const Divider(
              color: Colors.white,
              thickness: 2.0,
              indent: 16, // Left padding
              endIndent: 16, // Right padding
            ),
            Wrap(alignment: WrapAlignment.spaceBetween, children: [
              DashboardButton(
                  onPressed: () {}, title: 'Sensores', icon: Icons.sensors),
              DashboardButton(
                  onPressed: () {}, title: 'Sobre', icon: Icons.info_rounded),
              DashboardButton(
                  onPressed: () => FirebaseAuthService.signOut(),
                  onLongPress: () => FirebaseAuthService.signOutSocialProviders(),
                  title: 'Sair',
                  icon: Icons.logout_rounded),
            ])
          ],
        ),
      ),
    );
  }
}
