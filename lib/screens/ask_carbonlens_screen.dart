import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/glass_card.dart';
import '../core/gemini_service.dart';

class AskCarbonLensScreen extends StatefulWidget {
  const AskCarbonLensScreen({super.key});

  @override
  State<AskCarbonLensScreen> createState() => _AskCarbonLensScreenState();
}

class _AskCarbonLensScreenState extends State<AskCarbonLensScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  final List<String> _suggestedPrompts = [
    "Should I buy an EV?",
    "Is solar worth it for me?",
    "How do I reach Grade A+?",
    "What is my biggest carbon leak?",
  ];

  Future<void> _sendMessage(String query) async {
    if (query.trim().isEmpty) return;
    
    setState(() {
      _messages.add({"role": "user", "text": query});
      _isLoading = true;
    });
    
    _controller.clear();

    final response = await GeminiService.askCarbonLens(query);

    if (mounted) {
      setState(() {
        _messages.add({"role": "ai", "text": response ?? "Sorry, I couldn't process that request."});
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ask CarbonLens'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/dashboard');
            }
          },
        ),
      ),
      body: Column(
        children: [
          if (_messages.isEmpty)
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.auto_awesome, color: Colors.greenAccent, size: 64),
                      const SizedBox(height: 16),
                      const Text('Your Personal Sustainability Advisor', style: TextStyle(fontSize: 18, color: Colors.white)),
                      const SizedBox(height: 32),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: _suggestedPrompts.map((prompt) {
                          return ActionChip(
                            backgroundColor: Colors.white.withValues(alpha: 0.1),
                            side: BorderSide(color: Colors.greenAccent.withValues(alpha: 0.3)),
                            label: Text(prompt, style: const TextStyle(color: Colors.greenAccent)),
                            onPressed: () => _sendMessage(prompt),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  final isUser = msg["role"] == "user";
                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                      child: GlassCard(
                        padding: const EdgeInsets.all(16),
                        child: Text(msg["text"]!, style: TextStyle(color: isUser ? Colors.white : Colors.greenAccent)),
                      ),
                    ),
                  );
                },
              ),
            ),
          
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(color: Colors.greenAccent),
            ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Ask anything...',
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.1),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: () => _sendMessage(_controller.text),
                  backgroundColor: Colors.greenAccent,
                  child: const Icon(Icons.send, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
