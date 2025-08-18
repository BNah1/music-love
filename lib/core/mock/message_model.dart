class ConversationMessage {
  final int id;
  final int senderId;
  final String content;
  final String sentAt;
  final String senderName;
  final bool isRead;

  const ConversationMessage({
    this.id = 0,
    this.senderId = 0,
    this.content = '',
    this.sentAt = '',
    this.senderName = '',
    this.isRead = false,
  });

  factory ConversationMessage.fromJson(Map<String, dynamic> json) {
    final sender = json['sender'] as Map<String, dynamic>?; // có thể null
    final resident = sender?['resident'] as Map<String, dynamic>?;

    return ConversationMessage(
      id: _toInt(json['id']),
      senderId: _toInt(sender?['id']),
      content: json['content']?.toString() ?? '',
      sentAt: json['sentAt']?.toString() ?? '',
      senderName: resident?['name']?.toString() ?? '',
      isRead: json['isRead'] == true,
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': {
        'id': senderId,
        'resident': {'name': senderName},
      },
      'content': content,
      'sentAt': sentAt,
      'isRead': isRead,
    };
  }
}