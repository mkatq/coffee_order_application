import 'package:flutter/material.dart';

class AdminDelete extends StatefulWidget {
  @override
  State<AdminDelete> createState() => _AdminDeletePageState();
}

class _AdminDeletePageState extends State<AdminDelete> {
  List<String> itemsToDelete = [
    'Starbucks',
    'Half Milion',
    'Dunkin Donuts',
    'Ratio',
    'Dose',
    '65 degree',
    'Tim Hortons',
    '4T',
  ];

  List<bool> checkedItems = List<bool>.generate(8, (_) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 35,
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Icon(
                      Icons.notifications,
                      color: Colors.black,
                      size: 35,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Text(
                "Delete Panel",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 30),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: itemsToDelete.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                      value: checkedItems[index],
                      onChanged: (value) {
                        setState(() {
                          checkedItems[index] = value!;
                        });
                      },
                      title: Text(itemsToDelete[index]),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 200,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle delete functionality
                      List<String> selectedItems = [];
                      for (int i = 0; i < itemsToDelete.length; i++) {
                        if (checkedItems[i]) {
                          selectedItems.add(itemsToDelete[i]);
                        }
                      }
                      // Perform deletion logic here
                      print("Items to delete: $selectedItems");
                    },
                    child: Text('Delete', style: TextStyle(fontSize: 20)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
