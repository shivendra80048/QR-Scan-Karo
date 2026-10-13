import 'dart:io';
import 'dart:ui' show ImageByteFormat;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../app_constants.dart';
import '../services/scan_history.dart';
import '../widgets/generator_option.dart';

class GeneratorScreen extends StatefulWidget {
  const GeneratorScreen({super.key});
  @override
  State<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen> {
  final input = TextEditingController();
  final ssid = TextEditingController();
  final password = TextEditingController();
  final email = TextEditingController();
  String mode = 'Text';
  String? generated;
  final modes = const [
    ('Text', Icons.text_fields_rounded),
    ('URL', Icons.link_rounded),
    ('Wi-Fi', Icons.wifi_rounded),
    ('Email', Icons.email_outlined),
  ];
  @override
  void dispose() {
    input.dispose();
    ssid.dispose();
    password.dispose();
    email.dispose();
    super.dispose();
  }

  String get payload {
    if (mode == 'Wi-Fi')
      return 'WIFI:T:WPA;S:${ssid.text};P:${password.text};;';
    if (mode == 'Email') return 'mailto:${email.text}?subject=Hello';
    if (mode == 'URL' &&
        input.text.trim().isNotEmpty &&
        !input.text.trim().contains('://'))
      return 'https://${input.text.trim()}';
    return input.text.trim();
  }

  Future<Uint8List?> _png() async {
    if (generated == null) return null;
    final painter = QrPainter(
      data: generated!,
      version: QrVersions.auto,
      gapless: true,
      color: AppColors.ink,
      emptyColor: Colors.white,
    );
    final image = await painter.toImage(900);
    final bytes = await image.toByteData(format: ImageByteFormat.png);
    return bytes?.buffer.asUint8List();
  }

  Future<void> _save() async {
    final bytes = await _png();
    if (bytes == null) return;
    final dir = await getApplicationDocumentsDirectory();
    final file = File(
      '${dir.path}/qr_${DateTime.now().millisecondsSinceEpoch}.png',
    );
    await file.writeAsBytes(bytes);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('QR saved inside app documents: ${file.path}')),
    );
  }

  Future<void> _share() async {
    final bytes = await _png();
    if (bytes == null) return;
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/qr_nova.png');
    await file.writeAsBytes(bytes);
    await SharePlus.instance.share(
      ShareParams(
        text: 'QR code created with QR Scan Karo',
        files: [XFile(file.path)],
      ),
    );
  }

  void _generate() {
    if (payload.trim().isEmpty ||
        (mode == 'Wi-Fi' && ssid.text.trim().isEmpty) ||
        (mode == 'Email' && email.text.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the required details')),
      );
      return;
    }
    setState(() => generated = payload);
    ScanHistory.instance.add(payload, generated: true);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Generate QR')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Create your QR code',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Choose a type and enter the information.',
          style: TextStyle(color: AppColors.muted),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            for (var i = 0; i < modes.length; i++) ...[
              if (i > 0) const SizedBox(width: 8),
              Expanded(
                child: GeneratorOption(
                  label: modes[i].$1,
                  icon: modes[i].$2,
                  selected: mode == modes[i].$1,
                  onTap: () => setState(() {
                    mode = modes[i].$1;
                    generated = null;
                  }),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 20),
        if (mode == 'Wi-Fi') ...[
          _field(ssid, 'Wi-Fi network name (SSID)', Icons.wifi),
          const SizedBox(height: 12),
          _field(password, 'Wi-Fi password', Icons.lock_outline, obscure: true),
        ] else if (mode == 'Email')
          _field(
            email,
            'Email address',
            Icons.email_outlined,
            keyboard: TextInputType.emailAddress,
          )
        else
          _field(
            input,
            mode == 'URL' ? 'Website URL' : 'Enter text',
            mode == 'URL' ? Icons.link : Icons.text_fields,
            maxLines: mode == 'Text' ? 3 : 1,
          ),
        const SizedBox(height: 18),
        SizedBox(
          height: 52,
          child: FilledButton.icon(
            onPressed: _generate,
            icon: const Icon(Icons.auto_awesome_rounded),
            label: const Text('Generate QR code'),
          ),
        ),
        if (generated != null) ...[
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                const Text(
                  'Your QR code is ready',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 18),
                QrImageView(
                  data: generated!,
                  version: QrVersions.auto,
                  size: 230,
                  backgroundColor: Colors.white,
                ),
                const SizedBox(height: 12),
                Text(
                  generated!,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _save,
                        icon: const Icon(Icons.save_alt_rounded),
                        label: const Text('Save'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _share,
                        icon: const Icon(Icons.share_rounded),
                        label: const Text('Share'),
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: generated!));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('QR content copied')),
                    );
                  },
                  icon: const Icon(Icons.copy_rounded),
                  label: const Text('Copy content'),
                ),
              ],
            ),
          ),
        ],
      ],
    ),
  );
  Widget _field(
    TextEditingController c,
    String hint,
    IconData icon, {
    bool obscure = false,
    int maxLines = 1,
    TextInputType? keyboard,
  }) => TextField(
    controller: c,
    obscureText: obscure,
    maxLines: maxLines,
    keyboardType: keyboard,
    decoration: InputDecoration(
      prefixIcon: Icon(icon, color: AppColors.purple),
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: const BorderSide(color: AppColors.border),
      ),
    ),
  );
}
