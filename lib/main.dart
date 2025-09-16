import 'package:flutter/material.dart';
import 'package:petstore/injection_container.dart';
import 'package:petstore/ui/home/widgets/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();
  runApp(PetStoreApp());
}

class PetStoreApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Store Clean Architecture',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PetStoreHomePage(),
    );
  }
}
