import 'package:flutter/material.dart';
import 'package:planto_iot_flutter/components/planto_iot_background_builder.dart';
import 'package:planto_iot_flutter/components/planto_iot_title_component.dart';
import 'package:planto_iot_flutter/services/firebase_auth_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              )
            ],
            gradient: const RadialGradient(colors: [
              Color(0xFF0D6D0B),
              Color(0xFF0B3904),
            ]),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: 300,
            width: double.infinity,
            decoration: PlantoIoTBackgroundBuilder()
                .buildPlantoIoTAppBackGround(
                    firstRadialColor: 0xFF083D07,
                    secondRadialColor: 0xFF031802),
            child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        PlantoIOTTitleComponent(),
                      ],
                    ),
                    const Text("Gerenciamento de agricultura de precisão",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontFamily: 'FredokaOne',
                            decoration: TextDecoration.none))
                  ],
                )),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 64.0),
          child: Align(
              alignment: Alignment.center,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    side: const BorderSide(
                        color: Colors.white,
                        width: 2,
                        strokeAlign: BorderSide.strokeAlignOutside)),
                onPressed: () {
                  FirebaseAuthService.signInWithGoogle();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.g_mobiledata_outlined,
                      color: Colors.white,
                    ),
                    Text(
                      "Entrar com Google",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'FredokaOne',
                          fontSize: 18),
                    ),
                  ],
                ),
              )),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Text(
              "2023, Centro Universitário de Brasília",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'FredokaOne',
                  fontSize: 18,
                  decoration: TextDecoration.none),
            ),
          ),
        ),
      ],
    );
  }
}
