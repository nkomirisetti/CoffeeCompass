using Toybox.WatchUi as Ui;


class ListDelegate extends Ui.BehaviorDelegate{

    var locationsData;

    function initialize(locations) {
        BehaviorDelegate.initialize();
        locationsData = locations;
        System.println("I made it to the delegate");
    }

    function onMenu() {
        var menu = new WatchUi.Menu();
        var delegate;
        menu.setTitle("My Menu");
        menu.addItem(locationsData[0].get("name"), :one);
        if (locationsData.size() > 1){
            menu.addItem(locationsData[1].get("name"), :two);
            if(locationsData.size() > 2){
              menu.addItem(locationsData[2].get("name"), :three);
            }
        }
        delegate = new ListMenuDelegate(locationsData); // a WatchUi.MenuInputDelegate
        WatchUi.pushView(menu, delegate, SLIDE_IMMEDIATE);
        return true;
    }
}