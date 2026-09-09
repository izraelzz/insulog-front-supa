import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insulog/services/local/api_ip_service.dart';

class ConfigIpButtonWidget extends StatelessWidget {
  const ConfigIpButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _showConfigIpDialog(context),
      tooltip: 'Configurar IP',
      style: IconButton.styleFrom(
        backgroundColor: Colors.black.withOpacity(0.08),
        foregroundColor: Colors.black.withOpacity(0.35),
        hoverColor: Colors.black.withOpacity(0.12),
        highlightColor: Colors.black.withOpacity(0.10),
      ),
      icon: const Icon(Icons.settings),
    );
  }

  Future<void> _showConfigIpDialog(BuildContext context) async {
    final apiIpService = ApiIpService();
    final savedDigits = await apiIpService.getApiIpDigits();

    if (!context.mounted) {
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (_) => _ConfigIpDialog(
        apiIpService: apiIpService,
        initialDigits: savedDigits,
      ),
    );
  }
}

class _ConfigIpDialog extends StatefulWidget {
  final ApiIpService apiIpService;
  final String initialDigits;

  const _ConfigIpDialog({
    required this.apiIpService,
    required this.initialDigits,
  });

  @override
  State<_ConfigIpDialog> createState() => _ConfigIpDialogState();
}

class _ConfigIpDialogState extends State<_ConfigIpDialog> {
  late final TextEditingController _controller;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ApiIpService.isValidIp(widget.initialDigits)
          ? widget.initialDigits
          : ApiIpService.formatDigitsAsIp(widget.initialDigits) ??
                widget.initialDigits,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Configuracao de IP'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Digite o endereco IP completo, incluindo os pontos.',
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              LengthLimitingTextInputFormatter(15),
            ],
            decoration: InputDecoration(
              labelText: 'IP da API',
              hintText: 'Ex: 10.173.57.47',
              errorText: _errorMessage,
              border: const OutlineInputBorder(),
            ),
            onChanged: (_) {
              if (_errorMessage == null) {
                return;
              }

              setState(() {
                _errorMessage = null;
              });
            },
          ),
          const SizedBox(height: 8),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (context, value, _) {
              final ip = value.text.trim();

              return Text(
                ApiIpService.isValidIp(ip)
                    ? 'Rota: http://$ip:3000'
                    : 'Exemplo: 192.168.31.41',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.55),
                  fontSize: 12,
                ),
              );
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        TextButton(onPressed: _saveIp, child: const Text('Salvar')),
      ],
    );
  }

  Future<void> _saveIp() async {
    final ip = _controller.text.trim();

    if (!ApiIpService.isValidIp(ip)) {
      setState(() {
        _errorMessage = 'Digite um IP valido. Ex: 192.168.31.41';
      });
      return;
    }

    await widget.apiIpService.saveApiIpDigits(ip);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

}
