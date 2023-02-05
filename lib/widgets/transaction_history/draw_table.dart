import 'package:flutter/material.dart';

class DrawTable extends StatelessWidget {
  const DrawTable({
    Key? key,
    required this.tableDataList,
  }) : super(key: key);

  final List<Map> tableDataList;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      child: DataTable(
        columnSpacing: 35,
        dividerThickness: 0.000001,
        dataRowHeight: 27,
        headingRowHeight: 25,
        columns: [
          DataColumn(
              label: SizedBox(
            width: width / 5,
            child: const Text('Name',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          )),
          if (tableDataList.first['No'] != null)
            DataColumn(
                label: SizedBox(
              width: width / 5,
              child: const Text('Amount',
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            )),
          DataColumn(
              label: SizedBox(
            width: width / 5,
            child: const Text('Price',
                textAlign: TextAlign.end,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          )),
        ],
        rows: tableDataList.map((data) {
          return DataRow(cells: <DataCell>[
            DataCell(SizedBox(
              width: width / 5,
              child: Text(data['Name'],
                  style: const TextStyle(fontSize: 14, height: 1)),
            )),
            if (data['No'] != null)
              DataCell(SizedBox(
                width: width / 5,
                child: Text(data['No'],
                    textAlign: TextAlign.end,
                    style:
                        const TextStyle(fontSize: 14, color: Colors.black54)),
              )),
            DataCell(SizedBox(
              width: width / 5,
              child: Text(data['Price'],
                  textAlign: TextAlign.end,
                  style: const TextStyle(fontSize: 14, color: Colors.black54)),
            )),
          ]);
        }).toList(),
      ),
    );
  }
}
