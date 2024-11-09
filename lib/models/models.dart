class UserModel{
  String useName;
  String email;
  String phoneNum;
  String image;


  /// constructor
 UserModel({required this.useName,required this.email,required this.phoneNum,required this.image});

 /// from map
 factory UserModel.fromMap(Map<String,dynamic>map){
   return UserModel(useName: map['useName'], email:map['email'], phoneNum:map['phoneNum'],image: map['image']);
 }
 /// to map
 Map<String,dynamic>toMap(){
   return{
     "useName":useName,
     "email":email,
     'phoneNum':phoneNum,
     'image':image
   };
 }


}

class TodoModel{
  String title;
  String desc;
  String create_at;

  /// constructor
 TodoModel({required this.title,required this.desc,required this.create_at});
 /// from map
 factory TodoModel.fromMap(Map<String,dynamic>map){
   return TodoModel(title: map['title'], desc:map['desc'], create_at:map['create_at']);
 }
 /// toMap
 Map<String,dynamic>toMap(){
   return{
     'title':title,
     'desc':desc,
     'create_at':create_at,
   };
 }
}