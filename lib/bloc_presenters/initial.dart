import 'bloc_presenter_base.dart';

class Initial extends BlocPresenterBase {

  Output<int> counter;
  Input incrementButton;

  Initial(){
    incrementButton = Input.of(this, handler:(data){
      counter.value = counter.value + 1;
    });
    counter = Output.of(this, 0);
  } 
}
