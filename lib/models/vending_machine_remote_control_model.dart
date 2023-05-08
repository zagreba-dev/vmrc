import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:vmrc/entity/deposit.dart';
import 'package:vmrc/entity/price.dart';
import 'package:vmrc/entity/vending_machines_full.dart';
import 'package:vmrc/settings.dart';
import 'package:vmrc/utils/utils.dart';

enum VendingMachineRemoteControlStatus { 
  initial, 
  success, 
  failure 
}

enum FormFieldStatus {
  submissionInitial,
  submissionInProgress,
  submissionSuccess,
  submissionFailure
}

class VendingMachineRemoteControlState {
  Deposit deposit;
  TextEditingController? depositController;
  FocusNode? depositFocusNode;
  FormFieldStatus depositStatus;

  Price price;
  TextEditingController? priceController;
  FocusNode? priceFocusNode;
  FormFieldStatus priceStatus;

  FormFieldStatus eButtonStartStopStatus;

  VendingMachineRemoteControlStatus status;
  VendingMachineFull? vendingMachineData;
  String? errorMessage;
  
  VendingMachineRemoteControlState({
    this.deposit = const Deposit.pure(),
    this.depositStatus = FormFieldStatus.submissionInitial,
    this.price = const Price.pure(),
    this.priceStatus = FormFieldStatus.submissionInitial,
    this.eButtonStartStopStatus = FormFieldStatus.submissionInitial,
    this.status = VendingMachineRemoteControlStatus.initial,
    this.vendingMachineData,
    this.errorMessage
  });
}

class VendingMachineRemoteControlModel extends ChangeNotifier {
  final _state = VendingMachineRemoteControlState();
  final String _vendingMachineReference;

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  VendingMachineRemoteControlState get state => _state;
  VendingMachineFull? get vendingMachineData => _state.vendingMachineData;
  String? get depositValidationError => depositValidationErrorToString(_state.deposit.displayError);
  String? get priceValidationError => priceValidationErrorToString(_state.price.displayError);
  
  late StreamSubscription<DatabaseEvent> _vendingMachineDataStream;

  VendingMachineRemoteControlModel(this._vendingMachineReference) {
    _state.depositController ??= TextEditingController();
    _state.depositController?.addListener(() {
      depositChanged();
    });
    _state.depositFocusNode ??= FocusNode();

    _state.priceController ??= TextEditingController();
    _state.priceController?.addListener(() {
      priceChanged();
    });
    _state.priceFocusNode ??= FocusNode();

    _listenToVendingMachineData();
  }

  @override
  void dispose() {
    _vendingMachineDataStream.cancel();
    _state.depositController?.dispose();
    _state.depositFocusNode?.dispose();
    _state.priceController?.dispose();
    _state.priceFocusNode?.dispose();
    super.dispose();
  }

  void _listenToVendingMachineData() {
    _vendingMachineDataStream = _dbRef
        .child('vending_machines/$_vendingMachineReference')
        .onValue
        .listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      _state.vendingMachineData = VendingMachineFull.fromMap(data);
      _state.status = VendingMachineRemoteControlStatus.success;
      notifyListeners();
    }, onError: (error) {
        _state.status = VendingMachineRemoteControlStatus.failure;
        _state.errorMessage = error.toString();
        notifyListeners();
    }, cancelOnError: true
    );
  }

  void retryVendingMachineData() {
    _state.errorMessage = null;
    _state.status = VendingMachineRemoteControlStatus.initial;
    notifyListeners();
    _listenToVendingMachineData();
  }

  void depositChanged() {
    if (_state.depositController?.text != null){
    final deposit = Deposit.dirty(_state.depositController!.text);
    _state.deposit = deposit;
    notifyListeners();}
  }

  void priceChanged() {
    if (_state.priceController?.text != null){
    final price = Price.dirty(_state.priceController!.text);
    _state.price = price;
    notifyListeners();}
  }

  Future<void> updateDepositToFb() async {
    final key = DbSettings.depositKey;
    final value = int.tryParse(_state.depositController?.text ?? '0') ?? 0 ;
    _state.depositStatus = FormFieldStatus.submissionInProgress;
    notifyListeners();
    try {
      await _dbRef
        .child('vending_machines/$_vendingMachineReference/data/stream')
        .update({key: value});
      _state.depositStatus = FormFieldStatus.submissionSuccess;
      _state.depositController?.clear();
      _state.deposit = const Deposit.pure();
      _state.depositFocusNode?.unfocus();
      notifyListeners();
    } catch (e) {
      print('You get an error! $e');
    }
  }

  Future<void> updatePriceToFb() async {
    final key = DbSettings.priceKey;
    final value = int.tryParse(_state.priceController?.text ?? '0') ?? 0 ;
    _state.priceStatus = FormFieldStatus.submissionInProgress;
    notifyListeners();
    try {
      await _dbRef
        .child('vending_machines/$_vendingMachineReference/data/stream')
        .update({key: value});
      _state.priceStatus = FormFieldStatus.submissionSuccess;
      _state.priceController?.clear();
      _state.price = const Price.pure();
      _state.priceFocusNode?.unfocus();
      notifyListeners();
    } catch (e) {
      print('You get an error! $e');
    }
  }

  Future<void> updateButtonStartStopToFb() async {
    final key = DbSettings.eButtonStartStopKey;
    final value = _state.vendingMachineData?.releStatus == 1 ? 0 : 1;
    _state.eButtonStartStopStatus = FormFieldStatus.submissionInProgress;
    notifyListeners();
    try {
      await _dbRef
        .child('vending_machines/$_vendingMachineReference/data/stream')
        .update({key: value});
      _state.eButtonStartStopStatus = FormFieldStatus.submissionSuccess;
      notifyListeners();
    } catch (e) {
      print('You get an error! $e');
    }
  }
}
