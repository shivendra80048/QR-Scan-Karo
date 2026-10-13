import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../app_constants.dart';
import '../services/scan_history.dart';
import '../widgets/result_panel.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key, this.imagePath});
  final String? imagePath;
  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  late final MobileScannerController controller;
  String? result;
  bool handled = false;
  bool torch = false;
  bool imageMode = false;
  bool imageTried = false;
  @override
  void initState() {
    super.initState();
    controller = MobileScannerController();
    if (widget.imagePath != null) {
      imageMode = true;
      _analyzeImage();
    }
  }

  Future<void> _analyzeImage() async {
    try {
      final capture = await controller.analyzeImage(widget.imagePath!);
      final codes = capture?.barcodes ?? const <Barcode>[];
      final code = codes.isNotEmpty ? codes.first.rawValue : null;
      if (code != null && mounted) {
        _setResult(code);
      } else if (mounted)
        setState(() => imageTried = true);
    } catch (_) {
      if (mounted) setState(() => imageTried = true);
    }
  }

  void _setResult(String value) {
    if (handled) return;
    handled = true;
    ScanHistory.instance.add(value);
    setState(() => result = value);
    controller.stop();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(imageMode ? 'Scan QR image' : 'Scan QR code'),
      actions: [
        if (!imageMode)
          IconButton(
            onPressed: () async {
              await controller.toggleTorch();
              setState(() => torch = !torch);
            },
            icon: Icon(
              torch ? Icons.flash_on_rounded : Icons.flash_off_rounded,
            ),
          ),
        if (!imageMode)
          IconButton(
            onPressed: () => controller.switchCamera(),
            icon: const Icon(Icons.cameraswitch_rounded),
          ),
      ],
    ),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: const Color(0xFF18172B),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: imageMode
                    ? (result == null
                          ? Center(
                              child: imageTried
                                  ? const Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Text(
                                        'No QR code found in this image. Go back and try another image.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  : const CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                            )
                          : const Center(
                              child: Icon(
                                Icons.check_circle_outline,
                                color: Colors.white,
                                size: 70,
                              ),
                            ))
                    : Stack(
                        fit: StackFit.expand,
                        children: [
                          MobileScanner(
                            controller: controller,
                            onDetect: (capture) {
                              final code = capture.barcodes.isNotEmpty
                                  ? capture.barcodes.first.rawValue
                                  : null;
                              if (code != null) _setResult(code);
                            },
                          ),
                          Center(
                            child: IgnorePointer(
                              child: Container(
                                width: 245,
                                height: 245,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xFFBDB4FF),
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ),
                          ),
                          const Positioned(
                            left: 20,
                            right: 20,
                            bottom: 22,
                            child: Text(
                              'Align the QR code inside the frame',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 18),
            if (result != null)
              ResultPanel(
                value: result!,
                onCopy: () {
                  Clipboard.setData(ClipboardData(text: result!));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Result copied')),
                  );
                },
                onClose: () {
                  setState(() {
                    result = null;
                    handled = false;
                  });
                  controller.start();
                },
              )
            else
              const Text(
                'Point your camera at a QR code',
                style: TextStyle(color: AppColors.muted),
              ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    ),
  );
}
