import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vmrc/settings.dart';
import 'package:vmrc/models/vending_machine_control_page_model.dart';
import 'package:provider/provider.dart';

class VendingMachineControlPageViewWidget extends StatelessWidget {
  VendingMachineControlPageViewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Selector<VendingMachineControlPageModel, String?>(
                  selector: (_, model) => model.vendingMachineData?.id,
                  builder: (_, data, __) {
                    return data != null
                        ? Text(NameLines.idPrefix + data)
                        : const CircularProgressIndicator();
                  }),
              Selector<VendingMachineControlPageModel, String?>(
                  selector: (_, model) => model.vendingMachineData?.location,
                  builder: (_, data, __) {
                    return data != null
                        ? Text(NameLines.locationPrefix + data)
                        : const CircularProgressIndicator();
                  }),
            ]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset.zero,
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 25),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 205, 225, 235),
                        border: Border.all(width: 3, color: Colors.black),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Expanded(
                                flex: 1,
                                child: Text(
                                  NameLines.price,
                                  style: AppTextStyle.viewLine,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Selector<VendingMachineControlPageModel,
                                        int?>(
                                    selector: (_, model) =>
                                        model.vendingMachineData?.price,
                                    builder: (_, data, __) {
                                      return data != null
                                          ? Text(
                                              '$data ' + NameLines.priceSuffix,
                                              style: AppTextStyle.viewLine,
                                            )
                                          : const CircularProgressIndicator();
                                    }),
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Expanded(
                                flex: 1,
                                child: Text(
                                  NameLines.balance,
                                  style: AppTextStyle.viewLine,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Selector<VendingMachineControlPageModel,
                                        int?>(
                                    selector: (_, model) =>
                                        model.vendingMachineData?.balance,
                                    builder: (_, data, __) {
                                      return data != null
                                          ? Text(
                                              '$data ' +
                                                  NameLines.balanceSuffix,
                                              style: AppTextStyle.viewLine,
                                            )
                                          : const CircularProgressIndicator();
                                    }),
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Expanded(
                                flex: 1,
                                child: Text(
                                  NameLines.litersLeft,
                                  style: AppTextStyle.viewLine,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Selector<VendingMachineControlPageModel,
                                        int?>(
                                    selector: (_, model) =>
                                        model.vendingMachineData?.litersLeft,
                                    builder: (_, data, __) {
                                      return data != null
                                          ? Text(
                                              '$data ' +
                                                  NameLines.litersLeftSuffix,
                                              style: AppTextStyle.viewLine,
                                            )
                                          : const CircularProgressIndicator();
                                    }),
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Expanded(
                                flex: 1,
                                child: Text(
                                  NameLines.releStatus,
                                  style: AppTextStyle.viewLine,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Selector<VendingMachineControlPageModel,
                                        int?>(
                                    selector: (_, model) =>
                                        model.vendingMachineData?.releStatus,
                                    builder: (_, data, __) {
                                      return data != null
                                          ? Text(
                                              data == 1 ? 'ON' : 'OFF',
                                              style: data == 1
                                                  ? AppTextStyle.releStatusOn
                                                  : AppTextStyle.releStatusOff,
                                            )
                                          : const CircularProgressIndicator();
                                    }),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 20,
                      thickness: 2,
                      color: Colors.black,
                    ),
                    InputFormWidget(
                        hintFormText: TextInputDecoration.hintDepositText,
                        iconFormInput: TextInputDecoration.iconDepositInput,
                        validatorFormText:
                            TextInputDecoration.validatorDepositText,
                        pathFirebaseVariable: DbSettings.depositKey),
                    const Divider(
                      height: 20,
                      thickness: 2,
                      color: Colors.black,
                    ),
                    InputFormWidget(
                        hintFormText: TextInputDecoration.hintPriceText,
                        iconFormInput: TextInputDecoration.iconPriceInput,
                        validatorFormText:
                            TextInputDecoration.validatorPriceText,
                        pathFirebaseVariable: DbSettings.priceKey),
                    const Divider(
                      height: 20,
                      thickness: 2,
                      color: Colors.black,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.blueGrey,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset.zero,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0),
      ),
      floatingActionButton: Selector<VendingMachineControlPageModel, int?>(
          selector: (_, model) => model.vendingMachineData?.releStatus,
          builder: (_, data, __) {
            return FloatingActionButton(
              backgroundColor: data == 0 ? null : Colors.red,
              onPressed: () => Provider.of<VendingMachineControlPageModel>(
                      context,
                      listen: false)
                  .updateVariableToFb(
                      DbSettings.eButtonStartStopKey,
                      context
                                  .read<VendingMachineControlPageModel>()
                                  .vendingMachineData
                                  ?.releStatus ==
                              1
                          ? 0
                          : 1),
              tooltip: 'Start/Stop',
              child: const Icon(Icons.power_settings_new),
            );
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class InputFormWidget extends StatefulWidget {
  InputFormWidget({
    Key? key,
    required this.hintFormText,
    required this.iconFormInput,
    required this.validatorFormText,
    required this.pathFirebaseVariable,
  }) : super(key: key);

  final String hintFormText;
  final Icon iconFormInput;
  final String validatorFormText;
  final String pathFirebaseVariable;

  @override
  State<InputFormWidget> createState() => _InputFormWidgetState();
}

class _InputFormWidgetState extends State<InputFormWidget> {
  bool isButtonActionStart = false;
  bool isButtonFormActive = false;
  final TextEditingController _controllerText = TextEditingController();
  late FocusNode _buttonFocusNode;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _controllerText.addListener(() {
      final isButtonActive = _controllerText.text.isNotEmpty;
      setState(() {
        isButtonFormActive = isButtonActive;
      });
    });
    _buttonFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _controllerText.dispose();
    _buttonFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: TextFormField(
                controller: _controllerText,
                focusNode: _buttonFocusNode,
                maxLength: 3,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  // don't show maxLenth counter
                  counterText: '',
                  hintText: widget.hintFormText,
                  icon: widget.iconFormInput,
                ),
                validator: (String? value) {
                  if (value == null ||
                      value.isEmpty ||
                      int.tryParse(value) == null) {
                    return widget.validatorFormText;
                  }
                  return null;
                },
                onEditingComplete: _updateVariableToFb),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: ElevatedButton(
              onPressed: isButtonFormActive ? _updateVariableToFb : null,
              child: !isButtonActionStart
                  ? const Text('Submit')
                  : const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      )),
            ),
          ),
        ],
      ),
    );
  }

  void _updateVariableToFb() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isButtonActionStart = true;
      });
      // Process data.
      await Provider.of<VendingMachineControlPageModel>(context, listen: false)
          .updateVariableToFb(
              widget.pathFirebaseVariable, int.parse(_controllerText.text));
      setState(() {
        _controllerText.clear();
        _buttonFocusNode.unfocus();
        isButtonActionStart = false;
      });
    }
  }
}
