
class HeaderImageModel{
  String _imgFileName;
  int _imgId;

  HeaderImageModel(this._imgFileName,[this._imgId]);

  String get imgFileName => _imgFileName;

  int get imgId => _imgId;

  set imgId(int value) {
    _imgId = value;
  }

  set imgFileName(String value) {
    _imgFileName = value;
  }

  Map<String,dynamic> toMap(){
    var map=Map<String,dynamic>();
    if(imgId!=null){
      map['imgid']= _imgId;
    }
    map['filename']=_imgFileName;
    return map;
  }

  HeaderImageModel.fromMapObject(Map<String,dynamic> map){

    this._imgId=map['imgid'];
    this._imgFileName=map['filename'];

  }
}