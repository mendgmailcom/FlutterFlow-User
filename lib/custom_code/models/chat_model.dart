class ChatModel {
  final String id;
  final String bookingId;
  final String userId;
  final String userName;
  final String userAvatar;
  final String providerId;
  final String providerName;
  final String providerAvatar;
  final List<ChatMessageModel> messages;
  final int unreadCount;
  final bool isOnline;
  final DateTime lastMessageAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatModel({
    required this.id,
    required this.bookingId,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.providerId,
    required this.providerName,
    required this.providerAvatar,
    required this.messages,
    required this.unreadCount,
    required this.isOnline,
    required this.lastMessageAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'] as String,
      bookingId: json['bookingId'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userAvatar: json['userAvatar'] as String,
      providerId: json['providerId'] as String,
      providerName: json['providerName'] as String,
      providerAvatar: json['providerAvatar'] as String,
      messages: List<ChatMessageModel>.from(
        (json['messages'] as List<dynamic>? ?? [])
            .map((x) => ChatMessageModel.fromJson(x as Map<String, dynamic>)),
      ),
      unreadCount: json['unreadCount'] as int? ?? 0,
      isOnline: json['isOnline'] as bool? ?? false,
      lastMessageAt: DateTime.parse(json['lastMessageAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookingId': bookingId,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'providerId': providerId,
      'providerName': providerName,
      'providerAvatar': providerAvatar,
      'messages': messages.map((x) => x.toJson()).toList(),
      'unreadCount': unreadCount,
      'isOnline': isOnline,
      'lastMessageAt': lastMessageAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class ChatMessageModel {
  final String id;
  final String chatId;
  final String senderId;
  final String senderName;
  final String senderAvatar;
  final String content;
  final List<String> attachments;
  final bool isRead;
  final DateTime sentAt;
  final DateTime? readAt;

  ChatMessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.senderName,
    required this.senderAvatar,
    required this.content,
    required this.attachments,
    required this.isRead,
    required this.sentAt,
    this.readAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String,
      chatId: json['chatId'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      senderAvatar: json['senderAvatar'] as String,
      content: json['content'] as String,
      attachments: List<String>.from(json['attachments'] ?? []),
      isRead: json['isRead'] as bool? ?? false,
      sentAt: DateTime.parse(json['sentAt'] as String),
      readAt: json['readAt'] != null
          ? DateTime.parse(json['readAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'senderName': senderName,
      'senderAvatar': senderAvatar,
      'content': content,
      'attachments': attachments,
      'isRead': isRead,
      'sentAt': sentAt.toIso8601String(),
      'readAt': readAt?.toIso8601String(),
    };
  }
}

class ChatPreview {
  final String id;
  final String chatPartnerId;
  final String chatPartnerName;
  final String chatPartnerAvatar;
  final String lastMessage;
  final DateTime lastMessageAt;
  final int unreadCount;
  final bool isOnline;
  final String bookingId;

  ChatPreview({
    required this.id,
    required this.chatPartnerId,
    required this.chatPartnerName,
    required this.chatPartnerAvatar,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.unreadCount,
    required this.isOnline,
    required this.bookingId,
  });

  factory ChatPreview.fromJson(Map<String, dynamic> json) {
    return ChatPreview(
      id: json['id'] as String,
      chatPartnerId: json['chatPartnerId'] as String,
      chatPartnerName: json['chatPartnerName'] as String,
      chatPartnerAvatar: json['chatPartnerAvatar'] as String,
      lastMessage: json['lastMessage'] as String,
      lastMessageAt: DateTime.parse(json['lastMessageAt'] as String),
      unreadCount: json['unreadCount'] as int? ?? 0,
      isOnline: json['isOnline'] as bool? ?? false,
      bookingId: json['bookingId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatPartnerId': chatPartnerId,
      'chatPartnerName': chatPartnerName,
      'chatPartnerAvatar': chatPartnerAvatar,
      'lastMessage': lastMessage,
      'lastMessageAt': lastMessageAt.toIso8601String(),
      'unreadCount': unreadCount,
      'isOnline': isOnline,
      'bookingId': bookingId,
    };
  }
}

class TypingIndicator {
  final String userId;
  final String userName;
  final bool isTyping;
  final DateTime lastTypedAt;

  TypingIndicator({
    required this.userId,
    required this.userName,
    required this.isTyping,
    required this.lastTypedAt,
  });

  factory TypingIndicator.fromJson(Map<String, dynamic> json) {
    return TypingIndicator(
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      isTyping: json['isTyping'] as bool? ?? false,
      lastTypedAt: DateTime.parse(json['lastTypedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'isTyping': isTyping,
      'lastTypedAt': lastTypedAt.toIso8601String(),
    };
  }
}
