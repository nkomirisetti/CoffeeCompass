using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class ListMenuDelegate extends Ui.MenuInputDelegate {
var location;
    function initialize(locationData) {
        MenuInputDelegate.initialize();
        location = locationData;
    }

    function onMenuItem(item) {
    System.println("I'm being selected");
        if (item == :one) {
            Sys.println(location[0].get("name"));
            //Ui.pushView(new Rez.Menus.AuxMenu(), new AuxMenuDelegate(), Ui.SLIDE_UP);
        } else if (item == :two) {
            Sys.println(location[1].get("name"));
        } else if (item == :three) {
            Sys.println(location[2].get("name"));
        }
    }
}
