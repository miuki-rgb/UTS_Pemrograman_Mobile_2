import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/category_cubit.dart';
import '../models/menu_model.dart';
import '../widgets/menu_card.dart';
import 'order_summary_page.dart'; // Import the OrderSummaryPage

class CategoryStackPage extends StatelessWidget {
  CategoryStackPage({Key? key}) : super(key: key);

  final List<MenuModel> foodMenus = [
    MenuModel(id: 'F1', name: 'Nasi Goreng', price: 25000, category: 'Makanan', discount: 0.1),
    MenuModel(id: 'F2', name: 'Mie Ayam', price: 20000, category: 'Makanan'),
    MenuModel(id: 'F3', name: 'Sate Ayam', price: 30000, category: 'Makanan', discount: 0.05),
  ];

  final List<MenuModel> drinkMenus = [
    MenuModel(id: 'D1', name: 'Es Teh', price: 5000, category: 'Minuman'),
    MenuModel(id: 'D2', name: 'Es Jeruk', price: 8000, category: 'Minuman', discount: 0.15),
    MenuModel(id: 'D3', name: 'Kopi Susu', price: 15000, category: 'Minuman'),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Menu Categories'),
        ),
        body: Column(
          children: [
            BlocBuilder<CategoryCubit, String>(
              builder: (context, selectedCategory) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () => context.read<CategoryCubit>().selectCategory('Makanan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedCategory == 'Makanan' ? Colors.blue : Colors.grey,
                      ),
                      child: const Text('Makanan'),
                    ),
                    ElevatedButton(
                      onPressed: () => context.read<CategoryCubit>().selectCategory('Minuman'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedCategory == 'Minuman' ? Colors.blue : Colors.grey,
                      ),
                      child: const Text('Minuman'),
                    ),
                  ],
                );
              },
            ),
            Expanded(
              child: BlocBuilder<CategoryCubit, String>(
                builder: (context, selectedCategory) {
                  return Stack(
                    children: [
                      Offstage(
                        offstage: selectedCategory != 'Makanan',
                        child: ListView.builder(
                          itemCount: foodMenus.length,
                          itemBuilder: (context, index) {
                            return MenuCard(menu: foodMenus[index]);
                          },
                        ),
                      ),
                      Offstage(
                        offstage: selectedCategory != 'Minuman',
                        child: ListView.builder(
                          itemCount: drinkMenus.length,
                          itemBuilder: (context, index) {
                            return MenuCard(menu: drinkMenus[index]);
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OrderSummaryPage()),
            );
          },
          child: const Icon(Icons.shopping_cart),
        ),
      ),
    );
  }
}
