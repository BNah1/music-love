import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:musiclove/core/extension/date_time_extension.dart';
import 'package:musiclove/core/mock/message_model.dart';

class MessageUtils {
  static String getTimeMessageFromNow(String isoTime) {
    final now = DateTime.now();
    final messageTime = DateTime.parse(isoTime);
    final diff = now.difference(messageTime);

    if (diff.inMinutes < 60) {
      // Chỉ lấy các mốc 5 - 10 - 30
      if (diff.inMinutes < 5) return "5 minutes ";
      if (diff.inMinutes < 10) return "10 minutes ";
      if (diff.inMinutes < 30) return "30 minutes ";
      return "less than 1 hour ago";
    } else if (diff.inHours < 24) {
      return "${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago";
    } else if (diff.inDays < 30) {
      return "${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago";
    } else {
      final months = (diff.inDays / 30).floor();
      return "$months month${months > 1 ? 's' : ''} ago";
    }
  }

  static String getTimeMessage(String isoTime) {
    final messageTime = DateTime.parse(isoTime);
    final hour = messageTime.hour.toString().padLeft(2, '0');
    final minute = messageTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static Color getBackgroundColor(EnumMessageType type, BuildContext context) {
    Color color = Theme.of(context).primaryColor.withOpacity(0.2);
    if (type == EnumMessageType.receive) color = Colors.white;
    return color;
  }

  static bool checkLastMessageInLine(
    List<ConversationMessage> list,
    ConversationMessage message,
  ) {
    final id = message.id;
    final index = list.indexWhere((e) => e.id == id);

    /// k tồn tại
    if (index == -1) return false;

    /// message cuối cùng
    if (index == list.length - 1) return true;

    ///xet1t trong line
    final nextMessage = list[index +1];


    return nextMessage.senderId != message.senderId;
  }

  static bool checkLastMessage(
    List<ConversationMessage> list,
    ConversationMessage message,
  ) {
    final id = message.id;
    final index = list.indexWhere((e) => e.id == id);
    if (index == list.length - 1) {
      return true;
    } else {
      return false;
    }
  }


  static bool checkIsFirstMessageInDay(
      List<ConversationMessage> list,
      ConversationMessage message,
      ) {
    final id = message.id;
    final index = list.indexWhere((e) => e.id == id);

    if (index == 0) return true;

    final prevMessage = list[index-1];

    final currentDate = DateTime.parse(message.sentAt);
    final prevDate = DateTime.parse(prevMessage.sentAt);

    return !currentDate.isSameDate(prevDate);
  }

  static String getTimeMessageFull(String isoTime) {
    final messageTime = DateTime.parse(isoTime);

    final hour = messageTime.hour.toString().padLeft(2, '0');
    final minute = messageTime.minute.toString().padLeft(2, '0');
    final day = messageTime.day.toString().padLeft(2, '0');
    final month = messageTime.month.toString().padLeft(2, '0');
    final year = messageTime.year.toString();

    return '$hour:$minute $day/$month/$year';
  }

  MessageUtils._();
}

enum EnumMessageType { send, receive }

enum EnumMessageStatus { read, unRead, none }
