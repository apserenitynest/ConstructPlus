import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Constructplus',
    home: ConstructPlusApp(),
  ));
}

class ConstructPlusApp extends StatefulWidget {
  @override
  _ConstructPlusAppState createState() => _ConstructPlusAppState();
}

class _ConstructPlusAppState extends State<ConstructPlusApp> {
  File? _image;
  final picker = ImagePicker();
  String _elementType = 'Drzwi';
  double _surface = 2.0;
  int _hours = 1;
  String _mode = 'pow'; // 'pow' lub 'godz'
  Map<String, bool> _scope = {
    'Malowanie 1x': true,
    'Malowanie 2x': false,
    'Szlifowanie': false,
    'Akryl': false,
    'Gruntowanie': false,
  };
  double? _quote;
  String? _aiMessage; // Wynik "AI"

  final Map<String, double> _prices = {
    'Malowanie 1x': 30,
    'Malowanie 2x': 35,
    'Szlifowanie': 3,
    'Akryl': 5,
    'Gruntowanie': 5,
  };

  final List<Map<String, dynamic>> _elements = [
    {'name': 'Drzwi', 'surface': 2.0},
    {'name': 'Okno', 'surface': 1.2},
    {'name': 'Rama', 'surface': 0.8},
    {'name': 'Inny', 'surface': 1.0},
  ];

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _aiMessage = "Rozpoznawanie AI... (tu wpięty model)";
        // Tu podpinamy wywołanie AI!
        // Dla demo: symulujemy wykrycie drzwi
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            _elementType = 'Drzwi';
            _aiMessage = "Wykryto: Drzwi (symulacja AI)";
            _surface = 2.0;
          });
        });
      });
    }
  }

  void calculateQuote() {
    double sum = 0;
    if (_mode == 'pow') {
      _scope.forEach((key, value) {
        if (value) sum += _prices[key]! * _surface;
      });
    } else {
      double perHour = 0;
      _scope.forEach((key, value) {
        if (value) perHour += _prices[key]!;
      });
      sum = perHour * _hours;
    }
    setState(() {
      _quote = sum;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Constructplus'),
        backgroundColor: Colors.blue[700],
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(18),
        children: [
          Text(
            'Wycena prac malarskich na podstawie zdjęcia i AI',
            style: TextStyle(fontSize: 15, color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 18),
          Center(
            child: _image == null
                ? ElevatedButton.icon(
                    icon: Icon(Icons.camera_alt),
                    label: Text('Zrób zdjęcie'),
                    onPressed: pickImage,
                  )
                : Column(
                    children: [
                      Image.file(_image!, height: 120),
                      SizedBox(height: 8),
                      _aiMessage != null
                          ? Text(
                              _aiMessage!,
                              style: TextStyle(color: Colors.green[800]),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
          ),
          SizedBox(height: 14),
          Row(
            children: [
              Text("Typ elementu:", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(width: 14),
              DropdownButton<String>(
                value: _elementType,
                items: _elements
                    .map((el) => DropdownMenuItem<String>(
                          child: Text(el['name']),
                          value: el['name'],
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _elementType = val!;
                    _surface = _elements.firstWhere((el) => el['name'] == val)['surface'];
                    _aiMessage = null;
                  });
                },
              ),
              SizedBox(width: 6),
              Text(
                "(możesz poprawić wybór AI)",
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text("Wycena wg:", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(width: 10),
              ChoiceChip(
                label: Text("m²"),
                selected: _mode == 'pow',
                onSelected: (val) {
                  setState(() => _mode = 'pow');
                },
              ),
              SizedBox(width: 6),
              ChoiceChip(
                label: Text("godzinowo"),
                selected: _mode == 'godz',
                onSelected: (val) {
                  setState(() => _mode = 'godz');
                },
              ),
            ],
          ),
          SizedBox(height: 8),
          _mode == 'pow'
              ? Row(
                  children: [
                    Text("Powierzchnia (m²):", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),
                    Container(
                      width: 70,
                      child: TextField(
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        controller: TextEditingController(text: _surface.toString()),
                        onChanged: (val) {
                          setState(() {
                            _surface = double.tryParse(val) ?? 1.0;
                          });
                        },
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Text("Liczba godzin:", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),
                    Container(
                      width: 60,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: TextEditingController(text: _hours.toString()),
                        onChanged: (val) {
                          setState(() {
                            _hours = int.tryParse(val) ?? 1;
                          });
                        },
                      ),
                    ),
                  ],
                ),
          SizedBox(height: 10),
          Text("Zakres prac:", style: TextStyle(fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 8,
            children: _scope.keys.map((key) {
              return FilterChip(
                label: Text(key),
                selected: _scope[key]!,
                onSelected: (val) {
                  setState(() {
                    _scope[key] = val;
                  });
                },
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            child: Text('Oblicz wycenę'),
            onPressed: calculateQuote,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
              textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              backgroundColor: Colors.blue[700],
            ),
          ),
          SizedBox(height: 14),
          _quote != null
              ? Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "Całkowita wycena: ${_quote!.toStringAsFixed(2)} €",
                    style: TextStyle(
                        color: Colors.green[900],
                        fontSize: 21,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
