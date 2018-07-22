using Toybox.WatchUi as Ui;
using Toybox.Communications as Comm;
using Toybox.System;
using Toybox.Position;

class CoffeeCompassDelegate extends Ui.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }
    
//    function headingToString( heading ) {
//        if( heading <= 22.5 and heading > -22.5 ) {
//            return "E";
//        } else if( heading <= 67.5 and heading > 22.5 ) {
//            return "NE";
//        } else if( heading <= 112.5 and heading > 67.5 ) {
//            return "N";
//        } else if( heading <= 157.5 and heading > 112.5 ) {
//            return "NW";
//        } else if( heading <= 202.5 and heading > 157.5 ) {
//            return "W";
//        } else if( heading <= 247.5 and heading > 202.5 ) {
//            return "SW";
//        } else if( heading >= -157.5 and heading <  ) {
//            return "S";
//        } else {
//            return "SE";
//        } 
//    }
    
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
    
    // callback for position data aquisition
    function onPosition( info ) {
        //var location = info.position.toDegrees();
	}
    
    function onCoffeePress() {
        queryFoursquare( "coffee", null, 1 );
        showLoadingScreen();
        var l1 = [ Math.toRadians( 39.14443 ), Math.toRadians( -94.579239 ) ];
        var l2 = [ Math.toRadians( 39.173702 ), Math.toRadians( -94.536979 ) ];
        var l3 = [ Math.toRadians( 39.142325 ), Math.toRadians( -94.64919 ) ];
        System.println( Math.toDegrees( bearingToTarget( l1[0], l1[1], l3[0], l3[1] ) ) );
        return true;
    }
    
    hidden var _fs_section;
    hidden var _fs_query;
    hidden var _fs_limit;
    
    function queryFoursquare( section, query, limit ) {
        _fs_section = section;
        _fs_query = query;
        _fs_limit = limit;
        Position.enableLocationEvents( Position.LOCATION_ONE_SHOT, method( :_queryFoursquare ) );
        _queryFoursquare( null );
    }
    
    function _queryFoursquare( info ) {
        
        // TODO uncomment this when uploading
        //var position = info.position.toRadians();
        var position = [ 39.14443, -94.579239 ];
        
        var ll = position[0].format("%.2f") + "," + position[1].format("%.2f");
        var url = "https://api.foursquare.com/v2/venues/explore";
        var params = {
            "client_id" => "Q0FXJ3D4IYOSCZI3TYDJH5Y1A3IK5GXPWBCVYVIXW2RHGNDN",
            "client_secret" => "45CSDE1CMHITQPRCLAEAUPGZRBFWAPX0XQRMCY4GZS0FZ4SW",
            "v" => 20180721,
            "ll" => ll,
            "radius" => 3000,
            "limit" => _fs_limit,
            "section" => _fs_section,
            "query" => _fs_query,
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