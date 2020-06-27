import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

class ProductDetailEvent{
  String str;

  ProductDetailEvent(String str){
    this.str = str;
  }
}

class LoginEvent{
  String str;
  LoginEvent(String str){
    this.str = str;
  }
}