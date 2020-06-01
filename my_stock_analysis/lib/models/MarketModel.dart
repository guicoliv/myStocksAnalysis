import 'package:json_annotation/json_annotation.dart';
part 'MarketModel.g.dart';

@JsonSerializable()
class MarketModel {
  MarketModel(this.open, this.high, this.low, this.close, this.vol);
  double open;
  double high;
  double low;
  double close;
  double vol;
  double amount;
  double count;
  @JsonKey(name: 'id')
  int date;

  //不同的类使用不同的mixin即可
  factory MarketModel.fromJson(Map<String, dynamic> json) => _$MarketModelFromJson(json);
  Map<String, dynamic> toJson() => _$MarketModelToJson(this);

//flutter packages pub run build_runner build
}
@JsonSerializable()
class MarketData {
  MarketData(this.data);
  @JsonKey(name: 'data')
  List<MarketModel> data;
  factory MarketData.fromJson(Map<String, dynamic> json) => _$MarketDataFromJson(json);
  Map<String, dynamic> toJson() => _$MarketDataToJson(this);
}