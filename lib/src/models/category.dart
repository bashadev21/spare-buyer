import '../helpers/custom_trace.dart';
import '../models/media.dart';

class Category {
  String id;
  String name;
  String avatar;

  Category();

  Category.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'];
      avatar = jsonMap['avatar'] ;
    } catch (e) {
      id = '';
      name = '';
      avatar = '';
      print(CustomTrace(StackTrace.current, message: e));
    }
  }
}
