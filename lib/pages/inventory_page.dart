import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rt_market/global/modal.dart';
import 'package:rt_market/models/inventory_model.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart'
    hide Column, Alignment, Row, Border, Stack;

import '../index.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({Key key}) : super(key: key);

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  List<Inventory> currentInventory = [];

  Future<void> exportToExcel(context) async {
    Xloading.showLottieLoading(context);
    //Create a Excel document.
    //Creating a workbook.
    final Workbook workbook = Workbook();
    //Accessing via index
    final Worksheet sheet = workbook.worksheets[0];
    sheet.showGridlines = true;

    // Enable calculation for worksheet.
    sheet.enableSheetCalculations();

//Add Text.
    sheet.getRangeByName('A1').setText('Inventaire');
    sheet.getRangeByName('A1').cellStyle.fontSize = 30.0;
    sheet.getRangeByName('A1').cellStyle.fontColor = '#333F4F';
    sheet.getRangeByName('A1').cellStyle.bold = true;
    sheet.getRangeByName('A1').rowHeight = 40.0;

    sheet.getRangeByName('A3:H3').columnWidth = 20.0;
    sheet.getRangeByName('A3:H3').cellStyle.backColor = '#000080';
    sheet.getRangeByName('A3:H3').cellStyle.fontColor = '#FFFFFF';
    sheet.getRangeByName('A3:H3').cellStyle.bold = true;
    sheet.getRangeByName('A3:H3').rowHeight = 30.0;
    sheet.getRangeByName('A3:H3').cellStyle.vAlign = VAlignType.center;

    sheet.getRangeByName('A3').setText("Date");
    sheet.getRangeByName('B3').setText("Produit");
    sheet.getRangeByName('C3').setText("Prix unitaire");
    sheet.getRangeByName('D3').setText("QTE Entrée");
    sheet.getRangeByName('E3').setText("QTE Sortie");
    sheet.getRangeByName('F3').setText("Total des ventes");
    sheet.getRangeByName('G3').setText("Stock actuel");
    sheet.getRangeByName('H3').setText("status");

    var inventories = inventoryController.inventories;
    int i = 4;
    inventories.forEach((e) {
      sheet.getRangeByName('A$i').setText(e.stock[0].stockDate);
      sheet.getRangeByName('A$i').rowHeight = 30.0;
      sheet.getRangeByName('B$i').setText(e.produitTitre);
      sheet.getRangeByName('B$i').rowHeight = 30.0;
      sheet.getRangeByName('C$i').setText("${e.pu} FC");
      sheet.getRangeByName('C$i').rowHeight = 30.0;
      sheet.getRangeByName('D$i').setText("${e.stockEntry}");
      sheet.getRangeByName('D$i').rowHeight = 30.0;
      sheet.getRangeByName('E$i').setText("${e.stockSorty}");
      sheet.getRangeByName('E$i').rowHeight = 30.0;
      sheet.getRangeByName('F$i').setText("${e.totalVentes} FC");
      sheet.getRangeByName('F$i').rowHeight = 30.0;
      sheet.getRangeByName('G$i').setText("${e.stockRestant}");
      sheet.getRangeByName('G$i').rowHeight = 30.0;
      sheet.getRangeByName('H$i').setText(e.status);
      sheet.getRangeByName('H$i').rowHeight = 30.0;
      sheet.getRangeByName('H$i').cellStyle.fontColor =
          e.status == "en stock" ? "#228b22" : "#FF0000";
      i++;
    });

// Save the document.

    //Save and launch the excel.
    final List<int> bytes = workbook.saveAsStream();
    //Dispose the document.
    workbook.dispose();

    //Save and launch the file.
    final String path = (await getTemporaryDirectory()).path;
    final String fileName =
        Platform.isWindows ? "$path\\inventaire.xlsx" : "$path/inventaire.xlsx";
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(fileName);
    Xloading.dismiss();
  }

  Future<void> getInventories(BuildContext context) async {
    var res = await DBHelper.inventories();
    var json = jsonEncode(res);
    Iterable i = jsonDecode(json);
    List<Inventory> data =
        List<Inventory>.from(i.map((model) => Inventory.fromMap(model)));
    var inventory =
        data.where((d) => d.stock[0].stockDate == selectedDate1).toList();

    if (inventory.isEmpty) {
      setState(() {
        selectedDate1 = "";
      });
      XDialog.showErrorMessage(
        context,
        color: Colors.amber[900],
        title: "Aucun inventaire",
        message: "Il y a aucun inventaire pour cette date !",
      );
      return;
    }
    int currentTotal = 0;
    int currentSellQty = 0;

    inventory.forEach((i) {
      currentTotal += i.totalVentes;
      currentSellQty += i.stockSorty;
    });
    inventoryController.currentTotal.value = currentTotal;
    inventoryController.currentItemsVenduQte.value = currentSellQty;
    inventoryController.inventories.value = inventory;
    setState(() {
      selectedDate1 = "";
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: const Text("Inventaire"),
        actions: [
          UserBox(
            color: Colors.blue[900],
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/market2.jpg"),
              fit: BoxFit.cover),
        ),
        child: Container(
          decoration: BoxDecoration(color: Colors.white.withOpacity(.85)),
          child: SafeArea(
            child: Obx(() {
              return Column(
                children: [
                  buildContainerHeader(context),
                  Stack(
                    overflow: Overflow.visible,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 10.0,
                        ),
                        width: _size.width,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 10.0,
                        ),
                        height: 60.0,
                        decoration: BoxDecoration(
                          color: Colors.blue[900],
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(.5),
                              blurRadius: 12.0,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Flexible(
                              child: TableHeaderItem(
                                icon: Icons.calendar_today_rounded,
                                title: "Stock Date",
                              ),
                            ),
                            Flexible(
                              child: TableHeaderItem(
                                icon: Icons.label,
                                title: "Produit",
                              ),
                            ),
                            Flexible(
                              child: TableHeaderItem(
                                icon: CupertinoIcons.money_dollar,
                                title: "Prix unitaire",
                              ),
                            ),
                            Flexible(
                              child: TableHeaderItem(
                                icon: CupertinoIcons.chart_bar_circle_fill,
                                title: "Qté entrée",
                              ),
                            ),
                            Flexible(
                              child: TableHeaderItem(
                                icon: Icons.bar_chart_rounded,
                                title: "Qté sortie/vendue",
                              ),
                            ),
                            Flexible(
                              child: TableHeaderItem(
                                icon: CupertinoIcons.money_dollar,
                                title: "Total",
                              ),
                            ),
                            Flexible(
                              child: TableHeaderItem(
                                icon: CupertinoIcons.cube_box_fill,
                                title: "stock restant",
                              ),
                            ),
                            Flexible(
                              child: TableHeaderItem(
                                icon: Icons.stacked_bar_chart_outlined,
                                title: "status",
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 5,
                        right: 15,
                        // ignore: avoid_unnecessary_containers
                        child: Container(
                          // ignore: deprecated_member_use
                          child: RaisedButton(
                            elevation: 10.0,
                            color: Colors.blue[800],
                            onPressed: () {
                              Xloading.showLottieLoading(context);
                              Future.delayed(const Duration(seconds: 2), () {
                                inventoryController.refreshDatas();
                                Xloading.dismiss();
                              });
                            },
                            child: Text("Afficher tout",
                                style: GoogleFonts.lato(color: Colors.white)),
                          ),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: Container(
                      child: Scrollbar(
                        hoverThickness: 5.0,
                        thickness: 5.0,
                        isAlwaysShown: true,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          itemCount: inventoryController.inventories.length,
                          itemBuilder: (context, index) {
                            var data = inventoryController.inventories[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10.0),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              height: 50.0,
                              width: _size.width,
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    width: 4.0,
                                    color: Colors.blue[900],
                                  ),
                                  right: BorderSide(
                                    width: 4.0,
                                    color: Colors.blue[900],
                                  ),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(.3),
                                    blurRadius: 12.0,
                                    offset: const Offset(0, 3),
                                  )
                                ],
                                color: (index.isEven)
                                    ? Colors.blue[50]
                                    : Colors.white.withOpacity(.9),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: TableItem(
                                      value: data.stock[0].stockDate,
                                    ),
                                  ),
                                  Flexible(
                                    child: TableItem(
                                      value: data.produitTitre,
                                    ),
                                  ),
                                  Flexible(
                                    child: TableItem(
                                      value: data.pu.toString(),
                                    ),
                                  ),
                                  Flexible(
                                    child: TableItem(
                                      value: data.ventes.isEmpty
                                          ? data.stockEntry.toString()
                                          : "${data.stockEntry.toString()} ${data.ventes[0].venteUnite}",
                                    ),
                                  ),
                                  Flexible(
                                    child: TableItem(
                                      value: data.ventes.isEmpty
                                          ? data.stockSorty.toString()
                                          : "${data.stockSorty.toString()} ${data.ventes[0].venteUnite}",
                                    ),
                                  ),
                                  Flexible(
                                    child: TableItem(
                                      value:
                                          "${data.totalVentes.toString()} FC",
                                      bold: true,
                                    ),
                                  ),
                                  Flexible(
                                    child: TableItem(
                                      value: data.stockRestant.toString(),
                                    ),
                                  ),
                                  Flexible(
                                    child: TableItem(
                                      value: data.status,
                                      color: data.status == "en stock"
                                          ? Colors.green[700]
                                          : Colors.redAccent,
                                      bold: true,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  )
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  String selectedDate1 = "";
  String selectedDate2 = "";

  buildContainerHeader(context) {
    return Container(
      height: 200.0,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.5),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(.3),
              blurRadius: 12.0,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(CupertinoIcons.doc_chart_fill,
                      color: Colors.black54),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Inventaire",
                    style: GoogleFonts.lato(
                      color: Colors.black54,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  DatePicker(
                    hintText: 'Sélectionnez date',
                    selectedDate: selectedDate1,
                    showDate: () async {
                      final picked = await showDateBox(context);
                      if (picked != null) {
                        setState(() {
                          selectedDate1 = dateFromString(picked);
                        });
                      }
                    },
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  const Text("-"),
                  const SizedBox(
                    width: 20.0,
                  ),
                  DatePicker(
                    hintText: 'Sélectionnez date',
                    selectedDate: selectedDate2,
                    showDate: () async {
                      //final DateTime picked = await showDateBox(context);
                      /*if (picked != null) {
                        setState(() {
                          selectedDate2 = dateFromString(picked);
                        });
                      }*/

                      var result = await DBHelper.innerJoin();
                      result.forEach(print);
                    },
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  // ignore: deprecated_member_use
                  Container(
                    height: 38.0,
                    // ignore: deprecated_member_use
                    child: RaisedButton.icon(
                      color: Colors.blue[900],
                      icon: const Icon(
                        Icons.arrow_right_alt,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        //getInventories(context);
                        /*DateTime d = DateTime(
                            DateTime.now().year, DateTime.now().month, 17);
                        int date = d.microsecondsSinceEpoch;
                        for (int i = 15; i < 20; i++) {
                          var resRow = await SqliteDbHelper.rawInsert(
                              "INSERT INTO tests(test_label, test_date) VALUES('label$i', $date)",
                              table: "tests");
                          print(resRow);
                        }*/
                        /*DateTime now = DateTime(DateTime.now().year,
                            DateTime.now().month, DateTime.now().day);*/

                        /* select weekly
                        var d = DateTime.now();
                        var weekDay = d.weekday;

                        DateTime now = DateTime(DateTime.now().year,
                            DateTime.now().month, DateTime.now().day);
                        DateTime towDaysAgoFromNow =
                            now.add(Duration(days: weekDay));
                        int today = now.microsecondsSinceEpoch;
                        int twoDaysAgo =
                            towDaysAgoFromNow.microsecondsSinceEpoch;
                        //print(towDaysAgoFromNow);
                        var data = await SqliteDbHelper.rawQuery(
                            "SELECT * FROM tests WHERE test_date BETWEEN '$today' AND '$twoDaysAgo'");
                        print(data);

                        */

                        // select mothly
                        /*
                        var d = DateTime.now();
                        int monthDayNumber = daysInMonth(d);

                        int currentMonthDayNum = monthDayNumber - d.day;
                        print(currentMonthDayNum);

                        DateTime now = DateTime(DateTime.now().year,
                            DateTime.now().month, DateTime.now().day);
                        DateTime lastDate = now
                            .subtract(Duration(days: currentMonthDayNum + 1));
                        DateTime endDate =
                            now.add(Duration(days: currentMonthDayNum));
                        print(lastDate);
                        print(endDate);

                        int last = lastDate.microsecondsSinceEpoch;
                        int end = endDate.microsecondsSinceEpoch;
                        var data = await SqliteDbHelper.rawQuery(
                            "SELECT * FROM tests WHERE test_date BETWEEN '$last' AND '$end'");
                        print(data);
                        */
                      },
                      label: Text(
                        "voir inventaire",
                        style: GoogleFonts.lato(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 20.0,
                  ),
                  Container(
                    height: 38.0,
                    // ignore: deprecated_member_use
                    child: RaisedButton.icon(
                      color: Colors.green,
                      onPressed: () => exportToExcel(context),
                      icon: const Icon(
                        CupertinoIcons.doc_plaintext,
                        color: Colors.white,
                        size: 18.0,
                      ),
                      label: Text(
                        "Exporter vers Excell",
                        style: GoogleFonts.lato(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
          const SizedBox(height: 20.0),
          Row(
            children: [
              Flexible(
                child: SaleDetail(
                  color: Colors.blue[900],
                  amount: "${inventoryController.currentTotal.value} FC",
                  icon: Icons.pie_chart,
                  subtitle: "Total des ventes journalières",
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
              Flexible(
                child: SaleDetail(
                  color: Colors.green[900],
                  amount: "${inventoryController.currentTotal.value} FC",
                  icon: Icons.pie_chart,
                  subtitle: "Total des ventes hebdomadaires",
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
              Flexible(
                child: SaleDetail(
                  color: Colors.orange[900],
                  amount: "${inventoryController.currentTotal.value} FC",
                  icon: Icons.pie_chart,
                  subtitle: "Total des ventes mensuelles",
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
              Flexible(
                child: SaleDetail(
                  color: Colors.cyan,
                  amount: "${inventoryController.currentItemsVenduQte.value}",
                  icon: CupertinoIcons.doc_checkmark_fill,
                  subtitle: "Qté des produits vendus",
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  int daysInMonth(DateTime date) {
    var firstDayThisMonth = DateTime(date.year, date.month, date.day);
    var firstDayNextMonth = DateTime(firstDayThisMonth.year,
        firstDayThisMonth.month + 1, firstDayThisMonth.day);
    return firstDayNextMonth.difference(firstDayThisMonth).inDays;
  }
}

class TableHeaderItem extends StatelessWidget {
  final String title;
  final IconData icon;
  const TableHeaderItem({this.title, this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 15.0,
        ),
        const SizedBox(
          width: 5.0,
        ),
        Text(
          title,
          style: GoogleFonts.lato(
              color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w700),
        )
      ],
    );
  }
}

class TableItem extends StatelessWidget {
  final String value;
  final Widget child;
  final bool bold;
  final Color color;
  const TableItem({this.value, this.child, this.bold = false, this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (child != null) child,
        const SizedBox(
          width: 5.0,
        ),
        Text(
          value,
          style: GoogleFonts.lato(
              color: (color == null) ? Colors.black87 : color,
              fontSize: 16.0,
              fontWeight: (bold) ? FontWeight.w800 : FontWeight.w500),
        )
      ],
    );
  }
}

class SaleDetail extends StatelessWidget {
  final String amount;
  final IconData icon;
  final String subtitle;
  final Color color;
  const SaleDetail({
    this.amount,
    this.icon,
    this.subtitle,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(.6),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.2),
            blurRadius: 12.0,
            offset: const Offset(0, 3),
          )
        ],
      ),
      height: 100,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 30,
                color: Colors.white,
              ),
              const SizedBox(
                width: 10.0,
              ),
              Text(
                amount,
                style: GoogleFonts.lato(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 25.0,
                ),
              )
            ],
          ),
          const SizedBox(height: 10.0),
          Text(
            subtitle,
            style: GoogleFonts.lato(
              color: Colors.grey[200],
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class DatePicker extends StatelessWidget {
  final String hintText;
  final String selectedDate;
  final Function showDate;
  const DatePicker({
    Key key,
    this.hintText,
    this.selectedDate,
    this.showDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: showDate,
      child: Container(
        height: 40.0,
        width: 220.0,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(.2),
                blurRadius: 12.0,
                offset: const Offset(0, 3))
          ],
        ),
        child: Row(
          children: [
            const Icon(CupertinoIcons.calendar, color: Colors.black45),
            const SizedBox(
              width: 5.0,
            ),
            if (selectedDate.isEmpty)
              Text(hintText)
            else
              Text(
                selectedDate,
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.w700,
                ),
              ),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.blue[900],
            )
          ],
        ),
      ),
    );
  }
}
