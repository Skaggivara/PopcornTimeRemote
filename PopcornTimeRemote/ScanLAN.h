//
//  ScanLAN.h
//  LAN Scan
//
//  Created by Mongi Zaidi on 24 February 2014.
//  Copyright (c) 2014 Smart Touch. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ScanLAN;

@protocol ScanLANDelegate <NSObject>

@optional
- (void)scanLANDidFindNewAddress:(NSString *)address havingHostName:(NSString *)hostName;
- (void)scanLANDidFinishScanning;
- (void)scanLANProgress:(float)progress;
@end

@interface ScanLAN : NSObject

@property NSString *localAddress;
@property NSString *baseAddress;
@property NSInteger currentHostAddress;
@property NSInteger currentHostAddressUp;
@property NSInteger currentHostAddressDown;
@property NSTimer *timer;
@property NSString *netMask;
@property NSInteger baseAddressEnd;
@property NSInteger timerIterationNumber;
@property int ignore;
@property BOOL offsetStart;
@property int scanDirection;
@property int scanned;
@property BOOL upComplete;
@property BOOL downComplete;

@property(nonatomic,weak) id<ScanLANDelegate> delegate;

- (id)initWithDelegate:(id<ScanLANDelegate>)delegate;
- (void)startScan;
- (void)startScanFrom:(NSString *)address location:(int)location;
- (void)startScanFromIP:(NSString *)address;
- (void)stopScan;
- (BOOL) isIpAddressValid:(NSString *)ipAddress;

@end
