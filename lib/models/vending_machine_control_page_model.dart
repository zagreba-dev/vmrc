import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import '../vending_machines_full.dart';

class VendingMachineControlPageModel extends ChangeNotifier {
  VendingMachineFull? _vendingMachineData;
  final String _vendingMachineReference;

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  String get vendingMachineReference => _vendingMachineReference;
  VendingMachineFull? get vendingMachineData => _vendingMachineData;

  late StreamSubscription<DatabaseEvent> _vendingMachineDataStream;

  VendingMachineControlPageModel(this._vendingMachineReference) {
    _listenToVendingMachineData();
  }

  void _listenToVendingMachineData() {
    _vendingMachineDataStream = _dbRef
        .child('vending_machines/$_vendingMachineReference')
        .onValue
        .listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      _vendingMachineData = VendingMachineFull.fromMap(data);
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _vendingMachineDataStream.cancel();
    super.dispose();
  }

  Future updateVariableToFb(String key, int value) async {
    try {
      await _dbRef
          .child('vending_machines/$_vendingMachineReference/data/stream')
          .update({key: value});
    } catch (e) {
      print('You get an error! $e');
    }
  }
}
