using Toybox.WatchUi as Ui;
using Toybox.Graphics;


class CompassView extends Ui.View {
var location;
var position = [ 0, 0 ];

    function initialize(locationData) {
    	Ui.View.initialize();
    	location = locationData;
    }

    //! Load your resources here
    function onLayout(dc) {
        Position.enableLocationEvents( Position.LOCATION_CONTINUOUS, method( :locationUpdate ) );
        position = [ 39.14443, -94.579239 ];
    }
    
    function locationUpdate( info ) {
        position = info.position.toRadians();
    }
    
    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    }

    function metersToMiles( meters ) {
        return meters * 0.0006213712;
    }
    
    // latitude and longitude must be in radians
    function bearingToTarget( user_lat, user_lng, target_lat, target_lng ) {
        var y = Math.sin( target_lng - user_lng ) * Math.cos( target_lat );
        var x = Math.cos( user_lat ) * Math.sin( target_lat ) - Math.sin( user_lat ) * Math.cos( target_lat ) * Math.cos( target_lng - user_lng );
        return Math.atan2( x, y );
    }
    
    // latitude and longitude must be in radians
    function distanceToTarget( user_lat, user_lng, target_lat, target_lng ) {
        var x = ( target_lng - user_lng ) * Math.cos( ( target_lat + user_lat ) / 2 );
        var y = ( target_lat - user_lat );
        return Math.sqrt( ( x * x ) + ( y * y ) ) * 6371000;
    }

    //! Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_ORANGE);
        dc.clear();
        System.println("im getting here");
        
        System.println( location.toString() );
        
        var distance_value = distanceToTarget( 
            Math.toRadians( position[0] ), Math.toRadians( position[1] ), 
            Math.toRadians( location[0].get( "lat" ) ), Math.toRadians( location[0].get( "lng" ) )
        );
        distance_value = metersToMiles( distance_value );
        
        var bearing_value = bearingToTarget(
            Math.toRadians( position[0] ), Math.toRadians( position[1] ), 
            Math.toRadians( location[0].get( "lat" ) ), Math.toRadians( location[0].get( "lng" ) )
        );
        
        var distanceLabel = new WatchUi.Text({
            :text=> distance_value.format("%.1f") + " Miles",
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