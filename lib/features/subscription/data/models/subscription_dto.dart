import '../../../../core/format/money.dart';
import '../../domain/entities/subscription.dart';

/// Wire model for the server's `SubscriptionOut`.
///
/// Keys are the server's snake_case field names verbatim — the API declares no
/// aliases anywhere, so no renaming applies.
class SubscriptionDto {
  const SubscriptionDto({
    required this.subscribeId,
    this.startDate,
    this.endDate,
    this.price,
    this.isActivate,
  });

  final int subscribeId;
  final String? startDate;
  final String? endDate;
  final Object? price;

  /// Nullable on the wire — the column has no server default.
  final bool? isActivate;

  factory SubscriptionDto.fromJson(Map<String, dynamic> json) {
    return SubscriptionDto(
      subscribeId: (json['subscribe_id'] as num).toInt(),
      startDate: json['start_date'] as String?,
      endDate: json['end_date'] as String?,
      price: json['price'],
      isActivate: json['is_activate'] as bool?,
    );
  }

  Subscription toEntity() => Subscription(
        id: subscribeId,
        // ISO-8601 with a numeric offset; parsed to local so expiry comparisons
        // and any display match the user's clock.
        startDate: startDate == null
            ? null
            : DateTime.tryParse(startDate!)?.toLocal(),
        endDate:
            endDate == null ? null : DateTime.tryParse(endDate!)?.toLocal(),
        // `price` is Optional on the response even though it's required on the
        // request, so preserve null rather than collapsing it to 0.
        price: price == null ? null : parseMoneyMinor(price),
        isActivate: isActivate,
      );
}
