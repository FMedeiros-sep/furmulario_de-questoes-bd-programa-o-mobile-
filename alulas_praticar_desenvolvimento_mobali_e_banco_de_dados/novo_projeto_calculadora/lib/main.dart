import 'package:flutter/material.dart';

void main() {
  runApp(const CalculadoraApp());
}

class CalculadoraApp extends StatelessWidget {
  const CalculadoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculadora',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const CalculadoraHome(),
    );
  }
}

class CalculadoraHome extends StatefulWidget {
  const CalculadoraHome({super.key});

  @override
  State<CalculadoraHome> createState() => _CalculadoraHomeState();
}

class _CalculadoraHomeState extends State<CalculadoraHome> {
  String _expressao = '';
  String _resultado = '0';
  String _operacao = '';
  double _primeiroNumero = 0;

  void _pressionarNumero(String numero) {
    setState(() {
      _expressao += numero;
      _resultado = _expressao;
    });
  }

  void _pressionarOperacao(String op) {
    if (_expressao.isNotEmpty) {
      _primeiroNumero = double.parse(_expressao);
      _operacao = op;
      setState(() {
        _expressao = '';
        _resultado = '$_primeiroNumero $op';
      });
    }
  }

  void _calcular() {
    if (_expressao.isNotEmpty && _operacao.isNotEmpty) {
      double segundoNumero = double.parse(_expressao);
      double calculo = 0;

      switch (_operacao) {
        case '+':
          calculo = _primeiroNumero + segundoNumero;
          break;
        case '-':
          calculo = _primeiroNumero - segundoNumero;
          break;
        case '*':
          calculo = _primeiroNumero * segundoNumero;
          break;
        case '/':
          calculo = _primeiroNumero / segundoNumero;
          break;
      }

      setState(() {
        _resultado = calculo.toString();
        _expressao = '';
        _operacao = '';
      });
    }
  }

  void _limpar() {
    setState(() {
      _expressao = '';
      _resultado = '0';
      _operacao = '';
      _primeiroNumero = 0;
    });
  }

  Widget _buildBotao(String texto, {Color? color, Function()? onPressed}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey.shade800,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.all(22.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          onPressed: onPressed ?? () => _pressionarNumero(texto),
          child: Text(
            texto,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora Flutter'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
              child: Text(
                _resultado,
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  _buildBotao('7'),
                  _buildBotao('8'),
                  _buildBotao('9'),
                  _buildBotao('/', color: Colors.orange.shade800, onPressed: () => _pressionarOperacao('/')),
                ],
              ),
              Row(
                children: [
                  _buildBotao('4'),
                  _buildBotao('5'),
                  _buildBotao('6'),
                  _buildBotao('*', color: Colors.orange.shade800, onPressed: () => _pressionarOperacao('*')),
                ],
              ),
              Row(
                children: [
                  _buildBotao('1'),
                  _buildBotao('2'),
                  _buildBotao('3'),
                  _buildBotao('-', color: Colors.orange.shade800, onPressed: () => _pressionarOperacao('-')),
                ],
              ),
              Row(
                children: [
                  _buildBotao('C', color: Colors.red.shade700, onPressed: _limpar),
                  _buildBotao('0'),
                  _buildBotao('=', color: Colors.deepPurple, onPressed: _calcular),
                  _buildBotao('+', color: Colors.orange.shade800, onPressed: () => _pressionarOperacao('+')),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}