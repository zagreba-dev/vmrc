import 'package:vmrc/vending_machines_short.dart';

class VendingMachineFull extends VendingMachineShort {
  final int balance;
  final int litersLeft;
  final int releStatus;
  final int deposit;
  final int ebuttonStartStop;
  final int price;

  VendingMachineFull({
    required this.balance,
    required this.litersLeft,
    required this.releStatus,
    required this.deposit,
    required this.ebuttonStartStop,
    required this.price,
    required super.id,
    required super.location,
    required super.fullBanknoteStorageCapacity,
    required super.litersSold,
    required super.statusOfBillAcceptor,
    required super.tankVolume,
    required super.listBanknoteStorageCapacity,
    super.reference = '',
  });

  factory VendingMachineFull.fromMap(Map<dynamic, dynamic> map) {
    return VendingMachineFull(
      id: map['id'] is String ? map['id'] as String : 'помилка',
      location:
          map['location'] is String ? map['location'] as String : 'помилка',
      statusOfBillAcceptor:
          map['data']['display']['status_of_bill_acceptor'] is int
              ? map['data']['display']['status_of_bill_acceptor'] as int
              : -1,
      tankVolume: map['data']['display']['tank_volume'] is int
          ? map['data']['display']['tank_volume'] as int
          : -1,
      listBanknoteStorageCapacity:
          map['data']['display']['list_of_money'] is List<dynamic>
              ? map['data']['display']['list_of_money'] as List<dynamic>
              : <dynamic>[],
      litersSold: map['data']['display']['liters_sold'] is int
          ? map['data']['display']['liters_sold'] as int
          : -1,
      fullBanknoteStorageCapacity:
          map['data']['display']['full_banknote_storage_capacity'] is int
              ? map['data']['display']['full_banknote_storage_capacity'] as int
              : -1,
      balance: map['data']['display']['balance'] is int
          ? map['data']['display']['balance'] as int
          : -1,
      litersLeft: map['data']['display']['liters_left'] is int
          ? map['data']['display']['liters_left'] as int
          : -1,
      releStatus: map['data']['display']['rele_status'] is int
          ? map['data']['display']['rele_status'] as int
          : -1,
      deposit: map['data']['stream']['deposit'] is int
          ? map['data']['stream']['deposit'] as int
          : -1,
      ebuttonStartStop: map['data']['stream']['ebutton_start_stop'] is int
          ? map['data']['stream']['ebutton_start_stop'] as int
          : -1,
      price: map['data']['stream']['price'] is int
          ? map['data']['stream']['price'] as int
          : -1,
    );
  }
}
