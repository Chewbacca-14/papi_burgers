import 'package:flutter/material.dart';

String getStatusText(OrderStatuses status) {
  switch (status) {
    case OrderStatuses.created:
      return 'Ожидание';
    case OrderStatuses.accepted:
      return 'Подтверждено';
    case OrderStatuses.preparing:
      return 'Готовится';
    case OrderStatuses.readyPickup:
      return 'Можно забирать';
    case OrderStatuses.readyDelivery:
      return 'Готово к доставке';
    case OrderStatuses.delivering:
      return 'Доставка';
    case OrderStatuses.delivered:
      return 'Доставлено';
    case OrderStatuses.completed:
      return 'Завершено';
    case OrderStatuses.cancelled:
      return 'Отменено';
    case OrderStatuses.error:
      return 'Ошибка';
    default:
      return '';
  }
}

Color getColorFromStatusText(OrderStatuses status) {
  switch (status) {
    case OrderStatuses.created:
      return Colors.red.shade300;
    case OrderStatuses.accepted:
      return Colors.green.shade300;
    case OrderStatuses.preparing:
      return Colors.blue.shade300;
    case OrderStatuses.readyPickup:
      return Colors.red.shade500;
    case OrderStatuses.readyDelivery:
      return Colors.green.shade500;
    case OrderStatuses.delivering:
      return Colors.blue.shade500;
    case OrderStatuses.delivered:
      return Colors.red.shade700;
    case OrderStatuses.completed:
      return Colors.green.shade700;
    case OrderStatuses.cancelled:
      return Colors.blue.shade700;
    case OrderStatuses.error:
      return Colors.grey;
    default:
      return Colors.transparent;
  }
}

IconData getIconDataFromStatusText(OrderStatuses status) {
  switch (status) {
    case OrderStatuses.created:
      return Icons.timer;
    case OrderStatuses.accepted:
      return Icons.check;
    case OrderStatuses.preparing:
      return Icons.precision_manufacturing;
    case OrderStatuses.readyPickup:
      return Icons.takeout_dining_rounded;
    case OrderStatuses.readyDelivery:
      return Icons.delivery_dining_outlined;
    case OrderStatuses.delivering:
      return Icons.delivery_dining_outlined;
    case OrderStatuses.delivered:
      return Icons.check;
    case OrderStatuses.completed:
      return Icons.check;
    case OrderStatuses.cancelled:
      return Icons.close;
    case OrderStatuses.error:
      return Icons.error;
    default:
      return Icons.check;
  }
}

OrderStatuses getStatusFromString(String status) {
  switch (status) {
    case 'created':
      return OrderStatuses.created;
    case 'accepted':
      return OrderStatuses.accepted;
    case 'preparing':
      return OrderStatuses.preparing;
    case 'readyPickup':
      return OrderStatuses.readyPickup;
    case 'readyDelivery':
      return OrderStatuses.readyDelivery;
    case 'delivering':
      return OrderStatuses.delivering;
    case 'delivered':
      return OrderStatuses.delivered;
    case 'completed':
      return OrderStatuses.completed;
    case 'cancelled':
      return OrderStatuses.cancelled;
    case 'error':
      return OrderStatuses.error;
    default:
      return OrderStatuses.created;
  }
}

String getStringFromStatus(OrderStatuses status) {
  switch (status) {
    case OrderStatuses.created:
      return "created";
    case OrderStatuses.accepted:
      return "accepted";
    case OrderStatuses.preparing:
      return "preparing";
    case OrderStatuses.readyPickup:
      return "readyPickup";
    case OrderStatuses.readyDelivery:
      return "readyDelivery";
    case OrderStatuses.delivering:
      return "delivering";
    case OrderStatuses.delivered:
      return "delivered";
    case OrderStatuses.completed:
      return "completed";
    case OrderStatuses.cancelled:
      return "cancelled";
    case OrderStatuses.error:
      return "error";
    default:
      return "unknown";
  }
}

enum OrderStatuses {
  created,
  accepted,
  preparing,
  readyPickup,
  readyDelivery,
  delivering,
  delivered,
  completed,
  cancelled,
  error,
}
