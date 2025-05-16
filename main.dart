import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum CalculatorMode { decimal, binary, octal, hexadecimal }

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator & Base Converter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _input = '';
  String _operation = '';
  double _firstNumber = 0;
  bool _newNumber = true;
  CalculatorMode _currentMode = CalculatorMode.decimal;
  Map<String, String> _conversions = {
    'Decimal': '0',
    'Binary': '0',
    'Octal': '0',
    'Hexadecimal': '0',
  };

  void _updateConversions(double value) {
    int intValue = value.toInt();
    setState(() {
      _conversions = {
        'Decimal': intValue.toString(),
        'Binary': intValue.toRadixString(2),
        'Octal': intValue.toRadixString(8),
        'Hexadecimal': intValue.toRadixString(16).toUpperCase(),
      };
    });
  }

  void _copyToClipboard(String value) {
    Clipboard.setData(ClipboardData(text: value)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Copied to clipboard'),
          duration: Duration(seconds: 1),
        ),
      );
    });
  }

  bool _isValidInputForMode(String input) {
    switch (_currentMode) {
      case CalculatorMode.decimal:
        return RegExp(r'^[0-9]+$').hasMatch(input);
      case CalculatorMode.binary:
        return RegExp(r'^[0-1]+$').hasMatch(input);
      case CalculatorMode.octal:
        return RegExp(r'^[0-7]+$').hasMatch(input);
      case CalculatorMode.hexadecimal:
        return RegExp(r'^[0-9A-Fa-f]+$').hasMatch(input);
    }
  }

  int _getRadix() {
    switch (_currentMode) {
      case CalculatorMode.decimal:
        return 10;
      case CalculatorMode.binary:
        return 2;
      case CalculatorMode.octal:
        return 8;
      case CalculatorMode.hexadecimal:
        return 16;
    }
  }

  void _onNumberPressed(String number) {
    if (!_isValidInputForMode(number)) return;

    setState(() {
      if (_newNumber) {
        _input = number;
        _newNumber = false;
      } else {
        _input += number;
      }

      if (_input.isNotEmpty) {
        try {
          final value = int.parse(_input, radix: _getRadix()).toDouble();
          _updateConversions(value);
        } catch (e) {
          // Handle parsing errors silently
        }
      }
    });
  }

  void _onOperationPressed(String operation) {
    setState(() {
      if (operation == 'CLEAR') {
        _clear();
        return;
      }

      if (_input.isEmpty && operation != '-') return;

      if (_operation.isEmpty) {
        _firstNumber = int.parse(_input, radix: _getRadix()).toDouble();
        _operation = operation;
        _newNumber = true;
      } else {
        _calculateResult();
        _operation = operation;
      }
    });
  }

  void _calculateResult() {
    if (_input.isEmpty) return;

    setState(() {
      double secondNumber = int.parse(_input, radix: _getRadix()).toDouble();
      double result = 0;

      switch (_operation) {
        case '+':
          result = _firstNumber + secondNumber;
          break;
        case '-':
          result = _firstNumber - secondNumber;
          break;
        case '×':
          result = _firstNumber * secondNumber;
          break;
        case '÷':
          if (secondNumber == 0) {
            _clear();
            _input = 'Error';
            return;
          }
          result = _firstNumber / secondNumber;
          break;
        case '%':
          result = _firstNumber % secondNumber;
          break;
        default:
          result = secondNumber;
      }

      _firstNumber = result;
      _input = result.toInt().toRadixString(_getRadix()).toUpperCase();
      _updateConversions(result);
      _operation = '';
      _newNumber = true;
    });
  }

  void _clear() {
    _input = '';
    _operation = '';
    _firstNumber = 0;
    _newNumber = true;
    _updateConversions(0);
  }

  void _switchMode(CalculatorMode newMode) {
    setState(() {
      _currentMode = newMode;
      _clear();
    });
  }

  String _getDisplayText() {
    if (_input.isEmpty) return '0';
    if (_input == 'Error') return 'Error';

    try {
      int value = int.parse(_input, radix: _getRadix());
      if (_currentMode == CalculatorMode.hexadecimal) {
        return '${_input.toUpperCase()} (${value.toString()})';
      }
      return _input;
    } catch (e) {
      return _input.toUpperCase();
    }
  }

  bool _isButtonEnabled(String text) {
    // First check if it's an operation button
    if ('+-×÷%='.contains(text)) return true;

    // Special check for the CLEAR button
    if (text == 'CLEAR') return true;
    // For letter buttons (A-F)
    if (RegExp(r'[A-F]').hasMatch(text)) {
      return _currentMode == CalculatorMode.hexadecimal;
    }

    // For number buttons
    switch (_currentMode) {
      case CalculatorMode.decimal:
        return RegExp(r'[0-9]').hasMatch(text);
      case CalculatorMode.binary:
        return RegExp(r'[0-1]').hasMatch(text);
      case CalculatorMode.octal:
        return RegExp(r'[0-7]').hasMatch(text);
      case CalculatorMode.hexadecimal:
        return RegExp(r'[0-9A-F]').hasMatch(text);
    }
  }

  Widget _buildButton(String text, {Color? color}) {
    bool isEnabled = _isButtonEnabled(text);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: SizedBox(
          height: 45,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isEnabled
                      ? (color ?? Theme.of(context).primaryColor)
                      : Colors.grey[300],
              foregroundColor: isEnabled ? Colors.white : Colors.grey[600],
              padding: const EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed:
                isEnabled
                    ? () {
                      if ('0123456789ABCDEF'.contains(text)) {
                        _onNumberPressed(text);
                      } else if ('+-×÷%CLEAR='.contains(text)) {
                        if (text == '=') {
                          _calculateResult();
                        } else {
                          _onOperationPressed(text);
                        }
                      }
                    }
                    : null,
            child: Text(text, style: const TextStyle(fontSize: 18)),
          ),
        ),
      ),
    );
  }

  Widget _buildModeButton(CalculatorMode mode, String label) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                _currentMode == mode
                    ? Theme.of(context).primaryColor
                    : Colors.grey[200],
            foregroundColor: _currentMode == mode ? Colors.white : Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => _switchMode(mode),
          child: Text(label, style: const TextStyle(fontSize: 12)),
        ),
      ),
    );
  }

  Widget _buildConversionCard(String base, String value) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => _copyToClipboard(value),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    base,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const Icon(Icons.copy, size: 16, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator & Base Converter'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              children: [
                // Mode switcher
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      _buildModeButton(CalculatorMode.decimal, 'Decimal'),
                      _buildModeButton(CalculatorMode.binary, 'Binary'),
                      _buildModeButton(CalculatorMode.octal, 'Octal'),
                      _buildModeButton(CalculatorMode.hexadecimal, 'Hex'),
                    ],
                  ),
                ),

                // Display area
                Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _getDisplayText(),
                        style: const TextStyle(fontSize: 36),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (_operation.isNotEmpty)
                        Text(
                          '$_firstNumber $_operation',
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                ),

                // Conversion display area
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Number System Conversions',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ..._conversions.entries.map<Widget>(
                        (entry) => _buildConversionCard(entry.key, entry.value),
                      ),
                    ],
                  ),
                ),

                // Calculator buttons
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      // Hex buttons row
                      Row(
                        children: [
                          _buildButton('A'),
                          _buildButton('B'),
                          _buildButton('C'),
                          _buildButton('D'),
                          _buildButton('E'),
                          _buildButton('F'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildButton('7'),
                          _buildButton('8'),
                          _buildButton('9'),
                          _buildButton('÷', color: Colors.orange),
                        ],
                      ),
                      Row(
                        children: [
                          _buildButton('4'),
                          _buildButton('5'),
                          _buildButton('6'),
                          _buildButton('×', color: Colors.orange),
                        ],
                      ),
                      Row(
                        children: [
                          _buildButton('1'),
                          _buildButton('2'),
                          _buildButton('3'),
                          _buildButton('-', color: Colors.orange),
                        ],
                      ),
                      Row(
                        children: [
                          _buildButton('0'),
                          _buildButton('=', color: Colors.green),
                          _buildButton('+', color: Colors.orange),
                        ],
                      ),
                      Row(
                        children: [
                          _buildButton('CLEAR', color: Colors.red),
                          _buildButton('%', color: Colors.orange),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
