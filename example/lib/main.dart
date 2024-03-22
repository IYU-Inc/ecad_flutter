import 'package:flutter/material.dart';
import 'package:ecad_flutter/ecad_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          title: const Text('EC-AD'),
        ),
        body: const SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Ecad(
                  id: 'p4XfczGOROCHeWHqVkvF',
                  hiddenSaleImage: false,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Ecad(
                  id: 'p4XfczGOROCHeWHqVkvF',
                  hiddenSaleImage: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
