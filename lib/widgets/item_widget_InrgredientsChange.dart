import 'package:coffee_order_application/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/user/product_screen.dart';

class ItemWidget extends StatefulWidget {
  final String id;
  final String nameitem;
  String ingredients;
  int priceitem;
  final String imagepath;
  final iditem;

  ItemWidget({
    required this.nameitem,
    required this.priceitem,
    required this.imagepath,
    required this.ingredients,
    required this.id,
    super.key,
    this.iditem,
  });

  @override
  _ItemWidgetState createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  TextEditingController ingredientsController = TextEditingController();

  @override
  void initState() {
    ingredientsController.text = widget.ingredients;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Update Coffee Ingredients'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Enter the new ingredients:'),
                          TextField(
                            controller: ingredientsController,
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
                            String newIngredients =
                                ingredientsController.text;

                            if (newIngredients.isNotEmpty) {
                              String updatedIngredients =
                                  newIngredients;

                              Map<String, dynamic> updateInfo = {
                                'ingredients': updatedIngredients,
                              };

                              await DatabaseMethods()
                                  .UpdateProduct(
                                      widget.iditem, updateInfo);

                              setState(() {
                                widget.ingredients =
                                    updatedIngredients;
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
                height: MediaQuery.of(context).size.height * 0.2,
                child: Image.network(
                  widget.imagepath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.nameitem,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  widget.ingredients,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${widget.priceitem}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE57734),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Icon(
                    CupertinoIcons.add,
                    size: 20,
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
