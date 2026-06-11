import 'package:flutter/material.dart';

/// A single chat bubble.
class ChatMessage {
  final String id;
  final String senderName;
  final String text;
  final DateTime timestamp;
  final bool isMe;

  const ChatMessage({
    required this.id,
    required this.senderName,
    required this.text,
    required this.timestamp,
    required this.isMe,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'senderName': senderName,
        'text': text,
        'timestamp': timestamp.toIso8601String(),
        'isMe': isMe,
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json['id'] as String,
        senderName: json['senderName'] as String,
        text: json['text'] as String,
        timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ??
            DateTime.now(),
        isMe: json['isMe'] as bool? ?? false,
      );
}

/// A 1:1 or group conversation.
class Conversation {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isGroup;
  final String? clubId;
  final List<ChatMessage> messages;

  Conversation({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.isGroup = false,
    this.clubId,
    List<ChatMessage>? messages,
  }) : messages = messages ?? [];

  ChatMessage? get lastMessage =>
      messages.isEmpty ? null : messages.last;
}
