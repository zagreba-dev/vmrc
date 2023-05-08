import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vmrc/settings.dart';
import 'package:vmrc/ui/vending_machine_remote_control_view_screen.dart';
import 'package:vmrc/models/vending_machine_remote_control_model.dart';
import 'package:vmrc/models/vending_machines_model.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class VendingMachinesScreen extends StatelessWidget {
  const VendingMachinesScreen({super.key});

  @override
  Widget build(BuildContext context) =>
    ChangeNotifierProvider<VendingMachineListModel>(
      create: (_) => VendingMachineListModel(),
      child: _VendingMachinesList(),
    );
}

class _VendingMachinesList extends StatelessWidget {
  const _VendingMachinesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Vending Machines'),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout, size: 32)
          )
        ],
      ),
      body: Selector<VendingMachineListModel, VendingMachinesListStatus>(
        selector: (_, model) => model.state.status,
        builder: (_, status, __) {
          print(status);
          switch (status) {  
            case VendingMachinesListStatus.initial:
              return _buildLoadingView();
            case VendingMachinesListStatus.success:
              return _buildVendingMachinesView(context);
            case VendingMachinesListStatus.failure:
              return _buildErrorView(context);
          }
        }
      ),
    );
  }

  Widget _buildLoadingView() { 
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorView(BuildContext context) { 
    final errorMessage = context.read<VendingMachineListModel>().state.errorMessage;
    return Padding(
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
            key: const Key('vending_machines_retry_button'),
            style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
            onPressed: () => context.read<VendingMachineListModel>().retryVendingMachineDataList(),
            child: const Text('Retry', style: TextStyle(fontSize: 22)),
          )
        ]
      ),
    );
  }

  Widget _buildVendingMachinesView(BuildContext context) {
    return Selector<VendingMachineListModel, int>(
      selector: (_, model) => model.state.vendingMachinesData.length,
      builder: (_, data, __) {
        if (data > 0) {
          return ListView.builder(
            itemCount: data,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  index == 0 ? const SizedBox(height: 10) : const SizedBox(height: 0),
                  _VMListTile(index: index),
                  const Divider(thickness: 2),
                ]
              );
            },
          );
        } else { 
          return _buildVendingMachinesEmptyView(context);            
        }  
      }
    );
  }

  Widget _buildVendingMachinesEmptyView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.view_list_rounded, size: 70, color: Colors.blueAccent, ),
          SizedBox(height: 16, width: double.infinity),
          Text(
            'Your vending Machines list is', 
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center
          ),
          Text(
            'EMPTY', 
            style: Theme.of(context).textTheme.displaySmall?.apply(color: Colors.redAccent),
          ),
         ]
      )
    );
  }
}

class _VMListTile extends StatelessWidget {

  final int index;

  _VMListTile({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.bolt_outlined),
      title: Selector<VendingMachineListModel, String>(
        selector: (_, model) => 
          model.state.vendingMachinesData[index].id,
        builder: (_, id, __) {
          return Text('${NameLines.idPrefix} $id');
        }
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Selector<VendingMachineListModel, String>(
            selector: (_, model) =>
              model.state.vendingMachinesData[index].location,
            builder: (_, location, __) {
              return Text('${NameLines.locationPrefix} $location');
            }
          ),
          Selector<VendingMachineListModel, Tuple2<int, int>>(
            selector: (_, model) => Tuple2(
              model.state.vendingMachinesData[index]
                .listBanknoteStorageCapacity.length,
              model.state.vendingMachinesData[index]
                .fullBanknoteStorageCapacity
              ),
            builder: (_, data, __) {
              return Text('${NameLines.subtitle2Prefix} ${data.item1} / ${data.item2}');
            }
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // counting cash
          Selector<VendingMachineListModel, Tuple2<int, int>>(
            selector: (_, model) => Tuple2(
              model.state.vendingMachinesData[index]
                .listBanknoteStorageCapacity.length,
              model.state.vendingMachinesData[index]
                .fullBanknoteStorageCapacity
              ),
            builder: (context, data, __) {
              final colorConditions = data.item2 / data.item1 > 1.2
                ? Colors.black
                : Colors.red;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_balance_wallet, color: colorConditions),
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      border: Border.all(color: colorConditions),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Text(
                      '${context.read<VendingMachineListModel>()
                        .state.vendingMachinesData[index]
                        .countingCash()}'
                    ),
                  ),
                ],
              );
            }
          ),
          const SizedBox(width: 4),
          // status of Bill Acceptor
          Selector<VendingMachineListModel, int>(
            selector: (_, model) => 
              model.state.vendingMachinesData[index].statusOfBillAcceptor,
            builder: (_, statusOfBillAcceptor, __) {
              final colorConditions = statusOfBillAcceptor == 14 
                ? Colors.green 
                : Colors.red;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info, color: colorConditions),
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      border: Border.all(color: colorConditions),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Text('$statusOfBillAcceptor'),
                  ),
                ],
              );
            }
          ),
          const SizedBox(width: 4),
          // remaining liters
          Selector<VendingMachineListModel, int>(
            selector: (_, model) => 
              model.state.vendingMachinesData[index].remainingLiters(),
            builder: (_, remainingLiters, __) {
              final iconRemainingLiters = context
                .read<VendingMachineListModel>().state
                .vendingMachinesData[index]
                .iconDataRemainingLiters();
              final colorRemainingLiters = context
                .read<VendingMachineListModel>().state
                .vendingMachinesData[index]
                .colorDataRemainingLiters();
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(iconRemainingLiters, color: colorRemainingLiters),
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      border: Border.all(color: colorRemainingLiters),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Text('$remainingLiters'),
                  ),
                ],
              );
            }
          ),
        ],
      ),
      onTap: () {
        final model = context.read<VendingMachineListModel>();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider<VendingMachineRemoteControlModel>(
            create: (_) => VendingMachineRemoteControlModel(
              model.state.vendingMachinesData[index].reference
            ),
          child: VendingMachineRemoteControlViewScreen(),
          )
        ));
      },
    );
  }
 }
