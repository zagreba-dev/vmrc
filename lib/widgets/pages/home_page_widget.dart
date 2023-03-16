import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vmrc/settings.dart';
import 'package:vmrc/widgets/pages/vending_machine_control_page_view_widget.dart';
import 'package:vmrc/models/vending_machine_control_page_model.dart';
import 'package:vmrc/models/vending_machine_list_model.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class MyHomePageWidgets extends StatelessWidget {
  const MyHomePageWidgets({super.key});

  @override
  Widget build(BuildContext context) =>
      ChangeNotifierProvider<VendingMachineListModel>(
        create: (_) => VendingMachineListModel(),
        child: _VendingMachineList(),
      );
}

class _VendingMachineList extends StatelessWidget {
  _VendingMachineList({Key? key}) : super(key: key);

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
              icon: const Icon(Icons.logout, size: 32))
        ],
      ),
      body: Selector<VendingMachineListModel, int>(
          selector: (_, model) => model.vendingMachinesData.length,
          builder: (_, data, __) {
            if (data > 0) {
              return ListView.builder(
                itemCount: data,
                itemBuilder: (BuildContext context, int index) {
                  final model = context.read<VendingMachineListModel>();

                  final listTile = <ListTile>[];
                  for (int i = 0; i < data; i++) {
                    final vendingMachineTileInfo = ListTile(
                      leading: const Icon(Icons.bolt_outlined),
                      title: Selector<VendingMachineListModel, String>(
                          selector: (_, model) =>
                              model.vendingMachinesData[i].id,
                          builder: (_, data, __) {
                            return Text(NameLines.idPrefix + data);
                          }),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Selector<VendingMachineListModel, String>(
                              selector: (_, model) =>
                                  model.vendingMachinesData[i].location,
                              builder: (_, data, __) {
                                return Text(NameLines.locationPrefix + data);
                              }),
                          Selector<VendingMachineListModel, Tuple2<int, int>>(
                              selector: (_, model) => Tuple2(
                                  model.vendingMachinesData[i]
                                      .listBanknoteStorageCapacity.length,
                                  model.vendingMachinesData[i]
                                      .fullBanknoteStorageCapacity),
                              builder: (_, data, __) {
                                return Text(NameLines.subtitle2Prefix +
                                    '${data.item1}' +
                                    ' / ' +
                                    '${data.item2}');
                              }),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Selector<VendingMachineListModel, Tuple2<int, int>>(
                              selector: (_, model) => Tuple2(
                                  model.vendingMachinesData[i]
                                      .listBanknoteStorageCapacity.length,
                                  model.vendingMachinesData[i]
                                      .fullBanknoteStorageCapacity),
                              builder: (context, data, __) {
                                final colorConditions =
                                    data.item2 / data.item1 > 1.2
                                        ? Colors.black
                                        : Colors.red;
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.account_balance_wallet,
                                      color: colorConditions,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: colorConditions,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Center(
                                        child: Text(
                                            '${context.read<VendingMachineListModel>().vendingMachinesData[i].countingCash()}'),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                          const SizedBox(width: 3),
                          Selector<VendingMachineListModel, int>(
                              selector: (_, model) => model
                                  .vendingMachinesData[i].statusOfBillAcceptor,
                              builder: (_, data, __) {
                                final colorConditions =
                                    data == 14 ? Colors.green : Colors.red;
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.info,
                                      color: colorConditions,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: colorConditions,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Center(
                                        child: Text('$data'),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                          const SizedBox(width: 3),
                          Selector<VendingMachineListModel, int>(
                              selector: (_, model) => model
                                  .vendingMachinesData[i]
                                  .remainingLiters(),
                              builder: (_, data, __) {
                                final iconRemainingLiters = context
                                    .read<VendingMachineListModel>()
                                    .vendingMachinesData[i]
                                    .iconDataRemainingLiters();
                                final colorRemainingLiters = context
                                    .read<VendingMachineListModel>()
                                    .vendingMachinesData[i]
                                    .colorDataRemainingLiters();
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      iconRemainingLiters,
                                      color: colorRemainingLiters,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: colorRemainingLiters,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Center(
                                        child: Text('$data'),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider<
                                    VendingMachineControlPageModel>(
                                  create: (_) => VendingMachineControlPageModel(
                                      model.vendingMachinesData[index]
                                          .reference),
                                  child: VendingMachineControlPageViewWidget(),
                                )));
                      },
                    );
                    listTile.add(vendingMachineTileInfo);
                  }
                  ;
                  return Column(children: [
                    index == 0
                        ? const SizedBox(height: 10)
                        : const SizedBox(height: 0),
                    listTile[index],
                    const Divider(
                      thickness: 2,
                    ),
                  ]);
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
