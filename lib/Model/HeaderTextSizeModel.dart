
class HeaderTextSize{
  double size;
  int index;

  HeaderTextSize({this.size, this.index});

  get list => getHeaderList();

}

List<HeaderTextSize>  getHeaderList(){

  List<HeaderTextSize> list = [
    HeaderTextSize(
      index: 1,
      size: 16,
    ),
    HeaderTextSize(
      index: 2,
      size: 18,
    ),
    HeaderTextSize(
      index: 3,
      size: 20,
    ),
    HeaderTextSize(
      index: 4,
      size: 22,
    ),
    HeaderTextSize(
      index: 5,
      size: 24,
    ),
    HeaderTextSize(
      index: 6,
      size: 26,
    ), HeaderTextSize(
      index: 7,
      size: 28,
    ),
    HeaderTextSize(
      index: 8,
      size: 30,
    ),
    HeaderTextSize(
      index: 9,
      size: 32,
    ),
    HeaderTextSize(
      index: 10,
      size: 34,
    ),
    HeaderTextSize(
      index: 11,
      size: 36,
    ),
    HeaderTextSize(
      index: 12,
      size: 38,
    ),
    HeaderTextSize(
      index: 13,
      size: 40,
    ),
    HeaderTextSize(
      index: 14,
      size: 42,
    ),
    HeaderTextSize(
      index: 15,
      size: 45,
    ),
  ];
  return list;

}