import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import '../vending_machines_short.dart';

class VendingMachineListModel extends ChangeNotifier {
  List<VendingMachineShort> _vendingMachinesData = [];

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  List<VendingMachineShort> get vendingMachinesData => _vendingMachinesData;

  late StreamSubscription<DatabaseEvent> _vendingMachinesDataStream;

  VendingMachineListModel() {
    _listenToVendingMachineDataList();
  }

  void _listenToVendingMachineDataList() {
    _vendingMachinesDataStream =
        _dbRef.child('vending_machines').onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      _vendingMachinesData = data.entries
          .where((item) =>
              item.value['activated'] == true && item.value['id'] != '')
          .map((item) => VendingMachineShort.fromMap(
              item.value as Map<dynamic, dynamic>, item.key as String))
          .toList();
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _vendingMachinesDataStream.cancel();
    super.dispose();
  }
}
