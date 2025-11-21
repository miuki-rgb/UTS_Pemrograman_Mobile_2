import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/menu_model.dart';
import '../blocs/order_cubit.dart';

class MenuCard extends StatelessWidget {
  final MenuModel menu;

  const MenuCard({Key? key, required this.menu}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              menu.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Rp ${menu.price}',
                  style: TextStyle(
                    fontSize: 14,
                    color: menu.discount > 0 ? Colors.grey : Colors.black,
                    decoration: menu.discount > 0
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                if (menu.discount > 0) ...[
                  const SizedBox(width: 8),
                  Text(
                    'Rp ${menu.getDiscountedPrice()}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green, // Different color for discounted price
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            BlocBuilder<OrderCubit, Map<MenuModel, int>>(
              builder: (context, orderState) {
                final quantity = orderState[menu] ?? 0;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (quantity > 0) ...[
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          context.read<OrderCubit>().decreaseQuantity(menu);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${menu.name} dikurangi dari pesanan!'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                      Text('$quantity'),
                    ],
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        context.read<OrderCubit>().addToOrder(menu);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${menu.name} ditambahkan ke pesanan!'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
