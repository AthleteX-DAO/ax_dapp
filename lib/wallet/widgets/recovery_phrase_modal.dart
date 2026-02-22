import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RecoveryPhraseModal extends StatefulWidget {
  const RecoveryPhraseModal({
    super.key,
    required this.recoveryPhrase,
    required this.onConfirmed,
  });

  final String recoveryPhrase;
  final VoidCallback onConfirmed;

  @override
  State<RecoveryPhraseModal> createState() => _RecoveryPhraseModalState();
}

class _RecoveryPhraseModalState extends State<RecoveryPhraseModal> {
  bool _isConfirmed = false;
  bool _isCopied = false;

  @override
  Widget build(BuildContext context) {
    final words = widget.recoveryPhrase.split(' ');
    
    return Dialog(
      backgroundColor: const Color(0xFF1A1A2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Save Your Recovery Phrase',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Warning text
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFFFD700)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Color(0xFFFFD700), size: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Keep this phrase safe. Anyone with it can access your wallet.',
                        style: TextStyle(
                          color: Color(0xFFFFD700),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Recovery phrase grid (3 columns x 4 rows)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F0F1E),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF404060)),
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 3.5,
                  ),
                  itemCount: words.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0x1A4A5F9E),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: const Color(0xFF404060),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${index + 1}. ${words[index]}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontFamily: 'Courier',
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              
              // Copy button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _copyToClipboard,
                  icon: Icon(
                    _isCopied ? Icons.check : Icons.content_copy,
                    color: Colors.white,
                    size: 18,
                  ),
                  label: Text(
                    _isCopied ? 'Copied!' : 'Copy Phrase',
                    style: const TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A5F9E),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Confirmation checkbox
              GestureDetector(
                onTap: () {
                  setState(() => _isConfirmed = !_isConfirmed);
                },
                child: Row(
                  children: [
                    Checkbox(
                      value: _isConfirmed,
                      onChanged: (value) {
                        setState(() => _isConfirmed = value ?? false);
                      },
                      activeColor: const Color(0xFF4A5F9E),
                    ),
                    const Expanded(
                      child: Text(
                        'I have saved my recovery phrase in a safe place',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Confirm button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isConfirmed ? _handleConfirm : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isConfirmed
                        ? const Color(0xFF4A9F6F)
                        : const Color(0xFF404060),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    disabledForegroundColor: Colors.grey,
                  ),
                  child: const Text(
                    'I Have Saved My Phrase',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.recoveryPhrase));
    setState(() => _isCopied = true);
    
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isCopied = false);
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Recovery phrase copied to clipboard'),
        duration: Duration(seconds: 2),
        backgroundColor: Color(0xFF4A9F6F),
      ),
    );
  }

  void _handleConfirm() {
    Navigator.pop(context);
    widget.onConfirmed();
  }
}
