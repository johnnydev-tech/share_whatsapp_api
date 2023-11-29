import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:url_launcher/url_launcher_string.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WhatsApp API',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'WhatsApp API'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  final _key = GlobalKey<FormState>();
  final maskWhatsappBR = MaskTextInputFormatter(
    mask: '(##) #####-####',
  );

  String? validateWhatsapp(String? value) {
    var normalizedPhone = value;
    normalizedPhone = normalizedPhone?.replaceAll('(', '');
    normalizedPhone = normalizedPhone?.replaceAll(')', '');
    normalizedPhone = normalizedPhone?.replaceAll('-', '');
    normalizedPhone = normalizedPhone?.replaceAll(' ', '');

    if (normalizedPhone?.length != 11) {
      return 'Número de telefone inválido';
    }

    if (value == null || value.isEmpty) {
      return 'Digite o número do whatsapp';
    }
    return null;
  }

  void _openWhats() async {
    if (_key.currentState!.validate()) {
      final String phone = _controller.text;
      var normalizedPhone = phone.replaceAll('(', '');
      normalizedPhone = normalizedPhone.replaceAll(')', '');
      normalizedPhone = normalizedPhone.replaceAll('-', '');
      normalizedPhone = normalizedPhone.replaceAll(' ', '');

      final String url = 'https://wa.me/55$normalizedPhone';
      if (await canLaunchUrlString(url)) {
        launchUrlString(url);
      } else {
        var snackBar = const SnackBar(
          content: Text('Não foi possível abrir o WhatsApp'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      var snackBar = const SnackBar(
        content: Text('Número de telefone inválido'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.message),
            const SizedBox(width: 8),
            Text(widget.title),
          ],
        ),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        var isSmall = constraints.maxWidth < 600;

        return Form(
          key: _key,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: isSmall
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(
                  children: [
                    const Text(
                      'Digite o número do whatsapp',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _controller,
                      inputFormatters: [maskWhatsappBR],
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: '(00) 00000-0000',
                      ),
                      validator: validateWhatsapp,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      padding: const EdgeInsets.all(20),
                    ),
                    onPressed: () {
                      _openWhats();
                    },
                    child: const Text('Enviar mensagem'),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
