//
//  POPNetworking.h
//  PopcornTimeRemote
//
//  Created by Isak Wiström on 9/23/14.
//  Copyright (c) 2014 skaggivara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFJSONRPCClient.h"

@interface POPNetworking : NSObject

@property(strong) AFJSONRPCClient *client;
@property(strong) AFJSONRPCClient *listenClient;


- (void)connect:(NSString *)host port:(int)port user:(NSString *)user password:(NSString *)password;
- (void)send:(NSString *)method params:(NSArray *)params;
- (void)send:(NSString *)method params:(NSArray *)params
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (NSString *)getIPAddress;
+ (int)getIPAddressLastPosition;

+ (void)validatePopcorn:(NSString *)host port:(int)port user:(NSString *)user password:(NSString *)password
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure;



@end
