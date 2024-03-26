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
