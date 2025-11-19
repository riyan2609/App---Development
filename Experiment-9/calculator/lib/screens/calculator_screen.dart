import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:calculator_with_history/db/db_helper.dart';
import 'package:calculator_with_history/screens/history_screen.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String expression = '';
  String result = '';
  final DBHelper dbHelper = DBHelper();

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        expression = '';
        result = '';
      } else if (value == '⌫') {
        if (expression.isNotEmpty) {
          expression = expression.substring(0, expression.length - 1);
        }
      } else if (value == '=') {
        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);
          result = eval.toString();

          // Save to DB
          dbHelper.insertHistory(expression, result);
        } catch (e) {
          result = 'Error';
        }
      } else {
        expression += value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> buttons = [
      '7', '8', '9', '/',
      '4', '5', '6', '*',
      '1', '2', '3', '-',
      '0', '.', 'C', '+',
      '⌫', '=', 'H'
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator with History'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Display section
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.bottomRight,
              color: Colors.black12,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    expression,
                    style: const TextStyle(fontSize: 28, color: Colors.black87),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    result,
                    style: const TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Buttons Grid
          Expanded(
            flex: 2,
            child: GridView.builder(
              itemCount: buttons.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
              itemBuilder: (context, index) {
                String btn = buttons[index];
                Color btnColor = Colors.grey[300]!;
                if (btn == 'C' || btn == '⌫') btnColor = Colors.redAccent;
                if (btn == '=' || btn == 'H') btnColor = Colors.blueAccent;

                return InkWell(
                  onTap: () {
                    if (btn == 'H') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HistoryScreen()),
                      );
                    } else {
                      _onButtonPressed(btn);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: btnColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 3,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        btn,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
