import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:girando/controller/authController.dart';
import 'package:girando/utils/const.dart';
import 'package:girando/utils/helper.dart';
import 'package:girando/widgets/jobsItem.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Helper hlp = Helper();
  bool loading = true;
  List jobs = [];
  AuthController auth = Get.find<AuthController>();
  int waitingOrders = 0;
  @override
  void initState() {
    super.initState();
    if (mounted) {
      getData();
      getWaitingOrders();
    }
  }

  getData() async {
    Map<String, dynamic> data = await hlp
        .getData("user/user/get_jobs/${auth.loggedInUser.value.ID.toString()}");
    print(data);
    if (data.length > 0) {
      setState(() {
        loading = false;
        jobs = data['data'];
      });
    }
  }

  getWaitingOrders() async {
    Map<String, dynamic> data = await hlp.getData(
        "f=getOrdersByUserId&user_id=${auth.loggedInUser.value.ID}&paged=1&status=wc-processing");
    setState(() {
      waitingOrders = data.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.colorBG,
      appBar: AppBar(
        backgroundColor: Constants.colorRed,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: Helper().appbarStyle('In Progress Jobs'),
        elevation: 0,
      ),
      body: (loading == true)
          ? Center(
              child: CircularProgressIndicator(
              color: Constants.colorRed,
            ))
          : Container(
              color: Constants.colorRed,
              child: RefreshIndicator(
                edgeOffset: 20,
                onRefresh: () async {
                  getData();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Constants.colorBG,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                    ),
                  ),
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      Map<String, dynamic> _job = jobs[index];
                      return jobItem(
                        _job,
                        index,
                        isCompleted: false,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        thickness: 1,
                        color: Colors.grey.shade100.withOpacity(0.2),
                      );
                    },
                    itemCount: jobs.length,
                  ),
                ),
              ),
            ),
    );
  }
}
