using Toybox.WatchUi as Ui;
using Toybox.Communications as Comm;
using Toybox.System;
using Toybox.Position;

class CoffeeCompassDelegate extends Ui.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }
    
    // latitude and longitude must be in radians
    function distanceToTarget( user_lat, user_lng, target_lat, target_lng ) {
        if( target_lat == user_lat or target_lng == user_lng ) {
            return 0;
        }
        var x = ( target_lng - user_lng ) * Math.cos( ( target_lat + user_lat ) / 2 );
        var y = ( target_lat - user_lat );
        return Math.sqrt( ( x * x ) + ( y * y ) ) * 6371000;
    }
    
    // callback for position data aquisition
    function onPosition( info ) {
        //var location = info.position.toDegrees();
	}
    
    function onCoffeePress() {
        queryFoursquare( "coffee", null, 1 );
        showLoadingScreen();
        return true;
    }
    
    function queryFoursquare( section, query, limit ) {
        var url = "https://api.foursquare.com/v2/venues/explore";
        var params = {
            "client_id" => "Q0FXJ3D4IYOSCZI3TYDJH5Y1A3IK5GXPWBCVYVIXW2RHGNDN",
            "client_secret" => "45CSDE1CMHITQPRCLAEAUPGZRBFWAPX0XQRMCY4GZS0FZ4SW",
            "v" => 20180721,
            "ll" => "39.13,-94.57",
            "radius" => 3000,
            "limit" => limit,
            "section" => section,
            "query" => query,
            "openNow" => 1     
        };
        var options = {
           :method => Communications.HTTP_REQUEST_METHOD_GET,
           :headers => {
               "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED
           },
           :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };
        
        Comm.makeWebRequest(
            url,
            params,
            options,
            method(:onReceive)
        );
    }
    
    // show the loading screen now that venues are being loaded
    function showLoadingScreen() {
        return true;
    }
    
    // an error occurred while loading venues
    function onLoadingFailed( responseCode ) {
        System.print( "ERROR: failed to get Foursquare data: " );
        System.println( responseCode );
    }
    
    // no venues were found nearby
    function onNoVenues() {
        
    }
    
    // at least one venue was successfully loaded
    function onLoadingSuccess( data ) {
        System.println( data.toString() );
    }
    
    // receive the data from the web request
    function onReceive(responseCode, data) {
        if( responseCode != 200 ) {
            onLoadingFailed( responseCode );
        } else {
            var output = convertFoursquare( data );
            if( output.size() > 0 ) {
                onLoadingSuccess( output );
            } else {
                onNoVenues();
            }           
        }
    }

    // format Foursquare data
    function convertFoursquare( data ) {
	    var items = data.get( "response" ).get( "groups" )[0].get( "items" );
	    var items_size = items.size();
	    var output = new [ items_size ];
	    for( var i = 0; i < items_size; i++ ) {
	        output[ i ] = {};
	        var this_output = output[ i ];
	        var venue = items[ i ].get( "venue" );
	        var location = venue.get( "location" );
	        this_output.put( "name", venue.get( "name" ) );
	        this_output.put( "address", location.get( "address" ) );
	        this_output.put( "lat", location.get( "lat" ).toFloat() );
	        this_output.put( "lng", location.get( "lng" ).toFloat() );
	    }
        return output;
    }
}