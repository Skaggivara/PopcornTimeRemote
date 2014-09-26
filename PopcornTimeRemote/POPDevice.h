//
//  POPDevice.h
//  PopcornTimeRemote
//
//  Created by Isak Wiström on 9/24/14.
//  Copyright (c) 2014 skaggivara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface POPDevice : NSObject

@property(copy) NSString *address;

+(POPDevice *)savedAddress;
+(POPDevice *)deviceWithAddress:(NSString *)address;
+(void)clearSavedAddress;

-(void)save;
-(NSString *)validAddress;

@end
