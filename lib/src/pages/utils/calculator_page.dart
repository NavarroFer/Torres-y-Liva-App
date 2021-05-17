import 'package:flutter/material.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';

class CalculatorPage extends StatefulWidget {
  static final String route = 'calculator';
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: CalcButton(),
      ),
    );
  }
}

class CalcButton extends StatefulWidget {
  @override
  _CalcButtonState createState() => _CalcButtonState();
}

class _CalcButtonState extends State<CalcButton> {
  double _currentValue = 0;
  @override
  Widget build(BuildContext context) {
    var calc = SimpleCalculator(
      value: _currentValue,
      hideExpression: false,
      hideSurroundingBorder: true,
      onChanged: (key, value, expression) {
        setState(() {
          _currentValue = value;
        });
        print("$key\t$value\t$expression");
      },
      onTappedDisplay: (value, details) {
        print("$value\t${details.globalPosition}");
      },
      theme: const CalculatorThemeData(
        borderColor: Colors.black,
        borderWidth: 2,
        displayColor: Colors.white,
        displayStyle: const TextStyle(fontSize: 80, color: Colors.black),
        expressionColor: Colors.green,
        expressionStyle: const TextStyle(fontSize: 20, color: Colors.white),
        operatorColor: Colors.red,
        operatorStyle: const TextStyle(fontSize: 30, color: Colors.white),
        commandColor: Colors.blue,
        commandStyle: const TextStyle(fontSize: 30, color: Colors.white),
        numColor: Colors.grey,
        numStyle: const TextStyle(fontSize: 50, color: Colors.white),
      ),
    );
    return calc;
  }
}
