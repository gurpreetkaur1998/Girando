import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:girando/utils/const.dart';

class jobItem extends StatelessWidget {
  int index;

  Map<String, dynamic> job;

  bool isCompleted;

  jobItem(Map<String, dynamic> this.job, int this.index,
      {required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
        delay: Duration(milliseconds: index * 100),
        child: ListTile(
          trailing: const Icon(
            LineIcons.chevronRight,
            color: Colors.white,
          ),
          title: Text(
            job['job_detail'],
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                fontSize: 20,
                color: Constants.colorRed,
              ),
            ),
          ),
          subtitle: Container(
            margin: EdgeInsets.only(top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'From: ',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              fontSize: 14.0,
                              color: Constants.white,
                            ),
                          ),
                        ),
                        Text(
                          job['start_date'],
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              fontSize: 14.0,
                              color: Constants.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (isCompleted == true)
                      Row(
                        children: [
                          Text(
                            'To: ',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                fontSize: 14.0,
                                color: Constants.white,
                              ),
                            ),
                          ),
                          Text(
                            job['start_date'],
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                fontSize: 14.0,
                                color: Constants.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                if (isCompleted == true)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.attach_money,
                        color: Colors.white,
                        size: 25,
                      ),
                      Text(
                        '${job['paid_amount']}',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            fontSize: 20.0,
                            color: Constants.white,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          isThreeLine: true,
          onTap: () {
            Get.toNamed("/detail", parameters: {"id": job['id'].toString()});
          },
        ));
  }
}
