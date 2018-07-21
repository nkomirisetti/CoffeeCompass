using Toybox.WatchUi as Ui;

class CoffeeCompassDelegate extends Ui.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onCoffeePress(){
        System.println("button pressed");
        return true;
    }

}