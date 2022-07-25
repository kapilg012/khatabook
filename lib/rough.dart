import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hive/hive.dart';
import 'package:hive_example_khatabook/constant/app_colors.dart';
import 'package:hive_example_khatabook/constant/app_text.dart';
import 'package:hive_example_khatabook/screens/add_client_screen.dart';
import 'package:intl/intl.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final _box = Hive.box(AppText.hiveBox);
  var _items = [];
  int totalAmount = 0;
  int totalIn = 0;
  int totalOut = 0;
  String addNotesImage = 'assets/add_notes.svg';

  Future _getAllDate() async {
    _items = await _box.keys.map((e) => _box.get(e)).toList();
    setState(() {
      _items = _items;
    });

    totalAmount = totalIn = totalOut = 0;
    for (var item in _items) {
      if (item['isCashIn'] == true) {
        totalIn = totalIn + int.parse(item['amount']);
      } else {
        totalOut = totalOut + int.parse(item['amount']);
      }
      totalAmount = totalIn - totalOut;
    }

    log(_box.keys.toString());
    log(_items.toString());
    log(_items.length.toString());
  }

  Future _deleteData(int key) async {
    _box.deleteAt(key);
    _getAllDate();
  }

  @override
  void initState() {
    _getAllDate();
    super.initState();
  }

  @override
  void dispose() {
    _box.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _getAllDate();
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: _items.isNotEmpty
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                AppText.netAmountText,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                totalAmount.toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: totalAmount > 0
                                      ? AppColors.greenColor
                                      : totalAmount < 0
                                          ? AppColors.redColor
                                          : AppColors.blackColor,
                                ),
                              ),
                            ],
                          ),
                          const Divider(thickness: 1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(AppText.totalInText, style: TextStyle(fontSize: 17)),
                                  SizedBox(height: 10),
                                  Text(AppText.totalOutText, style: TextStyle(fontSize: 17)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    totalIn.toString(),
                                    style: const TextStyle(color: AppColors.greenColor),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    totalOut.toString(),
                                    style: const TextStyle(color: AppColors.redColor),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  GroupedListView<dynamic, dynamic>(
                    shrinkWrap: true,
                    elements: _items,
                    groupComparator: (a, b) => b.compareTo(a),
                    groupBy: (element) => DateFormat('dd/MM/yyyy').format(element['date']),
                    groupSeparatorBuilder: (value) => Container(
                      height: 30.0,
                      color: AppColors.backgroundColor,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        value,
                        style: const TextStyle(color: AppColors.darkgreyColor, fontWeight: FontWeight.w500),
                      ),
                    ),
                    itemBuilder: (context, element) {
                      log("Element:    $element");
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        elevation: 0,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                              child: CircleAvatar(
                                backgroundImage: element['image'] != null ? FileImage(File(element['image'])) : null,
                                child: element['image'] != null ? null : const Icon(Icons.person),
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      element['name'],
                                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      element['amount'].toString(),
                                      style:
                                          TextStyle(fontSize: 15, color: element['isCashIn'] ? AppColors.greenColor : AppColors.redColor),
                                    ),
                                    // Text(
                                    //   date,
                                    //   // element['date'].toString(),
                                    //   style: const TextStyle(fontSize: 14, color: AppColors.greyColor),
                                    // ),
                                    const SizedBox(height: 5),
                                    element['description'] != "" && element['description'] != null
                                        ? Text(
                                            element['description'],
                                            maxLines: 1,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: AppColors.greyColor,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IconButton(
                                  constraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                                  icon: const Icon(Icons.edit, color: AppColors.greyColor),
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddClientScreen(_getAllDate(),
                                        index: element['key'],
                                      ),
                                    ),
                                  ).then((value) => _getAllDate()),
                                ),
                                IconButton(
                                  constraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                                  icon: const Icon(Icons.delete, color: AppColors.redColor),
                                  onPressed: () => showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text(AppText.areYouSureText),
                                      actions: [
                                        TextButton(
                                          child: const Text(AppText.yesText),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _deleteData(element['key']);
                                          },
                                        ),
                                        TextButton(
                                          child: const Text(AppText.noText),
                                          onPressed: () => Navigator.pop(context),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  // ListView.builder(
                  //   primary: _scrollController == null,
                  //   shrinkWrap: true,
                  //   controller: _scrollController,
                  //   physics: const NeverScrollableScrollPhysics(),
                  //   itemCount: _items.length,
                  //   itemBuilder: (context, index) {
                  //     var date = DateFormat('dd/MM/yyyy').format(_items[index]['date']);
                  //     return Card(
                  //       margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  //       elevation: 0,
                  //       child: Row(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Padding(
                  //             padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                  //             child: CircleAvatar(
                  //               backgroundImage: _items[index]['image'] != null ? FileImage(File(_items[index]['image'])) : null,
                  //               child: _items[index]['image'] != null ? null : const Icon(Icons.person),
                  //             ),
                  //           ),
                  //           const SizedBox(width: 16.0),
                  //           Expanded(
                  //             child: Padding(
                  //               padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                  //               child: Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: [
                  //                   Text(
                  //                     _items[index]['name'],
                  //                     style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  //                   ),
                  //                   const SizedBox(height: 5),
                  //                   Text(
                  //                     _items[index]['amount'].toString(),
                  //                     style: TextStyle(
                  //                         fontSize: 15, color: _items[index]['isCashIn'] ? AppColors.greenColor : AppColors.redColor),
                  //                   ),
                  //                   // Text(
                  //                   //   date,
                  //                   //   // _items[index]['date'].toString(),
                  //                   //   style: const TextStyle(fontSize: 14, color: AppColors.greyColor),
                  //                   // ),
                  //                   const SizedBox(height: 5),
                  //                   _items[index]['description'] != "" && _items[index]['description'] != null
                  //                       ? Text(
                  //                           _items[index]['description'],
                  //                           maxLines: 1,
                  //                           style: const TextStyle(
                  //                             fontSize: 14,
                  //                             color: AppColors.greyColor,
                  //                             overflow: TextOverflow.ellipsis,
                  //                           ),
                  //                         )
                  //                       : Container(),
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //           Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               IconButton(
                  //                 constraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                  //                 icon: const Icon(Icons.edit, color: AppColors.greyColor),
                  //                 onPressed: () => Navigator.push(
                  //                   context,
                  //                   MaterialPageRoute(
                  //                     builder: (context) => AddClientScreen(
                  //                       index: index,
                  //                     ),
                  //                   ),
                  //                 ).then((value) => _getAllDate()),
                  //               ),
                  //               IconButton(
                  //                 constraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                  //                 icon: const Icon(Icons.delete, color: AppColors.redColor),
                  //                 onPressed: () => showDialog(
                  //                   context: context,
                  //                   builder: (context) => AlertDialog(
                  //                     title: const Text(AppText.areYouSureText),
                  //                     actions: [
                  //                       TextButton(
                  //                         child: const Text(AppText.yesText),
                  //                         onPressed: () {
                  //                           Navigator.pop(context);
                  //                           _deleteData(index);
                  //                         },
                  //                       ),
                  //                       TextButton(
                  //                         child: const Text(AppText.noText),
                  //                         onPressed: () => Navigator.pop(context),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ),
                  //               )
                  //             ],
                  //           )
                  //         ],
                  //       ),
                  //     );
                  //   },
                  // ),
                ],
              ),
            )
          : Center(
              child: SvgPicture.asset(
              addNotesImage,
              height: 200,
            )),
      floatingActionButton: FloatingActionButton(
        onPressed: ()  {
           Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>  AddClientScreen(_getAllDate()),
            ),
          );


        },
        tooltip: 'Add Client',
        child: const Icon(Icons.add),
      ),
    );
  }
}
