var http = require( "http" );
var https = require( "https" );
var url = require( "url" );
var util = require( "util" );
var childprocess = require( "child_process" );

var server = http.createServer( );

server.on( "request",
	function onRequest( request, response ){

		var urlObject = url.parse( request.url, true );
		console.log( "Request recieved!" + JSON.stringify( urlObject ) );
		switch( urlObject.pathname ){
			case "/repository/check/exists":
				var projectNamespace = urlObject.query.projectNamespace;
				https.get( "https://github.com/" + projectNamespace + "/archive/master.zip",
					function onResponse( gitResponse ){
						response.writeHead( 200, {
							"Content-Type": "text/plain"
						} );
						console.log( gitResponse.statusCode );
						if( gitResponse.statusCode == 302 ){
							response.end( "true" );
						}else{
							response.end( "false" );
						}
					} );
				break;

			default: 
				response.writeHead( 200, {
					"Content-Type": "text/plain"
				} );
				response.end( "false" );
		}
	} );

server.on( "listening",
	function onListening( ){
		console.log( "Server is alive!" );
	} );

server.listen( 8080 );