//
//  SimplePingHelper.m
//  LAN Scan
//
//  Created by Mongi Zaidi on 24 February 2014.
//  Copyright (c) 2014 Smart Touch. All rights reserved.
//

#import "SimplePingHelper.h"

@implementation SimplePingHelper
@synthesize simplePing, target, sel;

#pragma mark - Run it

// Pings the address, and calls the selector when done. Selector must take a NSnumber which is a bool for success
+ (void)ping:(NSString*)address target:(id)target sel:(SEL)sel
{
	// The helper retains itself through the timeout function
	[[[[SimplePingHelper alloc] initWithAddress:address target:target sel:sel] autorelease] go];
}

#pragma mark - Init/dealloc

- (void)dealloc
{
	self.simplePing = nil;
	self.target = nil;
	[super dealloc];
}

- (id)initWithAddress:(NSString*)address target:(id)_target sel:(SEL)_sel
{
	if (self = [self init]) {
		self.simplePing = [SimplePing simplePingWithHostName:address];
		self.simplePing.delegate = self;
		self.target = _target;
		self.sel = _sel;
	}
	return self;
}

#pragma mark - Go

- (void)go
{
	[self.simplePing start];
	[self performSelector:@selector(endTime) withObject:nil afterDelay:1]; // This timeout is what retains the ping helper
}

#pragma mark - Finishing and timing out

// Called on success or failure to clean up
- (void)killPing
{
	[self.simplePing stop];
	[[self.simplePing retain] autorelease]; // In case, higher up the call stack, this got called by the simpleping object itself
	self.simplePing = nil;
}

- (void)successPing:(NSString *)ip
{
	[self killPing];
	
    if([target respondsToSelector:@selector(pingResult:ip:)]){
        [target pingResult:[NSNumber numberWithBool:YES] ip:ip];
    } else {
        [target performSelector:sel withObject:[NSNumber numberWithBool:YES]];
    }
    
}

- (void)failPing:(NSString*)reason ip:(NSString *)ip
{
	[self killPing];
    
    if([target respondsToSelector:@selector(pingResult:ip:)]){
        [target pingResult:[NSNumber numberWithBool:NO] ip:ip];
    } else {
        [target performSelector:sel withObject:[NSNumber numberWithBool:NO]];
    }
}

// Called 1s after ping start, to check if it timed out
- (void)endTime
{
	if (self.simplePing) { // If it hasn't already been killed, then it's timed out
		[self failPing:@"timeout" ip:self.simplePing.hostName];
	}
}

#pragma mark - Pinger delegate

// When the pinger starts, send the ping immediately
- (void)simplePing:(SimplePing *)pinger didStartWithAddress:(NSData *)address
{
	[self.simplePing sendPingWithData:nil];
}

- (void)simplePing:(SimplePing *)pinger didFailWithError:(NSError *)error
{
	[self failPing:@"didFailWithError" ip:pinger.hostName];
}

- (void)simplePing:(SimplePing *)pinger didFailToSendPacket:(NSData *)packet error:(NSError *)error
{
	// Eg they're not connected to any network
	[self failPing:@"didFailToSendPacket" ip:pinger.hostName];
}

- (void)simplePing:(SimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet
{
	[self successPing:pinger.hostName];
}

@end
