//
//  POPDevice.m
//  PopcornTimeRemote
//
//  Created by Isak Wiström on 9/24/14.
//  Copyright (c) 2014 skaggivara. All rights reserved.
//

#import "POPDevice.h"

@implementation POPDevice


-(NSString *)validAddress
{
    if (!contains(self.address, @"http://")) {
        return [NSString stringWithFormat:@"http://%@", self.address];
    }
    return self.address;
}

-(void)save
{
    [[NSUserDefaults standardUserDefaults] setObject:self.address forKey:@"address"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)clearSavedAddress
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"address"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(POPDevice *)savedAddress
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *address = [defaults objectForKey:@"address"];
    
    if (address) {
        return [POPDevice deviceWithAddress:address];
    }
    
    return nil;
}

+(POPDevice *)deviceWithAddress:(NSString *)address
{
    POPDevice *device = [[POPDevice alloc] init];
    device.address = address;
    
    return device;
}

@end
