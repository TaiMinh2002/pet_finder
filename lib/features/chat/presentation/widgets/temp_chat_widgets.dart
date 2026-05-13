// Temporary placeholder widgets for chat functionality
// These will be replaced with proper implementations later

import 'package:flutter/material.dart';

class ChatScaffold extends StatelessWidget {
  const ChatScaffold({required this.child, super.key, this.bottomNav = true});

  final Widget child;
  final bool bottomNav;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: child);
  }
}

class ChatHeader extends StatelessWidget {
  const ChatHeader({
    required this.title,
    required this.subtitle,
    this.leading,
    this.trailing,
    super.key,
  });

  final String title;
  final String subtitle;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class CircleGlassButton extends StatelessWidget {
  const CircleGlassButton({required this.icon, required this.onTap, super.key});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: onTap, icon: Icon(icon));
  }
}

class ChatHeroCard extends StatelessWidget {
  const ChatHeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Text('Chat Hero Card - Coming Soon'),
    );
  }
}

class ChatEmptyCard extends StatelessWidget {
  const ChatEmptyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: const Column(
        children: [
          Icon(Icons.chat_bubble_outline, size: 64),
          SizedBox(height: 16),
          Text('No conversations yet', textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class ChatConversationTile extends StatelessWidget {
  const ChatConversationTile({required this.chat, super.key});

  final dynamic chat; // Placeholder for old ChatModel

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      title: Text('Conversation'),
      subtitle: Text('Coming soon...'),
      trailing: Icon(Icons.chevron_right),
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({required this.message, super.key});

  final dynamic message; // Placeholder for old ChatMessageModel

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Text('Message bubble'),
    );
  }
}

class ChatDetailHeaderCard extends StatelessWidget {
  const ChatDetailHeaderCard({
    required this.chat,
    required this.onOpenActions,
    super.key,
  });

  final dynamic chat;
  final VoidCallback onOpenActions;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Text('Chat Detail Header'),
    );
  }
}

class QuickActionStrip extends StatelessWidget {
  const QuickActionStrip({
    required this.onShareLocation,
    required this.onSendPhoto,
    required this.onCall,
    required this.onViewReport,
    super.key,
  });

  final VoidCallback onShareLocation;
  final VoidCallback onSendPhoto;
  final VoidCallback onCall;
  final VoidCallback onViewReport;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: onShareLocation,
          icon: const Icon(Icons.location_on),
        ),
        IconButton(onPressed: onSendPhoto, icon: const Icon(Icons.photo)),
        IconButton(onPressed: onCall, icon: const Icon(Icons.call)),
        IconButton(onPressed: onViewReport, icon: const Icon(Icons.report)),
      ],
    );
  }
}

class ChatComposer extends StatelessWidget {
  const ChatComposer({
    required this.controller,
    required this.isSending,
    required this.onSend,
    super.key,
  });

  final TextEditingController controller;
  final bool isSending;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            onPressed: isSending ? null : onSend,
            icon: isSending
                ? const CircularProgressIndicator()
                : const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
