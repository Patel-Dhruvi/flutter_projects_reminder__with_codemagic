

class TextModel{
  int _id;
  String _type;
  String _title;
  String _date;
  String _time;
  String _description;
  String _repeat;
  String _filename;
  String _address;
  String _imagesarray;




  TextModel(this._type,this._title, this._date, this._time, this._description,
      this._repeat,[this._filename,this._address,this._imagesarray,this._id]);


  int get id => _id;

  // ignore: non_constant_identifier_names
  set Id(int value) {
    _id = value;
  }

  // ignore: unnecessary_getters_setters
  String get type => _type;

  // ignore: unnecessary_getters_setters
  set type(String value) {
    _type = value;
  }
  // ignore: unnecessary_getters_setters
  String get repeat => _repeat;

  // ignore: unnecessary_getters_setters
  set repeat(String value) {
    _repeat = value;
  }

  // ignore: unnecessary_getters_setters
  String get description => _description;

  // ignore: unnecessary_getters_setters
  set description(String value) {
    _description = value;
  }

  // ignore: unnecessary_getters_setters
  String get time => _time;

  // ignore: unnecessary_getters_setters
  set time(String value) {
    _time = value;
  }

  // ignore: unnecessary_getters_setters
  String get date => _date;

  // ignore: unnecessary_getters_setters
  set date(String value) {
    _date = value;
  }

  // ignore: unnecessary_getters_setters
  String get title => _title;

  // ignore: unnecessary_getters_setters
  set title(String value) {
    _title = value;
  }

  // ignore: unnecessary_getters_setters
  String get filename => _filename;

  // ignore: unnecessary_getters_setters
  set filename(String value) {
    _filename = value;
  }

  // ignore: unnecessary_getters_setters
  String get address => _address;

  // ignore: unnecessary_getters_setters
  set address(String value) {
    _address = value;
  }

  // ignore: unnecessary_getters_setters
  String get imagesarray => _imagesarray;

  // ignore: unnecessary_getters_setters
  set imagesarray(String value) {
    _imagesarray = value;
  }


  //convert task object into database object(map object)
  Map<String,dynamic> toMap(){
    var map=Map<String,dynamic>();
    if(id!=null){
      map['id']= _id;
    }
    map['type']=_type;
    map['title']=_title;
    map['date']=_date;
    map['time']=_time;
    map['description']=_description;
    map['repeat']=_repeat;
    map['filename']=_filename;
    map['address']=_address;
    map['imagearray']=_imagesarray;
    return map;
  }

  //Extract task object from map object
  TextModel.fromMapObject(Map<String,dynamic> map){

    this._id=map['id'];
    this._type=map['type'];
    this._title=map['title'];
    this._date=map['date'];
    this._time=map['time'];
    this._description=map['description'];
    this._repeat=map['repeat'];
    this._filename=map['filename'];
    this._address=map['address'];
    this._imagesarray=map['imagearray'];
  }

}

