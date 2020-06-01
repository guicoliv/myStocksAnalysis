class QuoteDetail{
  //fields
  String symbol;
  String exchange;
  String name;
  String dayCode;
  String mode;
  double lastPrice;
  double netChange;
  double percentChange;
  String unitCode;
  double open;
  double high;
  double low;
  double close;
  String flag;
  double volume;

  QuoteDetail(this.symbol,
      this.exchange,
      this.name,
      this.dayCode,
      this.mode,
      this.lastPrice,
      this.netChange,
      this.percentChange,
      this.unitCode,
      this.open,
      this.high,
      this.low,
      this.close,
      this.flag,
      this.volume);
}