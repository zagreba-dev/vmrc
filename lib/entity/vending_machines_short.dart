import 'package:flutter/material.dart';

class VendingMachineShort {
  final String id;
  final String location;
  final int fullBanknoteStorageCapacity;
  final int litersSold;
  final int statusOfBillAcceptor;
  final int tankVolume;
  final List<dynamic> listBanknoteStorageCapacity;
  final String reference;

  VendingMachineShort({
    required this.id,
    required this.location,
    required this.fullBanknoteStorageCapacity,
    required this.litersSold,
    required this.statusOfBillAcceptor,
    required this.tankVolume,
    required this.listBanknoteStorageCapacity,
    required this.reference,
  });

  factory VendingMachineShort.fromMap(Map<dynamic, dynamic> map, String key) {
    return VendingMachineShort(
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
      reference: key,
    );
  }

  // counting remaining liters
  int remainingLiters() {
    return tankVolume - litersSold;
  }

  // counting the amount of cash in the bill acceptor
  int countingCash() {
    var totalCash = 0;
    listBanknoteStorageCapacity.forEach((element) {
      totalCash += element as int;
    });
    return totalCash;
  }

  // change icon data on changed critical remaining liters
  IconData iconDataRemainingLiters() {
    final rL = remainingLiters();
    IconData iconDataRemainingLiters;
    if (rL < tankVolume / 10) {
      iconDataRemainingLiters = Icons.battery_0_bar;
    } else if (rL < tankVolume / 7) {
      iconDataRemainingLiters = Icons.battery_1_bar;
    } else if (rL < 2 * tankVolume / 7) {
      iconDataRemainingLiters = Icons.battery_2_bar;
    } else if (rL < 3 * tankVolume / 7) {
      iconDataRemainingLiters = Icons.battery_3_bar;
    } else if (rL < 4 * tankVolume / 7) {
      iconDataRemainingLiters = Icons.battery_4_bar;
    } else if (rL < 5 * tankVolume / 7) {
      iconDataRemainingLiters = Icons.battery_5_bar;
    } else if (rL < 6 * tankVolume / 7) {
      iconDataRemainingLiters = Icons.battery_6_bar;
    } else {
      iconDataRemainingLiters = Icons.battery_full;
    }
    return iconDataRemainingLiters;
  }

  // change color style on changed critical remaining liters
  MaterialColor colorDataRemainingLiters() {
    final rL = remainingLiters();
    MaterialColor colorDataRemainingLiters;
    if (rL < tankVolume / 10) {
      colorDataRemainingLiters = Colors.red;
    } else if (rL < tankVolume / 7) {
      colorDataRemainingLiters = Colors.red;
    } else if (rL < 2 * tankVolume / 7) {
      colorDataRemainingLiters = Colors.orange;
    } else if (rL < 3 * tankVolume / 7) {
      colorDataRemainingLiters = Colors.blue;
    } else if (rL < 4 * tankVolume / 7) {
      colorDataRemainingLiters = Colors.blue;
    } else if (rL < 5 * tankVolume / 7) {
      colorDataRemainingLiters = Colors.blue;
    } else if (rL < 6 * tankVolume / 7) {
      colorDataRemainingLiters = Colors.blue;
    } else {
      colorDataRemainingLiters = Colors.blue;
    }
    return colorDataRemainingLiters;
  }
}
