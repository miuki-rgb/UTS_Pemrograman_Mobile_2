import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/menu_model.dart';

class OrderCubit extends Cubit<Map<MenuModel, int>> {
  OrderCubit() : super({});

  void addToOrder(MenuModel menu) {
    final currentState = Map<MenuModel, int>.from(state);
    if (currentState.containsKey(menu)) {
      currentState[menu] = currentState[menu]! + 1;
    } else {
      currentState[menu] = 1;
    }
    emit(currentState);
  }

  void decreaseQuantity(MenuModel menu) {
    final currentState = Map<MenuModel, int>.from(state);
    if (currentState.containsKey(menu)) {
      if (currentState[menu]! > 1) {
        currentState[menu] = currentState[menu]! - 1;
      } else {
        currentState.remove(menu);
      }
    }
    emit(currentState);
  }

  void removeFromOrder(MenuModel menu) {
    final currentState = Map<MenuModel, int>.from(state);
    currentState.remove(menu);
    emit(currentState);
  }

  void updateQuantity(MenuModel menu, int qty) {
    final currentState = Map<MenuModel, int>.from(state);
    if (qty > 0) {
      currentState[menu] = qty;
    } else {
      currentState.remove(menu);
    }
    emit(currentState);
  }

  int getTotalPrice() {
    int total = 0;
    state.forEach((menu, quantity) {
      total += menu.getDiscountedPrice() * quantity;
    });
    return total;
  }

  void clearOrder() {
    emit({});
  }
}
