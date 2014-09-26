//
//  SimplePingHelper.h
//  LAN Scan
//
//  Created by Mongi Zaidi on 24 February 2014.
//  Copyright (c) 2014 Smart Touch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimplePing.h"


@class SimplePingHelper;

@protocol SimplePingHelperDelegate <NSObject>
@optional
- (void)pingResult:(NSNumber*)success ip:(NSString *)ip;
@end

@interface SimplePingHelper : NSObject <SimplePingDelegate>

@property(nonatomic,retain) SimplePing* simplePing;
@property(nonatomic,retain) id target;
@property(nonatomic,assign) SEL sel;

- (id)initWithAddress:(NSString*)address target:(id)_target sel:(SEL)_sel;
- (void)go;

+ (void)ping:(NSString*)address target:(id)target sel:(SEL)sel;

@end
