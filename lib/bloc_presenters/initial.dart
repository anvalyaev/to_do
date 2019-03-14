import 'dart:async';
import 'bloc_presenter_base.dart';



class Initial extends BlocPresenterBase {

  Property<int> counter;
  Input incrementButton;

  Initial(){
    incrementButton = Input.of(this, handler:(data){
      counter.value = counter.value + 1;
    });
    counter = Property.of(this, 0);
  } 
}
