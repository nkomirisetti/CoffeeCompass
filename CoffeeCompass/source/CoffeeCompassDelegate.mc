using Toybox.WatchUi as Ui;
using Toybox.Communications as Comm;
using Toybox.System;

class CoffeeCompassDelegate extends Ui.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }
    
    function onCoffeePress(){
        System.println("button pressed");
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
    
    // Receive the data from the web request
    function onReceive(responseCode, data) {
        var output = null;
        if( responseCode != 200 ) {
            System.print( "ERROR: failed to get Foursquare data: " );
            System.println( responseCode );
        } else {
            output = convertFoursquare( data );
            System.println( output.toString() );
        }
        // TODO call something here
    }

    // Receive the data from the web request
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
	        this_output.put( "distance", location.get( "distance" ).toNumber() );
	    }
        return output;
    }
}