import '../../../../core/format/money.dart';
import '../../domain/entities/payment.dart';

/// Wire model for the server's `PaymentItem`.
///
/// Field names are the server's snake_case keys verbatim
/// (`domains/commerce/schemas/payment.py`). Prices arrive as Decimal and are
/// normalised to integer currency units by [parseMoneyMinor], which already tolerates
/// the string / int / double forms Decimal can serialize to.
class PaymentItemDto {
  const PaymentItemDto({
    required this.paymentId,
    this.paymentDate,
    this.description,
    this.cardInfo,
    this.price,
    this.category,
  });

  final int paymentId;
  final String? paymentDate;
  final String? description;
  final String? cardInfo;
  final Object? price;
  final String? category;

  factory PaymentItemDto.fromJson(Map<String, dynamic> json) {
    return PaymentItemDto(
      paymentId: (json['payment_id'] as num).toInt(),
      paymentDate: json['payment_date'] as String?,
      description: json['description'] as String?,
      cardInfo: json['card_info'] as String?,
      price: json['price'],
      category: json['category'] as String?,
    );
  }

  Payment toEntity() => Payment(
        id: paymentId,
        // Server sends an ISO-8601 datetime (or null). Parsed to local time so
        // the month grouping matches the user's calendar rather than UTC.
        date: paymentDate == null ? null : DateTime.tryParse(paymentDate!)?.toLocal(),
        description: description,
        cardInfo: cardInfo,
        price: parseMoneyMinor(price),
        category: PaymentCategory.fromWire(category),
      );
}

/// Wire model for the server's `PaymentPage`.
class PaymentPageDto {
  const PaymentPageDto({
    this.monthTotal,
    required this.items,
    required this.page,
    required this.size,
    required this.hasMore,
  });

  final Object? monthTotal;
  final List<PaymentItemDto> items;
  final int page;
  final int size;
  final bool hasMore;

  factory PaymentPageDto.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['items'] as List<dynamic>?) ?? const [];
    return PaymentPageDto(
      monthTotal: json['month_total'],
      items: rawItems
          .map((e) => PaymentItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: (json['page'] as num?)?.toInt() ?? 1,
      size: (json['size'] as num?)?.toInt() ?? 10,
      hasMore: json['has_more'] as bool? ?? false,
    );
  }

  PaymentPage toEntity() => PaymentPage(
        monthTotal: parseMoneyMinor(monthTotal),
        items: items.map((e) => e.toEntity()).toList(),
        page: page,
        size: size,
        hasMore: hasMore,
      );
}
