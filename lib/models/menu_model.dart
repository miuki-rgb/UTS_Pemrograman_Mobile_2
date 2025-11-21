class MenuModel {
  String id;
  String name;
  int price;
  String category;
  double discount;

  MenuModel({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    this.discount = 0.0,
  });

  int getDiscountedPrice() {
    return (price - (price * discount)).toInt();
  }
}