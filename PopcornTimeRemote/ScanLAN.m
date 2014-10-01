//
//  ScanLAN.m
//  LAN Scan
//
//  Created by Mongi Zaidi on 24 February 2014.
//  Copyright (c) 2014 Smart Touch. All rights reserved.
//

#import "ScanLAN.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#include <netdb.h>
#import "SimplePingHelper.h"

@implementation ScanLAN

- (id)initWithDelegate:(id<ScanLANDelegate>)delegate
{
    NSLog(@"init scanner");
    self = [super init];
    if (self) {
        self.scanned = 0;
        self.ignore = -1;
		self.delegate = delegate;
    }
    return self;
}

- (void)startScan
{
    self.scanned = 0;
    self.localAddress = [self localIPAddress];
    //This is used to test on the simulator
    //self.localAddress = @"192.168.1.8";
    
    //self.netMask = @"255.255.255.0";
    NSArray *a = [self.localAddress componentsSeparatedByString:@"."];
    NSArray *b = [self.netMask componentsSeparatedByString:@"."];
    if ([self isIpAddressValid:self.localAddress] && (a.count == 4) && (b.count == 4)) {
        for (int i = 0; i<3; i++) {
            int and = (int)[[a objectAtIndex:i] integerValue] & [[b objectAtIndex:i] integerValue];
            
            if (!self.baseAddress.length) {
                self.baseAddress = [NSString stringWithFormat:@"%i", and];
            }
            else {
                self.baseAddress = [NSString stringWithFormat:@"%@.%i", self.baseAddress, and];
                self.currentHostAddress = and;
                self.baseAddressEnd = and;
            }
        }
        
        self.currentHostAddress = 0; // whis will start us of on 1
        self.baseAddress = [NSString stringWithFormat:@"%@.", self.baseAddress];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(pingAddress) userInfo:nil repeats:YES];
    }
}

- (void)startScanFrom:(NSString *)address location:(int)location
{
    
    NSLog(@"Starting scan from: %@%i", address, location);
    
    self.baseAddress = address;
    self.offsetStart = YES;
    self.upComplete = NO;
    self.scanDirection = 1;
    self.downComplete = NO;
    self.currentHostAddressDown = location;
    self.currentHostAddressUp = location;
    
    if (location == 254) {
        self.scanDirection = -1;
        self.upComplete = YES;
    }
    
    if (location == 1) {
        self.downComplete = YES;
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(pingAddress) userInfo:nil repeats:YES];
    
}

- (void)startScanFromIP:(NSString *)address
{
    if ([self isIpAddressValid:address]) {
        NSMutableArray *a = [[address componentsSeparatedByString:@"."] mutableCopy];
        if (a.count == 4) {
            NSString *last = [NSString stringWithString:[a lastObject]];
            [a removeLastObject];
            NSString *joinedString = [a componentsJoinedByString:@"."];
            [self startScanFrom:[NSString stringWithFormat:@"%@.", joinedString] location:last.intValue];
        }
    }
    
}
- (void)updateProgress
{
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(scanLANProgress:)]) {
            float max = 254.0;
            if (self.ignore > -1 || self.offsetStart) {
                max = 253.0;
            }
            [self.delegate scanLANProgress:(self.scanned/max)];
        }
    }
}

- (void)stopScan
{
    [self.timer invalidate];
}

- (void)pingAddressAt:(int)location
{
    if (self.ignore != location) {
        NSString *address = [NSString stringWithFormat:@"%@%i", self.baseAddress, location];
        [SimplePingHelper ping:address target:self sel:@selector(pingResult:ip:)];
    }
}

- (void)pingAddress
{
    int pingAdress;
    
    if (self.offsetStart) { // we started at an offset
        
        if (self.scanDirection == 1 || self.downComplete) {
            
            self.currentHostAddressUp++;
            pingAdress = (int)self.currentHostAddressUp;
            
            if(self.currentHostAddressUp >= 254){
                self.upComplete = YES;
            
                if(self.downComplete){
                   [self.timer invalidate];
                }
            }
            
            if (!self.downComplete) {
                self.scanDirection = -1;
            }
            
        } else {
            
            self.currentHostAddressDown--;
            pingAdress = (int)self.currentHostAddressDown;
            
            if (self.currentHostAddressDown <= 1) {
                self.downComplete = YES;
                
                if (self.upComplete) {
                    [self.timer invalidate];
                }
            }

            if (!self.upComplete) {
                self.scanDirection = 1;
            }
        }
        
    } else {
        self.currentHostAddress++;
        pingAdress = (int)self.currentHostAddress;
    }
    
    if (self.ignore != pingAdress) {
        
        NSString *address = [NSString stringWithFormat:@"%@%i", self.baseAddress, pingAdress];

        [SimplePingHelper ping:address target:self sel:@selector(pingResult:ip:)];
        
        // double check this
        if (pingAdress >= 254) {
            [self.timer invalidate];
        }
    }
}

/*
 - (void)pingAddress:(NSString *)address{
 [SimplePingHelper ping:address target:self sel:@selector(pingResult:)];
 }
 */

// here we need to know if we are going up or down

- (void)pingResult:(NSNumber*)success ip:(NSString *)ip
{
    self.timerIterationNumber++;
    self.scanned++;
    if (success.boolValue) {
        NSString *deviceIPAddress = [[[[NSString stringWithFormat:@"%@", ip] stringByReplacingOccurrencesOfString:@".0" withString:@"."] stringByReplacingOccurrencesOfString:@".00" withString:@"."] stringByReplacingOccurrencesOfString:@".." withString:@".0."];
        NSString *deviceName = [self getHostFromIPAddress:[[NSString stringWithFormat:@"%@", ip] cStringUsingEncoding:NSASCIIStringEncoding]];
        if(self.delegate){
            if([self.delegate respondsToSelector:@selector(scanLANDidFindNewAddress:havingHostName:)]){
                [self.delegate scanLANDidFindNewAddress:deviceIPAddress havingHostName:deviceName];
            }
        }
    }
    
    int max = 254;
    
    if (self.ignore > -1 || self.offsetStart) {
        max = 253;
    }
    
    if (self.scanned >= max) {
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(scanLANDidFinishScanning)]) {
                [self.delegate scanLANDidFinishScanning];
            }
        }
    }
    
    [self updateProgress];
}

- (NSString *)getHostFromIPAddress:(const char*)ipAddress
{
    NSString *hostName = nil;
    int error;
    struct addrinfo *results = NULL;
    
    error = getaddrinfo(ipAddress, NULL, NULL, &results);
    if (error != 0) {
        NSLog (@"Could not get any info for the address");
        return nil; // or exit(1);
    }
    
    for (struct addrinfo *r = results; r; r = r->ai_next) {
        char hostname[NI_MAXHOST] = {0};
        error = getnameinfo(r->ai_addr, r->ai_addrlen, hostname, sizeof hostname, NULL, 0 , 0);
        if (error != 0) {
            continue; // try next one
        } else {
            //NSLog (@"Found hostname: %s", hostname);
            hostName = [NSString stringWithFormat:@"%s", hostname];
            break;
        }
        freeaddrinfo(results);
    }
    return hostName;
}

// Get IP Address
- (NSString *)getIPAddress
{
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    NSString *wifiAddress = nil;
    NSString *cellAddress = nil;
    
    // retrieve the current interfaces - returns 0 on success
    if (!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            sa_family_t sa_type = temp_addr->ifa_addr->sa_family;
            if (sa_type == AF_INET || sa_type == AF_INET6) {
                NSString *name = [NSString stringWithUTF8String:temp_addr->ifa_name];
                NSString *addr = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]; // pdp_ip0
                //NSLog(@"NAME: \"%@\" addr: %@", name, addr); // see for yourself
                
                if ([name isEqualToString:@"en0"]) {
                    // Interface is the wifi connection on the iPhone
                    wifiAddress = addr;
                } else if([name isEqualToString:@"pdp_ip0"]) {
                    // Interface is the cell connection on the iPhone
                    cellAddress = addr;
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    
    NSString *addr = wifiAddress ? wifiAddress : cellAddress;
    return addr ? addr : @"0.0.0.0";
}

- (NSString *)localIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    
    if (success == 0) {
        temp_addr = interfaces;
        
        while (temp_addr != NULL) {
            // check if interface is en0 which is the wifi connection on the iPhone
            if (temp_addr->ifa_addr->sa_family == AF_INET) {
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    self.netMask = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    
    return address;
}

- (BOOL)isIpAddressValid:(NSString *)ipAddress
{
    struct in_addr pin;
    int success = inet_aton([ipAddress UTF8String],&pin);
    if (success == 1) return TRUE;
    return FALSE;
}

@end
