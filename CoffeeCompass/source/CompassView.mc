using Toybox.WatchUi as Ui;
using Toybox.Graphics;


class CompassView extends Ui.View {
var location;


    function initialize(locationData) {
    	Ui.View.initialize();
    	location = locationData;
    }


    //! Load your resources here
    function onLayout(dc) {
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_ORANGE);
        dc.clear();
        System.println("im getting here");
        
        var distanceLabel = new WatchUi.Text({
            :text=>"##.## mi NW",
            :color=>Graphics.COLOR_WHITE,
            :font=>Graphics.FONT_MEDIUM,
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_CENTER
        });
        
        
        var locName = new WatchUi.Text({
            :text=>location[0].get("name"),
            :color=>Graphics.COLOR_WHITE,
            :font=>Graphics.FONT_XTINY,
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>150
        });
        
        distanceLabel.draw(dc);
        locName.draw(dc);
       
        
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    }
}