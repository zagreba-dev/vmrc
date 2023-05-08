import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vmrc/entity/vending_machines_short.dart';
import 'package:firebase_database/firebase_database.dart';

enum VendingMachinesListStatus { 
  initial, 
  success, 
  failure 
}

class VendingMachinesListState {
  VendingMachinesListStatus status;
  List<VendingMachineShort> vendingMachinesData;
  String? errorMessage;
  
  VendingMachinesListState({
    this.status = VendingMachinesListStatus.initial,
    this.vendingMachinesData = const <VendingMachineShort>[],
    this.errorMessage
  });
}

class VendingMachineListModel extends ChangeNotifier {
  final _state = VendingMachinesListState();

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  VendingMachinesListState get state => _state;

  late StreamSubscription<DatabaseEvent> _vendingMachinesDataStream;

  VendingMachineListModel() {
    _listenToVendingMachineDataList();
  }

  void _listenToVendingMachineDataList() {
    _vendingMachinesDataStream =
      _dbRef.child('vending_machines').onValue.listen((event) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        _state.vendingMachinesData = data.entries
        .where((item) =>
          item.value['activated'] == true && item.value['id'] != '')
        .map((item) => VendingMachineShort.fromMap(
          item.value as Map<dynamic, dynamic>, item.key as String))
        .toList();
        _state.status = VendingMachinesListStatus.success;
        notifyListeners();
    }, onError: (error) {
        _state.status = VendingMachinesListStatus.failure;
        _state.errorMessage = error.toString();
        notifyListeners();
    }, cancelOnError: true
    );
  }

  void retryVendingMachineDataList() {
    _state.errorMessage = null;
    _state.status = VendingMachinesListStatus.initial;
    notifyListeners();
    _listenToVendingMachineDataList();
  }

  @override
  void dispose() {
    _vendingMachinesDataStream.cancel();
    super.dispose();
  }
}
