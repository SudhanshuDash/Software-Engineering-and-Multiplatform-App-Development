import 'package:flutter/material.dart';

void main() {
  runApp(const ConversionApp());
}

/// Root App with Material 3
class ConversionApp extends StatelessWidget {
  const ConversionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unit Converter',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const ConversionHome(),
    );
  }
}

/// Home screen with dropdowns and input
class ConversionHome extends StatefulWidget {
  const ConversionHome({super.key});

  @override
  State<ConversionHome> createState() => _ConversionHomeState();
}

class _ConversionHomeState extends State<ConversionHome> {
  final TextEditingController _valueController = TextEditingController();

  String system = "Metric";
  String category = "Length";
  String fromUnit = "Meters";
  String toUnit = "Kilometers";
  String result = "";

  final Map<String, List<String>> units = {
    "Length": ["Meters", "Kilometers", "Miles", "Feet"],
    "Weight": ["Kilograms", "Grams", "Pounds", "Ounces"],
    "Temperature": ["Celsius", "Fahrenheit"],
    "Volume": ["Liters", "Milliliters", "Gallons", "Fluid Ounces"],
  };

  void convert() {
    double? input = double.tryParse(_valueController.text);
    if (input == null) {
      setState(() => result = "⚠️ Please enter a valid number");
      return;
    }

    double output = _convertValue(category, fromUnit, toUnit, input);
    setState(() => result = "$input $fromUnit = ${output.toStringAsFixed(2)} $toUnit");
  }

  double _convertValue(String category, String from, String to, double value) {
    switch (category) {
      case "Length":
        return _lengthConversion(from, to, value);
      case "Weight":
        return _weightConversion(from, to, value);
      case "Temperature":
        return _temperatureConversion(from, to, value);
      case "Volume":
        return _volumeConversion(from, to, value);
      default:
        return value;
    }
  }

  // ---- Length ----
  double _lengthConversion(String from, String to, double value) {
    Map<String, double> meters = {
      "Meters": 1.0,
      "Kilometers": 1000.0,
      "Miles": 1609.34,
      "Feet": 0.3048,
    };
    return value * (meters[from]! / meters[to]!);
  }

  // ---- Weight ----
  double _weightConversion(String from, String to, double value) {
    Map<String, double> grams = {
      "Kilograms": 1000.0,
      "Grams": 1.0,
      "Pounds": 453.592,
      "Ounces": 28.3495,
    };
    return value * (grams[from]! / grams[to]!);
  }

  // ---- Temperature ----
  double _temperatureConversion(String from, String to, double value) {
    if (from == to) return value;
    if (from == "Celsius" && to == "Fahrenheit") {
      return (value * 9 / 5) + 32;
    } else if (from == "Fahrenheit" && to == "Celsius") {
      return (value - 32) * 5 / 9;
    }
    return value;
  }

  // ---- Volume ----
  double _volumeConversion(String from, String to, double value) {
    Map<String, double> liters = {
      "Liters": 1.0,
      "Milliliters": 0.001,
      "Gallons": 3.78541,
      "Fluid Ounces": 0.0295735,
    };
    return value * (liters[from]! / liters[to]!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Unit Converter")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category
            DropdownButtonFormField<String>(
              value: category,
              decoration: const InputDecoration(labelText: "Category"),
              items: units.keys
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  category = val!;
                  fromUnit = units[category]!.first;
                  toUnit = units[category]!.last;
                });
              },
            ),
            const SizedBox(height: 12),

            // From Unit
            DropdownButtonFormField<String>(
              value: fromUnit,
              decoration: const InputDecoration(labelText: "From"),
              items: units[category]!
                  .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                  .toList(),
              onChanged: (val) => setState(() => fromUnit = val!),
            ),
            const SizedBox(height: 12),

            // To unit
            DropdownButtonFormField<String>(
              value: toUnit,
              decoration: const InputDecoration(labelText: "To"),
              items: units[category]!
                  .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                  .toList(),
              onChanged: (val) => setState(() => toUnit = val!),
            ),
            const SizedBox(height: 12),

            // Input field
            TextField(
              controller: _valueController,
              decoration: const InputDecoration(
                labelText: "Enter value",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Convert button
            Center(
              child: ElevatedButton(
                onPressed: convert,
                child: const Text("Convert"),
              ),
            ),
            const SizedBox(height: 20),

            // Result
            Text(
              result,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}

