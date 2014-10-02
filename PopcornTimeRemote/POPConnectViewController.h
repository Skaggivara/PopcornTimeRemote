//
//  POPConnectViewController.h
//  PopcornTimeRemote
//
//  Created by Isak Wiström on 9/23/14.
//  Copyright (c) 2014 skaggivara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POPNetworking.h"

#import "POPTypeSwitchView.h"
#import "POPControlView.h"
#import "POPFilterSelectView.h"
#import "POPFilterListView.h"


typedef enum {
    
    POPCornTimeRemoteTypeMovie,
    POPCornTimeRemoteTypeSeries
    
} POPCornTimeRemoteType;

@interface POPConnectViewController : UIViewController <POPControlViewDelegate, POPFilterSelectViewDelegate, POPTypeSwitchViewDelegate, POPFilterListViewDelegate, UISearchBarDelegate>

@property(strong) POPNetworking *listener;

@property(strong) POPTypeSwitchView *typeSwitch;
@property(strong) POPControlView *control;

@property(strong) UIButton *playToggle;
@property(strong) UIButton *tvSeriesPrev;
@property(strong) UIButton *tvSeriesNext;
@property(strong) UIButton *cover;

@property(strong) POPFilterSelectView *category;
@property(strong) POPFilterSelectView *sort;

@property(strong) POPFilterListView *categoryList;
@property(strong) POPFilterListView *sortList;

@property(strong) NSArray *genres;
@property(strong) NSArray *ordering;
@property(strong) NSArray *genres_tv;
@property(strong) NSArray *ordering_tv;

@property POPCornTimeRemoteType mode;

@property NSMutableArray *currentViewStack;

@property(copy) NSString *host;
@property int port;
@property(copy) NSString *user;
@property(copy) NSString *pass;

@property(strong) NSMutableData *listenChunks;
@property(strong) NSURLConnection *listenConnection;

@property BOOL hasSearched;

@property BOOL fixSeriesNavBug;
@property BOOL fixSeriesNavBugActive;

@property(strong, nonatomic) UISearchBar* searchBar;

@property(strong) NSTimer *viewStackTimer;

@property float volume;

- (id)initWithHost:(NSString *)host port:(int)port user:(NSString *)user password:(NSString *)password;
- (void)updateViewStackWithDelay:(float)delay;

@end
