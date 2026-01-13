import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const BarcodeScannerPage(),
    );
  }
}

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({super.key});

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  MobileScannerController controller = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Barcode Scanner page")),
      body: Center(
        child: Column(
          children: [
            Container(
              height: 400,
              width: 400,
              child: MobileScanner(
                controller: controller,
                onDetect: (result) {
                  if (result.barcodes.isNotEmpty) {
                    String? code = result.barcodes.first.rawValue;
                    Navigator.of(context).pop(code ?? '');
                    // print(result.barcodes.first.rawValue ?? 'No value');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
