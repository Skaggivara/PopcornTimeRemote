//
//  POPNetworking.m
//  PopcornTimeRemote
//
//  Created by Isak Wiström on 9/23/14.
//  Copyright (c) 2014 skaggivara. All rights reserved.
//

#import "POPNetworking.h"
#import <ifaddrs.h>
#import <arpa/inet.h>

@implementation POPNetworking

/*
 
 server.expose('ping', function(args, opt, callback) {
 callback();
 });
 
 server.expose('setvolume', function(args, opt, callback) {
 var volume = parseFloat(args[0]) || App.Player.volume();
 App.PlayerView.player.volume(volume);
 callback();
 });
 
 server.expose('toggleplaying', function(args, opt, callback) {
 Mousetrap.trigger('space');
 callback();
 });
 
 server.expose('togglemute', function(args, opt, callback) {
 Mousetrap.trigger('m');
 callback();
 });
 
 server.expose('togglefullscreen', function(args, opt, callback) {
 Mousetrap.trigger('f');
 callback();
 });
 
 server.expose('togglefavourite', function(args, opt, callback) {
 Mousetrap.trigger('f');
 callback();
 });
 
 server.expose('togglemoviesshows', function(args, opt, callback) {
 Mousetrap.trigger('tab');
 callback();
 });
 
 server.expose('togglewatched', function(args, opt, callback) {
 Mousetrap.trigger('w');
 callback();
 });
 
 server.expose('showslist', function(args, opt, callback) {
 App.vent.trigger('shows:list');
 callback();
 });
 
 server.expose('movieslist', function(args, opt, callback) {
 App.vent.trigger('movies:list');
 callback();
 });
 
 server.expose('getviewstack', function(args, opt, callback) {
 callback(false, [App.ViewStack]);
 });
 
 //Filter Bar
 server.expose('getgenres', function(args, opt, callback) {
 callback(false, [App.Config.genres]);
 });
 
 server.expose('getgenres_tv', function(args, opt, callback) {
 callback(false, [App.Config.genres_tv]);
 });
 
 server.expose('getsorters', function(args, opt, callback) {
 callback(false, [App.Config.sorters]);
 });
 
 server.expose('getsorters_tv', function(args, opt, callback) {
 callback(false, [App.Config.sorters_tv]);
 });
 
 server.expose('filtergenre', function(args, opt, callback) {
 $('.genres .dropdown-menu a[data-value=' + args[0] + ']').click();
 callback();
 });
 
 server.expose('filtersorter', function(args, opt, callback) {
 $('.sorters .dropdown-menu a[data-value=' + args[0] + ']').click();
 callback();
 });
 
 server.expose('filtersearch', function(args, opt, callback) {
 $('#searchbox').val(args[0]);
 $('.search form').submit();
 callback();
 });
 
 server.expose('clearsearch', function(args, opt, callback) {
 $('.remove-search').click();
 });
 
 //Standard controls
 server.expose('seek', function(args, opt, callback) {
 App.PlayerView.seek(parseFloat(args[0]));
 callback();
 });
 
 server.expose('up', function(args, opt, callback) {
 Mousetrap.trigger('up');
 callback();
 });
 
 server.expose('down', function(args, opt, callback) {
 Mousetrap.trigger('down');
 callback();
 });
 
 server.expose('left', function(args, opt, callback) {
 Mousetrap.trigger('left');
 callback();
 });
 
 server.expose('right', function(args, opt, callback) {
 Mousetrap.trigger('right');
 callback();
 });
 
 server.expose('enter', function(args, opt, callback) {
 Mousetrap.trigger('enter');
 callback();
 });
 
 server.expose('back', function(args, opt, callback) {
 Mousetrap.trigger('backspace');
 callback();
 });
 
 server.expose('quality', function(args, opt, callback) {
 Mousetrap.trigger('q');
 callback();
 });
 
 server.expose('previousseason', function(args, opt, callback) {
 Mousetrap.trigger('ctrl+up');
 callback();
 });
 
 server.expose('nextseason', function(args, opt, callback) {
 Mousetrap.trigger('ctrl+down');
 callback();
 });
 
 server.expose('subtitleoffset', function(args, opt, callback) {
 App.PlayerView.adjustSubtitleOffset(parseFloat(args[0]));
 callback();
 });
 
 server.expose('getsubtitles', function(args, opt, callback) {
 callback(false, [_.keys(App.MovieDetailView.model.get('subtitle'))]);
 });
 
 server.expose('setsubtitle', function(args, opt, callback) {
 App.MovieDetailView.switchSubtitle(args[0]);
 });

 */

-(void)connect:(NSString *)host port:(int)port user:(NSString *)user password:(NSString *)password
{
    
    NSString *url = [NSString stringWithFormat:@"%@:%i", host, port];
    
    if(!contains(url, @"http://")){
        url = [NSString stringWithFormat:@"http://%@", url];
    }
    
    if (!self.client) {
        self.client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:url]];
        [self.client.requestSerializer setAuthorizationHeaderFieldWithUsername:user password:password];
    }
}

-(void)send:(NSString *)method
{
    [self.client invokeMethod:method
                      success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         NSLog(@"method was invoked");
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"method was NO invoked %@", error.description);
         
     }];
}
-(void)send:(NSString *)method params:(NSArray *)params
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self.client invokeMethod:method
               withParameters:params
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          if(success){
                              success(operation, responseObject);
                          }
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          if(failure){
                              failure(operation, error);
                          }
                      }];
}

-(void)send:(NSString *)method params:(NSArray *)params
{
    if(self.client){
        
        /*
        - (void)invokeMethod:(NSString *)method
    withParameters:(id)parameters
    requestId:(id)requestId
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
        {*/
        
        // Invocation with Parameters and Request ID
        /// Invocation with Parameters and Request ID
        
        if(params){
        [self.client invokeMethod:method
                   withParameters:params
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              NSLog(@"method was invoked\n");
                          }
                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              NSLog(@"method was NOT invoked: %@\n", error.description);
                          }];
        }else{
        
            [self send:method];
        }
    }
}

- (void)findPopcornTime
{
    // my ip
    
    NSLog(@"IP:%@", [POPNetworking getIPAddress]);
}


+ (void)validatePopcorn:(NSString *)host
                   port:(int)port
                   user:(NSString *)user
               password:(NSString *)password
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure
{
    NSString *url = [NSString stringWithFormat:@"%@:%i", host, port];
    
    if(!contains(url, @"http://")){
        url = [NSString stringWithFormat:@"http://%@", url];
    }
    
    AFJSONRPCClient *client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:url]];
    [client.requestSerializer setAuthorizationHeaderFieldWithUsername:user password:password];
    [client.requestSerializer setTimeoutInterval:2];
    
    [client invokeMethod:@"getviewstack"
                      success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if(success){
             success(responseObject);
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if(failure){
             failure(error);
         }
         
     }];
    
}

- (void)listen:(NSString *)host
          port:(int)port
          user:(NSString *)user
      password:(NSString *)password
       success:(void (^)(id responseObject))success
       failure:(void (^)(NSError *error))failure
{
    
    NSString *url = [NSString stringWithFormat:@"%@:%i", host, port];
    
    if (!contains(url, @"http://")) {
        url = [NSString stringWithFormat:@"http://%@", url];
    }
    
    if (!self.listenClient) {
        self.listenClient = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:url]];
    }
    
    [self.listenClient.requestSerializer setAuthorizationHeaderFieldWithUsername:user password:password];
    [self.listenClient.requestSerializer setTimeoutInterval:300];
    
    [self.listenClient invokeMethod:@"listennotifications"
                 success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if(success){
             
             NSLog(@"GOT NEW RESPONSE");
             success(responseObject);
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if(failure){
             failure(error);
             // error
             NSLog(@"GOT NEW ERROR");
         }
         
     }];
}

- (void)stopListen
{
    if (self.listenClient) {
        //[self.listenClient.client
    }
}


// Get IP Address
+ (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}

+ (int)getIPAddressLastPosition {
    NSString *address = [POPNetworking getIPAddress];
    
    NSArray *a = [address componentsSeparatedByString:@"."];
    
    if(a.count > 0){
        NSString *last = [a objectAtIndex:(a.count-1)];
        
        return last.intValue;
    }
    
    return 2;
}


@end
