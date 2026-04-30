```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ø­Ø§Ø³Ø¨Ø©',
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  String _expression = '';
  double? _firstOperand;
  String? _operator;
  bool _isNewNumber = true;

  void _onDigitPressed(String digit) {
    setState(() {
      if (_isNewNumber) {
        _display = digit;
        _isNewNumber = false;
      } else {
        if (_display.length < 15) {
          _display += digit;
        }
      }
    });
  }

  void _onDecimalPressed() {
    setState(() {
      if (_isNewNumber) {
        _display = '0.';
        _isNewNumber = false;
      } else if (!_display.contains('.')) {
        _display += '.';
      }
    });
  }

  void _onOperatorPressed(String op) {
    setState(() {
      if (_firstOperand == null) {
        _firstOperand = double.tryParse(_display) ?? 0;
      } else if (!_isNewNumber) {
        _calculateResult();
      }
      _operator = op;
      _expression = '$_firstOperand $op';
      _isNewNumber = true;
    });
  }

  void _calculateResult() {
    if (_firstOperand == null || _operator == null) return;

    final double secondOperand = double.tryParse(_display) ?? 0;
    double result;

    switch (_operator) {
      case '+':
        result = _firstOperand! + secondOperand;
        break;
      case '-':
        result = _firstOperand! - secondOperand;
        break;
      case 'Ã':
        result = _firstOperand! * secondOperand;
        break;
      case 'Ã·':
        if (secondOperand == 0) {
          _display = 'Ø®Ø·Ø£';
          _expression = 'ÙØ§ ÙÙÙÙ Ø§ÙÙØ³ÙØ© Ø¹ÙÙ ØµÙØ±';
          _firstOperand = null;
          _operator = null;
          _isNewNumber = true;
          return;
        }
        result = _firstOperand! / secondOperand;
        break;
      default:
        return;
    }

    _display = _formatResult(result);
    _expression = '$_firstOperand $_operator $secondOperand =';
    _firstOperand = result;
    _operator = null;
    _isNewNumber = true;
  }

  String _formatResult(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(2);
  }

  void _onEqualsPressed() {
    setState(() {
      if (_operator != null) {
        _calculateResult();
      }
    });
  }

  void _onClearPressed() {
    setState(() {
      _display = '0';
      _expression = '';
      _firstOperand = null;
      _operator = null;
      _isNewNumber = true;
    });
  }

  void _onBackspacePressed() {
    setState(() {
      if (_display.length > 1) {
        _display = _display.substring(0, _display.length - 1);
      } else {
        _display = '0';
        _isNewNumber = true;
      }
    });
  }

  void _onPercentPressed() {
    setState(() {
      final double value = double.tryParse(_display) ?? 0;
      _display = _formatResult(value / 100);
      _isNewNumber = true;
    });
  }

  void _onNegatePressed() {
    setState(() {
      if (_display != '0') {
        if (_display.startsWith('-')) {
          _display = _display.substring(1);
        } else {
          _display = '-$_display';
        }
      }
    });
  }

  Widget _buildButton({
    required String text,
    required Color color,
    required VoidCallback onPressed,
    double flex = 1,
  }) {
    return Expanded(
      flex: flex.round(),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20),
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ø­Ø§Ø³Ø¨Ø©'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      _expression,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _display,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.right,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildButton(
                        text: 'AC',
                        color: Colors.grey[700]!,
                        onPressed: _onClearPressed,
                      ),
                      _buildButton(
                        text: 'â«',
                        color: Colors.grey[700]!,
                        onPressed: _onBackspacePressed,
                      ),
                      _buildButton(
                        text: '%',
                        color: Colors.grey[700]!,
                        onPressed: _onPercentPressed,
                      ),
                      _buildButton(
                        text: 'Ã·',
                        color: Colors.orange,
                        onPressed: () => _onOperatorPressed('Ã·'),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton(
                        text: '7',
                        color: Colors.grey[850]!,
                        onPressed: () => _onDigitPressed('7'),
                      ),
                      _buildButton(
                        text: '8',
                        color: Colors.grey[850]!,
                        onPressed: () => _onDigitPressed('8'),
                      ),
                      _buildButton(
                        text: '9',
                        color: Colors.grey[850]!,
                        onPressed: () => _onDigitPressed('9'),
                      ),
                      _buildButton(
                        text: 'Ã',
                        color: Colors.orange,
                        onPressed: () => _onOperatorPressed('Ã'),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton(
                        text: '4',
                        color: Colors.grey[850]!,
                        onPressed: () => _onDigitPressed('4'),
                      ),
                      _buildButton(
                        text: '5',
                        color: Colors.grey[850]!,
                        onPressed: () => _onDigitPressed('5'),
                      ),
                      _buildButton(
                        text: '6',
                        color: Colors.grey[850]!,
                        onPressed: () => _onDigitPressed('6'),
                      ),
                      _buildButton(
                        text: '-',
                        color: Colors.orange,
                        onPressed: () => _onOperatorPressed('-'),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton(
                        text: '1',
                        color: Colors.grey[850]!,
                        onPressed: () => _onDigitPressed('1'),
                      ),
                      _buildButton(
                        text: '2',
                        color: Colors.grey[850]!,
                        onPressed: () => _onDigitPressed('2'),
                      ),
                      _buildButton(
                        text: '3',
                        color: Colors.grey[850]!,
                        onPressed: () => _onDigitPressed('3'),
                      ),
                      _buildButton(
                        text: '+',
                        color: Colors.orange,
                        onPressed: () => _onOperatorPressed('+'),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton(
                        text: 'Â±',
                        color: Colors.grey[850]!,
                        onPressed: _onNegatePressed,
                      ),
                      _buildButton(
                        text: '0',
                        color: Colors.grey[850]!,
                        onPressed: () => _onDigitPressed('0'),
                      ),
                      _buildButton(
                        text: '.',
                        color: Colors.grey[850]!,
                        onPressed: _onDecimalPressed,
                      ),
                      _buildButton(
                        text: '=',
                        color: Colors.teal,
                        onPressed: _onEqualsPressed,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```