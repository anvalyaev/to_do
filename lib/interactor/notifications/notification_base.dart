import '../entities/entity_base.dart';
abstract class NotificationBase{
  NotificationBase(){
    _id = counter;
    ++counter;
  }
  bool whenNotify(EntityBase model);
  void grabData(EntityBase model);
  
  int get id => _id;
  
  int _id;
  static int counter = 0;
}