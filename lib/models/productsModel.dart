class ProductModel {
  int? id;
  String? title;
  String? description;
  String? image;
  String? itemWeight;
  String? variationId;
  String? variationText;
  String? attribute;
  String? attribute_value;
  String? item_id;

  ProductModel({
    this.id,
    this.title,
    this.description,
    this.image,
    this.itemWeight,
    this.variationId,
    this.variationText,
    this.attribute,
    this.attribute_value,
    this.item_id,
  });
  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toInt();
    title = json['title']?.toString();
    description = json['description']?.toString();
    image = json['image']?.toString();
    itemWeight = json['item_weight']?.toString();
    variationId = json['variationId']?.toString();
    attribute = json['attribute']?.toString();
    attribute_value = json['attribute_value']?.toString();
    variationText = json['variationText']?.toString();
    item_id = json['item_id']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['image'] = image;
    data['item_weight'] = itemWeight;
    data['variationId'] = variationId;
    data['variationText'] = variationText;
    data['attribute'] = attribute;
    data['attribute_value'] = attribute_value;
    data['item_id'] = item_id;
    return data;
  }
}
