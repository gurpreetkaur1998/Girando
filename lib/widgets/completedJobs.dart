import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:girando/controller/authController.dart';
import 'package:girando/utils/const.dart';
import 'package:girando/utils/helper.dart';
import 'package:girando/widgets/jobsItem.dart';

class CompletedJobs extends StatefulWidget {
  const CompletedJobs({Key? key}) : super(key: key);

  @override
  State<CompletedJobs> createState() => _CompletedJobsState();
}

class _CompletedJobsState extends State<CompletedJobs> {
  AuthController auth = Get.find<AuthController>();
  Helper hlp = Helper();
  bool loading = true;
  List jobs = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    Map<String, dynamic> data = await hlp
        .getData("user/user/get_completed_jobs/${auth.loggedInUser.value.ID} ");
    print(data);
    if (data.length > 0) {
      if (this.mounted) {
        setState(() {
          loading = false;
          jobs = data['data'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.colorRed,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: Helper().appbarStyle('Completed Jobs'),
        elevation: 0,
      ),
      body: Container(
        color: Constants.colorRed,
        child: RefreshIndicator(
          edgeOffset: 20,
          onRefresh: () async {
            getData();
          },
          child: Container(
            decoration: BoxDecoration(
              color: Constants.colorBG,
              borderRadius: BorderRadius.only(
                topRight: const Radius.circular(30),
                topLeft: const Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
            child: ListView.separated(
              itemBuilder: (context, index) {
                Map<String, dynamic> _job = jobs[index];
                return jobItem(_job, index, isCompleted: true);
              },
              separatorBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  child: Divider(
                    thickness: 1,
                    color: Colors.grey.shade100.withOpacity(0.2),
                  ),
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
