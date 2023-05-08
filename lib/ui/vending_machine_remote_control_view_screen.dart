import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tuple/tuple.dart';
import 'package:vmrc/settings.dart';
import 'package:vmrc/models/vending_machine_remote_control_model.dart';
import 'package:provider/provider.dart';

class VendingMachineRemoteControlViewScreen extends StatelessWidget {
  VendingMachineRemoteControlViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<VendingMachineRemoteControlModel, VendingMachineRemoteControlStatus>(
      selector: (_, model) => model.state.status,
      builder: (_, status, __) {
        print(status);
        switch (status) {  
          case VendingMachineRemoteControlStatus.initial:
            return _buildLoadingView();
          case VendingMachineRemoteControlStatus.success:
            return _buildVendingMachineRemoteControlView(context);
          case VendingMachineRemoteControlStatus.failure:
            return _buildErrorView(context);
        }
      }
    );
  }

  Widget _buildLoadingView() { 
    return Scaffold(
      body: const Center(
        child: CircularProgressIndicator()
      )
    );
  }

  Widget _buildErrorView(BuildContext context) { 
    final errorMessage = context.read<VendingMachineRemoteControlModel>().state.errorMessage;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Ooops..', style: Theme.of(context).textTheme.displayMedium),
            SizedBox(height: 16),
            Text(
              errorMessage != null ? errorMessage : 'Something went wrong', 
              style: Theme.of(context).textTheme.titleMedium
            ),
            SizedBox(height: 16),
            ElevatedButton(
              key: const Key('vmrc_retry_button'),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
              onPressed: () => context.read<VendingMachineRemoteControlModel>().retryVendingMachineData(),
              child: const Text('Retry', style: TextStyle(fontSize: 22)),
            )
          ]
        ),
      ),
    );
  }

  Widget _buildVendingMachineRemoteControlView(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Selector<VendingMachineRemoteControlModel, String?>(
              selector: (_, model) => model.vendingMachineData?.id,
              builder: (_, id, __) {
                return id != null
                  ? Text('${NameLines.idPrefix} $id')
                  : const CircularProgressIndicator();
              }
            ),
            Selector<VendingMachineRemoteControlModel, String?>(
              selector: (_, model) => model.vendingMachineData?.location,
              builder: (_, location, __) {
                return location != null
                  ? Text('${NameLines.locationPrefix} $location')
                  : const CircularProgressIndicator();
              }
            ),
          ]
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.grey,
                boxShadow: [
                  BoxShadow(color: Colors.black, spreadRadius: 5, blurRadius: 7),
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                children: [
                  _buildGeneralView(),
                  const Divider(height: 20, thickness: 2, color: Colors.black),
                  // Deposit Input
                  _buildDepositInput(),
                  const Divider(height: 8, thickness: 2, color: Colors.black),
                  // Price Input
                  _buildPriceInput(),
                  const Divider(height: 8, thickness: 2, color: Colors.black)
                ],
              ),
            ),
            // bottom container placeholder
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.blueGrey,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      spreadRadius: 5,
                      blurRadius: 7,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0),
      ),
      floatingActionButton: Selector<VendingMachineRemoteControlModel, Tuple2<FormFieldStatus, int?>>(
        selector: (_, model) => 
          Tuple2(model.state.eButtonStartStopStatus, model.vendingMachineData?.releStatus),
        builder: (_, data, __) {
          return FloatingActionButton(
            backgroundColor: data.item2 == 0 ? null : Colors.red,
            onPressed: 
              data.item1 != FormFieldStatus.submissionInProgress
                ? () => context.read<VendingMachineRemoteControlModel>()
                    .updateButtonStartStopToFb()
                : null,
            tooltip: 'Start/Stop',
            child: 
              data.item1 != FormFieldStatus.submissionInProgress
              ? const Icon(Icons.power_settings_new)
              : SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(color: data.item2 == 1 ? null : Colors.red,)
                ), 
          );
        }
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildGeneralView() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 205, 225, 235),
        border: Border.all(width: 4, color: Colors.black),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        children: [
          // VM price
          Row(
            children: [
              const Expanded(
                child: Text(NameLines.price, style: AppTextStyle.viewLine),
              ),
              Expanded(
                child: Selector<VendingMachineRemoteControlModel, int?>(
                  selector: (_, model) =>
                    model.vendingMachineData?.price,
                  builder: (_, price, __) {
                    return price != null
                      ? Text(
                        '$price ${NameLines.priceSuffix}',
                        style: AppTextStyle.viewLine,
                      )
                      : const CircularProgressIndicator();
                  }
                ),
              )
            ],
          ),
          const SizedBox(height: 12),
          // VM balance
          Row(
            children: [
              const Expanded(
                child: Text(NameLines.balance, style: AppTextStyle.viewLine),
              ),
              Expanded(
                child: Selector<VendingMachineRemoteControlModel, int?>(
                  selector: (_, model) =>
                    model.vendingMachineData?.balance,
                  builder: (_, balance, __) {
                    return balance != null
                      ? Text(
                        '$balance ${NameLines.balanceSuffix}',
                        style: AppTextStyle.viewLine,
                      )
                      : const CircularProgressIndicator();
                  }
                ),
              )
            ],
          ),
          const SizedBox(height: 12),
          // VM liters left
          Row(
            children: [
              const Expanded(
                child: Text(NameLines.litersLeft, style: AppTextStyle.viewLine),
              ),
              Expanded(
                child: Selector<VendingMachineRemoteControlModel, int?>(
                  selector: (_, model) =>
                    model.vendingMachineData?.litersLeft,
                  builder: (_, litersLeft, __) {
                    return litersLeft != null
                      ? Text(
                        '$litersLeft ${NameLines.litersLeftSuffix}',
                        style: AppTextStyle.viewLine,
                      )
                      : const CircularProgressIndicator();
                  }
                ),
              )
            ],
          ),
          const SizedBox(height: 12),
          // VM rele status
          Row(
            children: [
              const Expanded(
                child: Text(NameLines.releStatus, style: AppTextStyle.viewLine),
              ),
              Expanded(
                child: Selector<VendingMachineRemoteControlModel, int?>(
                  selector: (_, model) =>
                    model.vendingMachineData?.releStatus,
                  builder: (_, releStatus, __) {
                    return releStatus != null
                      ? Text(
                        releStatus == 1 ? 'ON' : 'OFF',
                        style: releStatus == 1
                          ? AppTextStyle.releStatusOn
                          : AppTextStyle.releStatusOff,
                        )
                      : const CircularProgressIndicator();
                  }
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDepositInput() {
    return Row(
      children: [
        Expanded(
          child: Selector<VendingMachineRemoteControlModel, bool>(
            selector: (_, model) => model.state.deposit.isValid,
            builder: (context, depositIsValid, __) {
              final _model = context.read<VendingMachineRemoteControlModel>();
              return TextFormField(
                controller: _model.state.depositController,
                focusNode: _model.state.depositFocusNode,
                maxLength: 3,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  // don't show maxLenth counter
                  counterText: '',
                  hintText: TextInputDecoration.hintDeposit,
                  icon: TextInputDecoration.iconDepositInput,
                  helperText: '',
                  errorText: depositIsValid ? null : _model.depositValidationError,
                ),
              );
            }
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Selector<VendingMachineRemoteControlModel, Tuple2<FormFieldStatus, bool>>(
            selector: (_, model) => Tuple2(model.state.depositStatus, model.state.deposit.isValid),
            builder: (context, data, __) {
              final _model = context.read<VendingMachineRemoteControlModel>();
              return ElevatedButton(
                onPressed: 
                  data.item1 != FormFieldStatus.submissionInProgress && data.item2 
                    ? _model.updateDepositToFb
                    : null,
                child: data.item1 != FormFieldStatus.submissionInProgress
                    ? const Text('Submit')
                    : const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator()
                      ),
              );
            }
          ),
        ),
      ],
    );
  }

  Widget _buildPriceInput() {
    return Row(
      children: [
        Expanded(
          child: Selector<VendingMachineRemoteControlModel, bool>(
            selector: (_, model) => model.state.price.isValid,
            builder: (context, priceIsValid, __) {
              final _model = context.read<VendingMachineRemoteControlModel>();
              return TextFormField(
                controller: _model.state.priceController,
                focusNode: _model.state.priceFocusNode,
                maxLength: 3,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  // don't show maxLenth counter
                  counterText: '',
                  hintText: TextInputDecoration.hintPrice,
                  icon: TextInputDecoration.iconPriceInput,
                  helperText: '',
                  errorText: priceIsValid ? null : _model.priceValidationError,
                ),
              );
            }
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Selector<VendingMachineRemoteControlModel, Tuple2<FormFieldStatus, bool>>(
            selector: (_, model) => Tuple2(model.state.priceStatus, model.state.price.isValid),
            builder: (context, data, __) {
              final _model = context.read<VendingMachineRemoteControlModel>();
              return ElevatedButton(
                onPressed: 
                  data.item1 != FormFieldStatus.submissionInProgress && data.item2 
                    ? _model.updatePriceToFb
                    : null,
                child: data.item1 != FormFieldStatus.submissionInProgress
                    ? const Text('Submit')
                    : const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator()
                      ),
              );
            }
          ),
        ),
      ],
    );
  }
}