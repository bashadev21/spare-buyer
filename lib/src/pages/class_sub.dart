class Booking {
  final int id;
  final String category;
  final String brand;
  final String model;
  final String variant;
  final String year;
  final String fuel;
  final String images;

  Booking({this.id, this.category, this.brand,this.model,this.variant,this.year,this.fuel,this.images});

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      category: json['category_id'],

      brand: json['model_id'],
      model: json['brand_id'],
      variant: json['variant_id'],
      year: json['year_id'],
      fuel: json['fuel_id'],
      images: json['image_id'],


    );
  }
}