import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/provider/order_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class OrderHistory extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F3F3),
      appBar: AppBar(
        title: Text('Order History'),
        backgroundColor: Colors.purple,
      ),
        body: Consumer(
          builder: (context, ref, child) {
            final orders = ref.watch(orderProvider);

            return orders.isEmpty ? Center(
              child: Text('No items ordered'),
            ) : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: order.products.map((e) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 10),
                              height: 100,
                                child: Row(
                                  children: [
                                    Container(
                                        child: Image.network(e.imageUrl, fit: BoxFit.cover,),
                                      height: 200,
                                      width: 120,
                                    ),
                                    SizedBox(width: 20),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(e.title, style: TextStyle(fontWeight: FontWeight.bold),),
                                        SizedBox(height: 10),
                                        Text('${e.quantity} * ${e.price}'),
                                        SizedBox(height: 5),
                                        Text('Total: ${e.total}')
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Align(
                                        child: Text('Date: ${order.dateTime}', style: TextStyle(fontSize: 8),),
                                        alignment: Alignment.bottomRight,
                                      ),
                                    )
                                  ],
                                 ),);
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                );
              }
            );
          }
        ),
    );
  }
}
