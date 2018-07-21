using Toybox.WatchUi as Ui;

class CoffeeCompassDelegate extends Ui.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
        Ui.pushView(new Rez.Menus.MainMenu(), new CoffeeCompassMenuDelegate(), Ui.SLIDE_UP);
        return true;
    }

    function onCoffeePress(){
        return true;
    }

}