import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/order_cubit.dart';
import '../models/menu_model.dart';

class OrderSummaryPage extends StatelessWidget {
  const OrderSummaryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ringkasan Pesanan'),
      ),
      body: BlocBuilder<OrderCubit, Map<MenuModel, int>>(
        builder: (context, orderState) {
          if (orderState.isEmpty) {
            return const Center(
              child: Text('Pesanan kosong.'),
            );
          }

          int subtotal = context.read<OrderCubit>().getTotalPrice();
          double totalDiscount = 0;
          int finalTotal = subtotal;

          if (subtotal > 100000) {
            totalDiscount = subtotal * 0.10;
            finalTotal = (subtotal - totalDiscount).toInt();
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: orderState.length,
                  itemBuilder: (context, index) {
                    final menu = orderState.keys.elementAt(index);
                    final quantity = orderState.values.elementAt(index);
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    menu.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text('Jumlah: $quantity'),
                                  Text('Harga Satuan: Rp ${menu.getDiscountedPrice()}'),
                                ],
                              ),
                            ),
                            Text('Total: Rp ${menu.getDiscountedPrice() * quantity}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Subtotal: Rp $subtotal',
                      style: const TextStyle(fontSize: 18),
                    ),
                    if (totalDiscount > 0) ...[
                      Text(
                        'Diskon (10%): - Rp ${totalDiscount.toInt()}',
                        style: const TextStyle(fontSize: 18, color: Colors.red),
                      ),
                    ],
                    const Divider(),
                    Text(
                      'Total Akhir: Rp $finalTotal',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Implement checkout logic here
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Checkout berhasil!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        context.read<OrderCubit>().clearOrder();
                        Navigator.pop(context); // Go back to previous page
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Checkout',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
