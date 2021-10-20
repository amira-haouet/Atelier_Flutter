import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Unit Converter',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _inputController = TextEditingController();
  double resultat;
  String _from = 'grams';
  String _to = 'kilograms';

  // -- Mass conversions _from a base of 1 gram
  final Map<String, double> _massConvertions = {
    'grams': 1,
    'kilograms': 1 / 1000,
    'pounds (lb.)': 1 / 454,
    'ounces': 1 / 28.35
  };

  // -- The conversion formula
  double calculateResult() {
    var value = double.tryParse(_inputController.text);
    if (value != null) {
      return value *
          (_massConvertions[_to] / _massConvertions[_from]);
    }
  }

  @override
  void initState() {
    _inputController.addListener(() {
      setState(() {
        resultat = calculateResult();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Unit Converter"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
          child: Column(
            children: [
              const Text(
                'Value to convert',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _inputController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22),
                decoration: const InputDecoration(hintText: 'put number here'),
              ),
              const SizedBox(height: 15),
              DropdownButton<String>(
                value: _from,
                isExpanded: true,
                items: _massConvertions.entries
                    .map((MapEntry<String, double> mapEntry) {
                  return DropdownMenuItem(
                    child: Text(mapEntry.key),
                    value: mapEntry.key,
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _from = value as String;
                    resultat = calculateResult();
                  });
                },
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: _to,
                isExpanded: true,
                items: _massConvertions.entries
                    .map((MapEntry<String, double> mapEntry) {
                  return DropdownMenuItem(
                    child: Text(mapEntry.key),
                    value: mapEntry.key,
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _to = value as String;
                    resultat = calculateResult();
                  });
                },
              ),
              const SizedBox(height: 30),
              Text(
                (resultat == null || resultat == 0)
                    ? ''
                    : resultat.toStringAsFixed(3),
                style: const TextStyle(fontSize: 22),
              )
            ],
          ),
        ),
      ),
    );
  }
}