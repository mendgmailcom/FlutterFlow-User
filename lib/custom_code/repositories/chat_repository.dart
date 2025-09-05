import 'dart:async';
import 'dart:math';
import '../../custom_code/models/index.dart' as models;

class ChatRepository {
  // In a real app, this would connect to an API or WebSocket
  // For demo, we'll simulate API calls with delays

  // Get all chats for user
  Future<List<models.ChatPreview>> getUserChats({int limit = 50}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));

    // Generate mock chat previews
    final List<models.ChatPreview> chats = [];

    for (int i = 0; i < limit; i++) {
      final lastMessageTime = DateTime.now().subtract(Duration(
        minutes: Random().nextInt(60 * 24 * 7), // Up to 7 days ago
      ));

      chats.add(models.ChatPreview(
        id: 'chat_$i',
        chatPartnerId: 'partner_$i',
        chatPartnerName: 'Service Provider ${i + 1}',
        chatPartnerAvatar: 'https://picsum.photos/100/100?random=provider_$i',
        lastMessage: [
          'Hello! How can I help you today?',
          'Your appointment is confirmed for tomorrow.',
          'Thank you for choosing our service!',
          'I\'ll arrive at the scheduled time.',
          'Is there anything else you need?',
          'The service will be completed in 2 hours.',
          'Please prepare the area for service.',
          'We appreciate your business!'
        ][Random().nextInt(8)],
        lastMessageAt: lastMessageTime,
        unreadCount: i % 3 == 0 ? Random().nextInt(5) : 0,
        isOnline: Random().nextBool(),
        bookingId: 'booking_$i',
      ));
    }

    // Sort by last message time (newest first)
    chats.sort((a, b) => b.lastMessageAt.compareTo(a.lastMessageAt));

    return chats;
  }

  // Get chat by ID
  Future<models.ChatModel?> getChatById(String chatId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Generate mock chat
    final now = DateTime.now();

    return models.ChatModel(
      id: chatId,
      bookingId: 'booking_${chatId.split('_').last}',
      userId: 'user_current',
      userName: 'Current User',
      userAvatar: 'https://picsum.photos/100/100?random=current_user',
      providerId: 'provider_${chatId.split('_').last}',
      providerName: 'Provider ${chatId.split('_').last}',
      providerAvatar:
          'https://picsum.photos/100/100?random=provider_${chatId.split('_').last}',
      messages: List.generate(15 + Random().nextInt(20), (index) {
        final isUserMessage = Random().nextBool();
        final messageTime = now.subtract(Duration(
          minutes: Random().nextInt(60 * 24), // Up to 24 hours ago
        ));

        return models.ChatMessageModel(
          id: 'message_${chatId}_$index',
          chatId: chatId,
          senderId: isUserMessage
              ? 'user_current'
              : 'provider_${chatId.split('_').last}',
          senderName: isUserMessage
              ? 'Current User'
              : 'Provider ${chatId.split('_').last}',
          senderAvatar: isUserMessage
              ? 'https://picsum.photos/50/50?random=current_user'
              : 'https://picsum.photos/50/50?random=provider_${chatId.split('_').last}',
          content: [
            'Hello! How can I help you today?',
            'I need some information about the service.',
            'Your appointment is confirmed for tomorrow.',
            'Thank you for choosing our service!',
            'I\'ll arrive at the scheduled time.',
            'Is there anything else you need?',
            'The service will be completed in 2 hours.',
            'Please prepare the area for service.',
            'We appreciate your business!',
            'Can you send me the service details?',
            'I have a question about the pricing.',
            'When will the technician arrive?',
            'The service looks great!',
            'Thank you for the wonderful service.',
            'I recommend your service to others.'
          ][Random().nextInt(15)],
          attachments: Random().nextBool()
              ? [
                  'https://picsum.photos/200/200?random=message_attachment_${chatId}_$index',
                ]
              : [],
          isRead: index < 10, // Last 10 messages are read
          sentAt: messageTime,
          readAt:
              index < 10 ? messageTime.add(const Duration(minutes: 1)) : null,
        );
      }),
      unreadCount: Random().nextInt(5),
      isOnline: Random().nextBool(),
      lastMessageAt: now.subtract(Duration(minutes: Random().nextInt(60))),
      createdAt: now.subtract(Duration(hours: Random().nextInt(24))),
      updatedAt: now,
    );
  }

  // Send message
  Future<models.ChatMessageModel> sendMessage(String chatId, String content,
      {List<String>? attachments}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Generate mock sent message
    final now = DateTime.now();

    return models.ChatMessageModel(
      id: 'message_sent_${Random().nextInt(1000000)}',
      chatId: chatId,
      senderId: 'user_current',
      senderName: 'Current User',
      senderAvatar: 'https://picsum.photos/50/50?random=current_user',
      content: content,
      attachments: attachments ?? [],
      isRead: false,
      sentAt: now,
      readAt: null,
    );
  }

  // Mark messages as read
  Future<bool> markMessagesAsRead(
      String chatId, List<String> messageIds) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));

    // In a real app, this would make an API call
    // For demo, we'll just return success
    return true;
  }

  // Get unread message count
  Future<int> getUnreadMessageCount() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Generate mock unread count
    return Random().nextInt(20);
  }

  // Get chat messages with pagination
  Future<List<models.ChatMessageModel>> getChatMessages(String chatId,
      {int page = 1, int limit = 50}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));

    // Generate mock messages
    final List<models.ChatMessageModel> messages = [];
    final now = DateTime.now();

    for (int i = 0; i < limit; i++) {
      final messageIndex = (page - 1) * limit + i;
      final isUserMessage = Random().nextBool();
      final providerId = chatId.split('_').last;
      final messageTime = now.subtract(Duration(
        minutes: messageIndex * 5, // 5 minutes apart
      ));

      messages.add(models.ChatMessageModel(
        id: 'message_${chatId}_$messageIndex',
        chatId: chatId,
        senderId: isUserMessage ? 'user_current' : 'provider_$providerId',
        senderName: isUserMessage ? 'Current User' : 'Provider $providerId',
        senderAvatar: isUserMessage
            ? 'https://picsum.photos/50/50?random=user_avatar_$messageIndex'
            : 'https://picsum.photos/50/50?random=provider_avatar_$messageIndex',
        content: [
          'Hello! How can I help you today?',
          'I need some information about the service.',
          'Your appointment is confirmed for tomorrow.',
          'Thank you for choosing our service!',
          'I\'ll arrive at the scheduled time.',
          'Is there anything else you need?',
          'The service will be completed in 2 hours.',
          'Please prepare the area for service.',
          'We appreciate your business!',
          'Can you send me the service details?',
          'I have a question about the pricing.',
          'When will the technician arrive?',
          'The service looks great!',
          'Thank you for the wonderful service.',
          'I recommend your service to others.',
          'Could you please clarify something?',
          'I have a special request for the service.',
          'What are your working hours?',
          'Do you offer any discounts?',
          'The previous service was excellent.'
        ][Random().nextInt(20)],
        attachments: Random().nextBool() && Random().nextBool()
            ? [
                'https://picsum.photos/200/200?random=attachment_${chatId}_$messageIndex',
              ]
            : [],
        isRead: i < limit - 5, // Last 5 messages are unread
        sentAt: messageTime,
        readAt: i < limit - 5
            ? messageTime.add(Duration(minutes: Random().nextInt(5)))
            : null,
      ));
    }

    // Sort by sent time (oldest first)
    messages.sort((a, b) => a.sentAt.compareTo(b.sentAt));

    return messages;
  }

  // Get typing indicators
  Stream<models.TypingIndicator> getTypingIndicators(String chatId) {
    return Stream.periodic(const Duration(seconds: 5), (count) {
      return models.TypingIndicator(
        userId: 'provider_${chatId.split('_').last}',
        userName: 'Provider ${chatId.split('_').last}',
        isTyping: Random().nextBool(),
        lastTypedAt: DateTime.now(),
      );
    });
  }

  // Send typing indicator
  Future<void> sendTypingIndicator(String chatId, bool isTyping) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 100));

    // In a real app, this would send a WebSocket message or API call
    // For demo, we'll just complete successfully
  }

  // Get online status
  Stream<bool> getOnlineStatus(String userId) {
    return Stream.periodic(const Duration(seconds: 30), (count) {
      return Random().nextBool();
    });
  }

  // Create new chat
  Future<models.ChatModel> createChat(
      String bookingId, String providerId) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Generate mock new chat
    final now = DateTime.now();
    final chatId = 'chat_new_${Random().nextInt(1000000)}';

    return models.ChatModel(
      id: chatId,
      bookingId: bookingId,
      userId: 'user_current',
      userName: 'Current User',
      userAvatar: 'https://picsum.photos/100/100?random=current_user',
      providerId: providerId,
      providerName: 'New Provider',
      providerAvatar: 'https://picsum.photos/100/100?random=new_provider',
      messages: [
        models.ChatMessageModel(
          id: 'message_welcome_$chatId',
          chatId: chatId,
          senderId: providerId,
          senderName: 'New Provider',
          senderAvatar: 'https://picsum.photos/50/50?random=new_provider',
          content:
              'Hello! Thank you for booking our service. How can I assist you today?',
          attachments: [],
          isRead: false,
          sentAt: now,
          readAt: null,
        ),
      ],
      unreadCount: 1,
      isOnline: true,
      lastMessageAt: now,
      createdAt: now,
      updatedAt: now,
    );
  }

  // Get recent chats
  Future<List<models.ChatPreview>> getRecentChats({int limit = 10}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));

    // Generate mock recent chats
    final List<models.ChatPreview> chats = [];
    final now = DateTime.now();

    for (int i = 0; i < limit; i++) {
      final lastMessageTime = now.subtract(Duration(
        minutes: Random().nextInt(60 * 24), // Up to 24 hours ago
      ));

      chats.add(models.ChatPreview(
        id: 'recent_chat_$i',
        chatPartnerId: 'recent_partner_$i',
        chatPartnerName: 'Recent Provider ${i + 1}',
        chatPartnerAvatar:
            'https://picsum.photos/100/100?random=recent_provider_$i',
        lastMessage: [
          'Hello! Looking forward to serving you.',
          'Your booking is confirmed. See you soon!',
          'Thank you for your recent booking.',
          'We\'ll contact you before arrival.',
          'Is there anything special for the service?'
        ][Random().nextInt(5)],
        lastMessageAt: lastMessageTime,
        unreadCount: i % 4 == 0 ? Random().nextInt(3) : 0,
        isOnline: Random().nextBool(),
        bookingId: 'recent_booking_$i',
      ));
    }

    // Sort by last message time (newest first)
    chats.sort((a, b) => b.lastMessageAt.compareTo(a.lastMessageAt));

    return chats;
  }

  // Search chats
  Future<List<models.ChatPreview>> searchChats(String query,
      {int limit = 20}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Generate mock search results
    final List<models.ChatPreview> chats = [];
    final now = DateTime.now();

    for (int i = 0; i < min(limit, 10); i++) {
      final lastMessageTime = now.subtract(Duration(
        minutes: Random().nextInt(60 * 24 * 3), // Up to 3 days ago
      ));

      chats.add(models.ChatPreview(
        id: 'search_chat_$i',
        chatPartnerId: 'search_partner_$i',
        chatPartnerName: '$query Provider ${i + 1}',
        chatPartnerAvatar:
            'https://picsum.photos/100/100?random=search_provider_$i',
        lastMessage: 'Search result message about $query',
        lastMessageAt: lastMessageTime,
        unreadCount: Random().nextInt(3),
        isOnline: Random().nextBool(),
        bookingId: 'search_booking_$i',
      ));
    }

    return chats;
  }

  // Get chat attachment
  Future<String?> getChatAttachment(
      String messageId, String attachmentId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Generate mock attachment URL
    return 'https://picsum.photos/400/400?random=attachment_${messageId}_$attachmentId';
  }

  // Delete message
  Future<bool> deleteMessage(String messageId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));

    // In a real app, this would make an API call
    // For demo, we'll just return success
    return true;
  }

  // Edit message
  Future<models.ChatMessageModel> editMessage(
      String messageId, String newContent) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // In a real app, this would make an API call
    // For demo, we'll generate a mock updated message
    final now = DateTime.now();

    return models.ChatMessageModel(
      id: messageId,
      chatId: 'chat_demo',
      senderId: 'user_current',
      senderName: 'Current User',
      senderAvatar: 'https://picsum.photos/50/50?random=current_user',
      content: newContent,
      attachments: [],
      isRead: true,
      sentAt: now.subtract(const Duration(minutes: 5)),
      readAt: now,
    );
  }
}
