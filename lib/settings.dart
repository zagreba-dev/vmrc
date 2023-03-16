import 'package:flutter/material.dart';

class DbSettings {
  static const depositKey = 'deposit';
  static const priceKey = 'price';
  static const eButtonStartStopKey = 'ebutton_start_stop';
}

class TextInputDecoration {
  static const hintDepositText = 'Enter your deposit';
  static const iconDepositInput = Icon(Icons.account_balance);
  static const validatorDepositText = 'Please enter some deposit';
  static const hintPriceText = 'Enter your price';
  static const iconPriceInput = Icon(Icons.price_change);
  static const validatorPriceText = 'Please enter some price';
}

class AppTextStyle {
  static const viewLine = TextStyle(fontWeight: FontWeight.bold);
  static const releStatusOff =
      TextStyle(color: Colors.red, fontWeight: FontWeight.bold);
  static const releStatusOn =
      TextStyle(color: Colors.lime, fontWeight: FontWeight.bold);
}

class NameLines {
  static const idPrefix = 'ID: ';
  static const locationPrefix = 'Location: ';
  static const subtitle2Prefix = 'Bill acceptor full: ';
  static const price = 'PRICE';
  static const priceSuffix = 'grn/L';
  static const balance = 'BALANCE';
  static const balanceSuffix = 'grn';
  static const litersLeft = 'LITERS LEFT';
  static const litersLeftSuffix = 'L';
  static const releStatus = 'STATUS ON/OFF';
}
