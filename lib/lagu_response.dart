import 'package:mobile/lagu_model.dart';

class ProductResponse{
  List<LaguModel> listLagu = [];

  ProductResponse.fromJson(json){
    for(int i = 0; i < json.length;i++){
      LaguModel productModel = LaguModel.fromJson(json[i]);
      listLagu.add(productModel);
    }
  }
}