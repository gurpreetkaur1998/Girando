import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:girando/controller/authController.dart';
import 'package:girando/utils/const.dart';
import 'package:girando/utils/helper.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Helper hlp = Helper();
  bool loading = true;
  List _orders = [];
  String status = "wc-processing";
  AuthController auth = Get.find<AuthController>();

  int initialIndex = 0;

  @override
  void initState() {
    // if (Get.parameters['type'] != null) {
    //   initialIndex = 1;
    //   status = 'wc-processing';
    // }

    super.initState();

    if (mounted) getData();
  }

  getData() async {
    Map<String, dynamic> data = await hlp.getData(
        "f=getOrdersByUserId&user_id=${auth.loggedInUser.value.ID}&paged=1&status=${status}");
    print(data);
    if (data.length > 0) {
      if (mounted) {
        setState(() {
          loading = false;
          _orders = data['data'];
        });
      }
      print(_orders);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: initialIndex,
      length: 3,
      child: Scaffold(
        backgroundColor: Constants.greyBg,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 1,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.chevron_left_outlined,
              size: 35,
            ),
            onPressed: () {
              Get.offAndToNamed("/main");
            },
          ),
          foregroundColor: Colors.black,
          title: const Text(
            'Anfragen',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          bottom: TabBar(
            labelPadding: EdgeInsets.zero,
            onTap: (i) {
              print(i);
              String _status = "wc-pending";
              if (i == 0) {
                _status = "wc-processing";
              } else if (i == 1) {
                _status = "wc-completed";
              } else if (i == 2) {
                _status = "wc-failed";
              }
              setState(() {
                status = _status;
                loading = true;
                getData();
              });
            },
            tabs: [
              Tab(
                text: 'Angebot',
              ),
              Tab(
                text: 'Angenommen',
              ),
              Tab(
                text: 'Abgelehnt',
              ),
            ],
          ),
        ),
        body: Container(
          alignment: Alignment.center,
          child: loading == true
              ? Container(
                  height: Get.height,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.grey,
                    ),
                  ),
                )
              : _orders.length == 0
                  ? Center(child: Text('Noch keine Bestellung'))
                  : ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        Map order = _orders[index];

                        return Container(
                          color: Colors.white,
                          margin: const EdgeInsets.only(
                            bottom: 4,
                          ),
                          child: ListTile(
                            onTap: () {
                              Get.toNamed("/orderDetailScreen",
                                  arguments: {"order": order});
                            },
                            focusColor: Colors.red,
                            iconColor: Colors.black,
                            horizontalTitleGap: 20,
                            trailing: Wrap(
                              direction: Axis.vertical,
                              alignment: WrapAlignment.center,
                              runAlignment: WrapAlignment.center,
                              verticalDirection: VerticalDirection.down,
                              children: [
                                if (order['status'] != "wc-pending")
                                  Chip(
                                    padding: const EdgeInsets.all(10),
                                    backgroundColor: Colors.green,
                                    label: Text(
                                      "${order['amount']}",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                Constants.spaceWidth20,
                                const Icon(
                                  Icons.chevron_right,
                                ),
                              ],
                            ),
                            title: Text(
                              "Anfrage # " + order['order_id'].toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "Datum : " + order['order_date'].toString(),
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: _orders.length,
                    ),
        ),
      ),
    );
  }
}
