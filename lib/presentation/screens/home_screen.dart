import 'package:flutter/material.dart';
import 'package:mybarsheet/core/constants/appColors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> products = [
    'Red Wine',
    'White Wine',
    'Rose Wine',
    'Whiskey',
    'Rum',
    'Zin',
    'Brandi',
    'Beer',
    'Breezer',
    'Mh',
    'BP',
    'Antiquity',
    'Vodca',
    'Bhoom Bhoom',
    'President Medal',
    'United',
  ];

  final Map<String, Map<String, dynamic>> data = {};
  final Map<String, Map<String, TextEditingController>> controllers = {};

  final ScrollController horizontalScrollController = ScrollController();
  final ScrollController verticalScrollLeft = ScrollController();
  final ScrollController verticalScrollRight = ScrollController();

  @override
  void initState() {
    super.initState();
    for (var product in products) {
      data[product] = {
        'PrevBal': 0,
        'Quantity': 10,
        'Price': 50,
        'AdditionQty': 0,
        'AdditionPrice': 0,
      };
      controllers[product] = {
        'AdditionQty': TextEditingController(text: '0'),
        'AdditionPrice': TextEditingController(text: '0'),
      };
    }

    // Sync vertical scroll
    verticalScrollLeft.addListener(() {
      if (verticalScrollRight.offset != verticalScrollLeft.offset) {
        verticalScrollRight.jumpTo(verticalScrollLeft.offset);
      }
    });
    verticalScrollRight.addListener(() {
      if (verticalScrollLeft.offset != verticalScrollRight.offset) {
        verticalScrollLeft.jumpTo(verticalScrollRight.offset);
      }
    });
  }

  Widget buildEditableCell(String product, String field, {double width = 100}) {
    return Container(
      width: width,
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      child: TextField(
        controller: controllers[product]?[field],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        onChanged: (value) {
          final parsed = int.tryParse(value) ?? 0;
          setState(() {
            data[product]?[field] = parsed;
          });
        },
        decoration: const InputDecoration(border: InputBorder.none),
      ),
    );
  }

  Widget buildCell(String value,
      {Color? color, bool isHeader = false, double width = 100}) {
    return Container(
      width: width,
      height: 60,
      padding: const EdgeInsets.all(8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isHeader ? Colors.grey[300] : color ?? Colors.white,
        border: Border.all(color: Colors.grey),
      ),
      child: Text(
        value,
        textAlign: TextAlign.center,
        style:
            TextStyle(fontWeight: isHeader ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }

  int getTotal(String field) {
    return products.fold(
        0, (int sum, String p) => sum + ((data[p]?[field] ?? 0) as int));
  }

  @override
  Widget build(BuildContext context) {
    const double columnWidth = 100;
    const double productColumnWidth = 120;

    return Scaffold(
      appBar: AppBar(
        title:  Text('Stock Sheet', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                buildCell("Product", isHeader: true, width: productColumnWidth),
                Expanded(
                  child: SingleChildScrollView(
                    controller: horizontalScrollController,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        buildCell("PrevBal", isHeader: true, width: columnWidth),
                        buildCell("Qty", isHeader: true, width: columnWidth),
                        buildCell("Price", isHeader: true, width: columnWidth),
                        buildCell("Add Qty", isHeader: true, width: columnWidth),
                        buildCell("Add Price", isHeader: true, width: columnWidth),
                        buildCell("Total Qty", isHeader: true, width: columnWidth),
                        buildCell("Total Amount", isHeader: true, width: columnWidth),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Body
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    width: productColumnWidth,
                    child: ListView.builder(
                      controller: verticalScrollLeft,
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return buildCell(products[index], width: productColumnWidth);
                      },
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: horizontalScrollController,
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: columnWidth * 7,
                        child: ListView.builder(
                          controller: verticalScrollRight,
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            final qty = (data[product]?['Quantity'] ?? 0).toInt();
                            final price = (data[product]?['Price'] ?? 0).toInt();
                            final addQty = (data[product]?['AdditionQty'] ?? 0).toInt();
                            final addPrice = (data[product]?['AdditionPrice'] ?? 0).toInt();
                            final totalQty = qty + addQty;
                            final totalAmount = totalQty * (price + addPrice);

                            return Row(
                              children: [
                                buildCell("${data[product]?['PrevBal']}", width: columnWidth),
                                buildCell("$qty", width: columnWidth),
                                buildCell("$price", width: columnWidth),
                                buildEditableCell(product, 'AdditionQty', width: columnWidth),
                                buildEditableCell(product, 'AdditionPrice', width: columnWidth),
                                buildCell("$totalQty", color: Colors.yellow[100], width: columnWidth),
                                buildCell("$totalAmount", color: Colors.green[100], width: columnWidth),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Footer totals
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                border: Border(top: BorderSide(color: Colors.grey)),
              ),
              child: Row(
                children: [
                  buildCell("Grand Total", isHeader: true, width: productColumnWidth),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: horizontalScrollController,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          buildCell("${getTotal('PrevBal')}", color: Colors.grey[100], width: columnWidth),
                          buildCell("${getTotal('Quantity')}", color: Colors.yellow[100], width: columnWidth),
                          buildCell("${getTotal('Price')}", color: Colors.green[100], width: columnWidth),
                          buildCell("${getTotal('AdditionQty')}", color: Colors.yellow[100], width: columnWidth),
                          buildCell("${getTotal('AdditionPrice')}", color: Colors.green[100], width: columnWidth),
                          buildCell("${getTotal('Quantity') + getTotal('AdditionQty')}", color: Colors.orange[100], width: columnWidth),
                          buildCell(
                            "${products.fold(0, (sum, p) {
                              int qty = (data[p]?['Quantity'] ?? 0).toInt();
                              int price = (data[p]?['Price'] ?? 0).toInt();
                              int addQty = (data[p]?['AdditionQty'] ?? 0).toInt();
                              int addPrice = (data[p]?['AdditionPrice'] ?? 0).toInt();
                              return sum + ((qty + addQty) * (price + addPrice));
                            })}",
                            color: Colors.orange[200],
                            width: columnWidth,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
