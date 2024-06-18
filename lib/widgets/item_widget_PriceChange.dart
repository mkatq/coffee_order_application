import 'package:coffee_order_application/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/user/product_screen.dart';

class ItemWidget extends StatefulWidget {
  final String id;
  final String nameitem;
  final String ingredients;
  int priceitem;
  final String imagepath;
  final iditem;

  ItemWidget({
    required this.nameitem,
    required this.priceitem,
    required this.imagepath,
    required this.ingredients,
    required this.id,
    this.iditem,
  });

  @override
  _ItemWidgetState createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    priceController.text = widget.priceitem.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: screenWidth > 600 ? 5 : 2,
        horizontal: screenWidth > 600 ? 20 : 10,
      ),
      margin: EdgeInsets.symmetric(
        vertical: screenWidth > 600 ? 8 : 6,
        horizontal: screenWidth > 600 ? 20 : 13,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(screenWidth > 600 ? 30 : 20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Update Coffee Price'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Enter the new price:'),
                        TextField(
                          controller: priceController,
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('Update'),
                        onPressed: () async {
                          String newPrice = priceController.text;

                          if (newPrice.isNotEmpty) {
                            int updatedPrice = int.tryParse(newPrice) ?? 0;

                            Map<String, dynamic> updateInfo = {
                              'itemprice': updatedPrice,
                            };

                            await DatabaseMethods()
                                .UpdateProduct(widget.iditem, updateInfo);

                            setState(() {
                              widget.priceitem = updatedPrice;
                            });

                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: Container(
              margin: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              child: AspectRatio(
                aspectRatio: 16 / 9, // Adjust aspect ratio as needed
                child: Expanded(
                  child: Image.network(
                    widget.imagepath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: screenWidth > 600 ? 8 : 6),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.nameitem,
                    style: TextStyle(
                      fontSize: screenWidth > 600 ? 16 : 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: screenWidth > 600 ? 8 : 6,
                  ),
                  Text(
                    widget.ingredients,
                    style: TextStyle(
                      fontSize: screenWidth > 600 ? 13 : 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: screenWidth > 600 ? 2 : 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${widget.priceitem}",
                  style: TextStyle(
                    fontSize: screenWidth > 600 ? 18 : 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(screenWidth > 600 ? 1 : 0.5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE57734),
                    borderRadius: BorderRadius.circular(screenWidth > 600 ? 7 : 5),
                  ),
                  child: Icon(
                    CupertinoIcons.add,
                    size: screenWidth > 600 ? 20 : 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
