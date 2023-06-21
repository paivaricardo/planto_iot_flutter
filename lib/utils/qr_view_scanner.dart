import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:planto_iot_flutter/components/planto_iot_appbar_background.dart';
import 'package:planto_iot_flutter/components/planto_iot_title_component.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:uuid/uuid.dart';

class QRViewScanner extends StatefulWidget {
  const QRViewScanner({Key? key}) : super(key: key);

  @override
  State<QRViewScanner> createState() => _QRViewScannerState();
}

class _QRViewScannerState extends State<QRViewScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool flashOn = false;
  bool? validUuid;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  void readQr() async {
    if (result != null) {
      if (Uuid.isValidUUID(fromString: result!.code!)) {
        setState(() {
          validUuid = true;
        });

        controller!.pauseCamera();
        print(result!.code);
        controller!.dispose();

        Future.delayed(const Duration(milliseconds: 100), () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("UUID obtido."),
            duration: Duration(seconds: 1),
          ));

          Navigator.of(context).pop(result);
        });
      } else {
        setState(() {
          validUuid = false;
        });
      }
    }
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                PlantoIOTTitleComponent(size: 18),
                Text("Ler QR Code",
                    style: TextStyle(fontSize: 18.0, fontFamily: 'FredokaOne')),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () => _showHelpDialog(context),
              icon: const Icon(Icons.help_outline_rounded,
                  color: Colors.white, size: 24)),
        ],
        flexibleSpace: const PlantoIOTAppBarBackground());
  }

  @override
  Widget build(BuildContext context) {
    readQr();

    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Column(
                      children: [
                        if (validUuid != null)
                          validUuid == true
                              ? const Text('UUID válido detectado.',
                                  style: TextStyle(color: Colors.green))
                              : const Text(
                                  'UUID inválido. Tente novamente.',
                                  style: TextStyle(color: Colors.red),
                                ),
                        Text(
                            'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}'),
                      ],
                    )
                  : const Text('Posicione o código no centro da visualização'),
            ),
          )
        ],
      ),
      persistentFooterButtons: [
        TextButton(
            onPressed: () {
              controller!.pauseCamera();
              print(result!.code);
              controller!.dispose();

              Navigator.of(context).pop();
            },
            child: const Text('Cancelar')),
        IconButton(
            onPressed: () async {
              await controller?.flipCamera();
            },
            icon: const Icon(Icons.flip_camera_android_rounded, color: Colors.green,)),
        IconButton(
            onPressed: () async {
              await controller?.toggleFlash();

              setState(() {
                flashOn = !flashOn;
              });
            },
            icon: Icon(
                flashOn ? Icons.flash_off_rounded : Icons.flash_on_rounded, color: Colors.green,)),
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            alignment: Alignment.center,
            title: const Text(
              'Sobre',
              style: TextStyle(fontFamily: "FredokaOne", fontSize: 24.0),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Esta tela permite que você cadastre, monitore e controle seus sensores e atuadores para uso agrícola. Ainda está em construção. Volte em breve para novidades.',
                    textAlign: TextAlign.justify,
                    style:
                        TextStyle(fontFamily: "Josefin Sans", fontSize: 16.0),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'))
            ],
          );
        });
  }
}
