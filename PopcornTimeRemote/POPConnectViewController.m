//
//  POPConnectViewController.m
//  PopcornTimeRemote
//
//  Created by Isak Wiström on 9/23/14.
//  Copyright (c) 2014 skaggivara. All rights reserved.
//

#import "POPConnectViewController.h"
#import "POPControlView.h"
#import "POPTypeSwitchView.h"
#import "MBProgressHUD.h"
//#import "AFRocketClient.h"

@interface POPConnectViewController ()

@end

@implementation POPConnectViewController

- (id)initWithHost:(NSString *)host
              port:(int)port
              user:(NSString *)user
          password:(NSString *)password
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        self.host = host;
        self.port = port;
        self.user = user;
        self.pass = password;
        self.mode = POPCornTimeRemoteTypeMovie;
        self.currentViewStack = [@[@"main-browser"] mutableCopy];
        self.volume = 0.8;
        
        // Remove this once series nav bug is fixed in PopcornTime
        self.fixSeriesNavBug = kBugFix;
    }
    return self;
}

- (void)loadView
{
    // lets build
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view setBackgroundColor:UIColorFromRGB(kBackgroundColor)];
    
    //
    
    self.control = [[POPControlView alloc] initWithFrame:CGRectMake(20, (self.view.frame.size.height - 64) - 362, 280, 280)];
    self.control.delegate = self;
    [self.view addSubview:self.control];
    
    //
    self.typeSwitch = [[POPTypeSwitchView alloc] initWithFrameAndTitles:CGRectMake(0, 0, self.view.frame.size.width, 44) titles:@[NSLocalizedString(@"Movies", nil), NSLocalizedString(@"TV Series", nil)]];
    self.typeSwitch.delegate = self;
    [self.view addSubview:self.typeSwitch];
    
    //
    
    self.playToggle = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playToggle setTitle:NSLocalizedString(@"Toggle Playstate", nil) forState:UIControlStateNormal];
    [self.playToggle setTitleColor:UIColorFromRGB(kBackgroundColor) forState:UIControlStateNormal];
    [self.playToggle setBackgroundColor:UIColorFromRGB(kDefaultColor)];
    
    [self.playToggle addTarget:self action:@selector(handlePlay) forControlEvents:UIControlEventTouchUpInside];
    
    self.playToggle.frame = CGRectMake(0, (self.view.frame.size.height - 64) - 62, self.view.frame.size.width, 62);
    self.playToggle.alpha = 0.0;
    
    [self.view addSubview:self.playToggle];
    
    //
    
    self.tvSeriesPrev = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tvSeriesPrev setTitle:NSLocalizedString(@"Prev season", nil) forState:UIControlStateNormal];
    self.tvSeriesPrev.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.tvSeriesPrev setTitleColor:UIColorFromRGB(kDefaultColor) forState:UIControlStateNormal];
    self.tvSeriesPrev.frame = CGRectMake(20, 100, 140, 30);
    [self.tvSeriesPrev addTarget:self action:@selector(handleSeriesNav:) forControlEvents:UIControlEventTouchUpInside];
    [self.tvSeriesPrev setHidden:YES];
    
    [self.view addSubview:self.tvSeriesPrev];
    
    //
    self.tvSeriesNext = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tvSeriesNext setTitle:NSLocalizedString(@"Next season", nil) forState:UIControlStateNormal];
    self.tvSeriesNext.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.tvSeriesNext setTitleColor:UIColorFromRGB(kDefaultColor) forState:UIControlStateNormal];
    self.tvSeriesNext.frame = CGRectMake(160, 100, 140, 30);
    [self.tvSeriesNext addTarget:self action:@selector(handleSeriesNav:) forControlEvents:UIControlEventTouchUpInside];
    [self.tvSeriesNext setHidden:YES];
    
    [self.view addSubview:self.tvSeriesNext];
    
    //
    
    self.category = [[POPFilterSelectView alloc] initWithFrameAndTitle:CGRectMake(20, 60, 140, 30) title:NSLocalizedString(@"Genre", nil) filter:@"All"];
    self.category.delegate = self;
    
    [self.view addSubview:self.category];
    
    //
    
    self.sort = [[POPFilterSelectView alloc] initWithFrameAndTitle:CGRectMake(160, 60, 140, 30) title:NSLocalizedString(@"Sort by", nil) filter:@"Popularity"];
    self.sort.delegate = self;
    
    [self.view addSubview:self.sort];
    
    //
    self.genres = @[@"All", @"Action", @"Adventure", @"Animation", @"Biography", @"Comedy", @"Crime", @"Documentary", @"Drama", @"Family", @"Fantasy", @"Film-Noir", @"History", @"Horror", @"Music", @"Musical", @"Mystery", @"Romance", @"Sci-Fi", @"Short", @"Sport", @"Thriller", @"War", @"Western"];
    self.genres_tv = @[@"All", @"Action", @"Adventure", @"Animation", @"Children", @"Comedy", @"Crime", @"Documentary", @"Drama", @"Family", @"Fantasy", @"Game Show", @"Home And Garden", @"Horror", @"Mini Series", @"Mystery", @"News", @"Reality", @"Romance", @"Science Fiction", @"Soap", @"Special Interest", @"Sport", @"Suspense", @"Talk Show", @"Thriller", @"Western"];
    
    
    self.categoryList = [[POPFilterListView alloc] initWithFrameAndFilters:CGRectMake(0, 0, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height) filters:self.genres];
    self.categoryList.delegate = self;
    
    [self.navigationController.view addSubview:self.categoryList];
    
    //
    self.ordering = @[@"Popularity", @"Date", @"Year", @"Rating"];
    self.ordering_tv = @[@"Popularity", @"Updated", @"Year", @"Name"];
    
    self.sortList = [[POPFilterListView alloc] initWithFrameAndFilters:CGRectMake(0, 0, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height) filters:self.ordering];
    self.sortList.delegate = self;
    
    [self.navigationController.view addSubview:self.sortList];
    
    //
    
    self.cover = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cover setFrame:self.view.bounds];
    self.cover.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    self.cover.alpha = 0;
    self.cover.userInteractionEnabled = NO;
    [self.cover addTarget:self action:@selector(handleCover) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.cover];
    
    //
    
    [self setTitle:NSLocalizedString(@"Popcorn Time Remote", nil)];
}


- (void)handleCover
{
    [self hideSearch];
    [self hideCover];
}

- (void)hideCover
{
    self.cover.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.cover.alpha = 0.0;
    }];
}

- (void)showCover
{
    self.cover.userInteractionEnabled = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.cover.alpha = 1.0;
    }];
}

- (void)handleSeriesNav:(id)sender
{
    if (sender == self.tvSeriesNext) {
        if (self.listener) {
            [self.listener send:@"nextseason" params:nil];
        }
    } else if(sender == self.tvSeriesPrev) {
        if (self.listener) {
            [self.listener send:@"previousseason" params:nil];
        }
    }
}

- (void)selectedFilter:(POPFilterListView *)filter
                 index:(int)index
{
    //
    
    if (filter == self.categoryList) {
        
        if (self.mode == POPCornTimeRemoteTypeMovie){
            
            NSLog(@"genre: %@", [self.genres objectAtIndex:index]);
            [self.category setFilterName:[self.genres objectAtIndex:index]];
        
            [self sendCommand:@"filtergenre" params:@[[self.genres objectAtIndex:index]]];
            
        } else if(self.mode == POPCornTimeRemoteTypeSeries) {
            
            NSLog(@"genre: %@", [self.genres_tv objectAtIndex:index]);
            [self.category setFilterName:[self.genres_tv objectAtIndex:index]];
            
            [self sendCommand:@"filtergenre" params:@[[self.genres_tv objectAtIndex:index]]];
        }
        
    } else if (filter == self.sortList) {
        
        if (self.mode == POPCornTimeRemoteTypeMovie){
            
            NSLog(@"sorting: %@", [self.ordering objectAtIndex:index]);
            [self.sort setFilterName:[self.ordering objectAtIndex:index]];
        
            [self sendCommand:@"filtersorter" params:@[[self.ordering objectAtIndex:index]]];
            
        } else if(self.mode == POPCornTimeRemoteTypeSeries) {
            
            NSLog(@"sorting: %@", [self.ordering_tv objectAtIndex:index]);
            [self.sort setFilterName:[self.ordering_tv objectAtIndex:index]];
            
            [self sendCommand:@"filtersorter" params:@[[self.ordering_tv objectAtIndex:index]]];
        }
    }
}

- (void)sendCommand:(NSString *)command params:(NSArray *)params
{
    if (self.listener) {
        [self.listener send:command params:params];
    }
}

- (void)selectedFilter:(POPFilterSelectView *)filter
{
    if (filter == self.category) {
        
        [self.categoryList show];
        
    } else if(filter == self.sort) {
        
        [self.sortList show];
        
    }
}

- (void)selectedCommand:(POPControlViewCommand)command
{
    switch (command) {
            
        case POPControlViewEnterCommand:

            [self sendCommand:@"enter" params:nil];
            
        break;
        case POPControlViewUpCommand:
            
            [self sendCommand:@"up" params:nil];
            
        break;
            
        case POPControlViewDownCommand:

            [self sendCommand:@"down" params:nil];

        break;
            
        case POPControlViewLeftCommand:

            [self sendCommand:@"left" params:nil];

        break;
            
        case POPControlViewRightCommand:

            [self sendCommand:@"right" params:nil];

        break;
            
        case POPControlViewBackCommand:
            
            if (!self.fixSeriesNavBugActive) {
                [self sendCommand:@"back" params:nil];
            } else {
                [self sendCommand:@"showslist" params:nil];
                self.fixSeriesNavBugActive = NO;
                
                [self clearSearch];
                [self hideSearch];
            }

        break;
            
        case POPControlViewMuteCommand:

            [self sendCommand:@"togglemute" params:nil];

        break;
            
        case POPControlViewIncreaseVolumeCommand:
            
            self.volume += 0.1;
            if (self.volume > 1.0) {
                self.volume = 1.0;
            }
            
            [self sendCommand:@"setvolume" params:@[@(self.volume)]];

        break;
            
        case POPControlViewDecreaseVolumeCommand:

            self.volume -= 0.1;
            if (self.volume < 0.0) {
                self.volume = 0.0;
            }
            
            [self sendCommand:@"setvolume" params:@[@(self.volume)]];

        break;
    }
}

- (void)selectedType:(POPTypeSwitchView *)type
               index:(int)index
{
    if (index == 0) {
        
        [self sendCommand:@"movieslist" params:nil];
        [self.tvSeriesNext setHidden:YES];
        [self.tvSeriesPrev setHidden:YES];
        
        [self.categoryList updateList:self.genres];
        [self.sortList updateList:self.ordering];
        
        [self.category setFilterName:[self.genres objectAtIndex:0]];
        [self.sort setFilterName:[self.ordering objectAtIndex:0]];
        
        self.mode = POPCornTimeRemoteTypeMovie;
        
    } else {
        
        [self sendCommand:@"showslist" params:nil];
        
        [self.categoryList updateList:self.genres_tv];
        [self.sortList updateList:self.ordering_tv];
        
        [self.category setFilterName:[self.genres_tv objectAtIndex:0]];
        [self.sort setFilterName:[self.ordering_tv objectAtIndex:0]];
        
        self.mode = POPCornTimeRemoteTypeSeries;
    }
    
    [self clearSearch];
}


- (void)initializeController
{
    [self updateViewStackWithDelay:.5];
    
    int __block responsCount = 4;
    BOOL __block hadError = NO;
    
    [self.listener send:@"getgenres" params:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"got all the genres");
        NSArray *results = (NSArray *)responseObject;
        NSArray *list = [results objectAtIndex:0];

        if (list) {
            self.genres = [list copy];
            
            [self.categoryList updateList:self.genres];
        }
        
        responsCount--;
        if (responsCount == 0) {
            // we are all done
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hadError = YES;
        responsCount--;
        if(responsCount == 0){
            //
        }
    }];
    
    // lets get everything
    
    [self.listener send:@"getsorters" params:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"got all the sorters");
        NSArray *results = (NSArray *)responseObject;
        NSArray *list = [results objectAtIndex:0];
        
        if (list) {
            self.ordering = [list copy];
            
            [self.sortList updateList:self.ordering];
        }
        
        responsCount--;
        if (responsCount == 0) {
            // we are all done
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hadError = YES;
        responsCount--;
        if (responsCount == 0) {
            //
        }
    }];
    
    [self.listener send:@"getgenres_tv" params:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"got all the genres tv");
        NSArray *results = (NSArray *)responseObject;
        NSArray *list = [results objectAtIndex:0];
        
        if (list) {
            self.genres_tv = [list copy];
        }
        
        responsCount--;
        if (responsCount == 0) {
            // we are all done
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hadError = YES;
        responsCount--;
        if (responsCount == 0) {
            //
        }
    }];
    
    [self.listener send:@"getsorters_tv" params:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"got all the sorters tv");
        NSArray *results = (NSArray *)responseObject;
        NSArray *list = [results objectAtIndex:0];
        
        if (list) {
            self.ordering_tv = [list copy];
        }
        
        responsCount--;
        if (responsCount == 0) {
            // we are all done
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hadError = YES;
        responsCount--;
        if (responsCount == 0) {
            //
        }
    }];
    
    // Reset to movielist so we know where we are
    [self sendCommand:@"movieslist" params:nil];
}


- (void)updateViewStackWithDelay:(float)delay
{
    if (self.viewStackTimer) {
        [self.viewStackTimer invalidate];
    }
    
    self.viewStackTimer = [NSTimer scheduledTimerWithTimeInterval:delay
                                                           target:self
                                                         selector:@selector(handleViewStackTimer:)
                                                         userInfo:nil
                                                          repeats:YES];
    
}

- (void)handleViewStackTimer:(NSTimer *)timer
{
    [self updateViewStack:NO];
}

- (BOOL)viewStackHasChanged:(NSArray *)stack
{
    if (!self.currentViewStack) {
        return YES;
    }
    
    if (stack.count != self.currentViewStack.count) {
        return YES;
    }
    
    for (NSInteger i = 0; i < stack.count; i++) {
        NSString *view = [self.currentViewStack objectAtIndex:i];
        NSString *c_view = [stack objectAtIndex:i];
        if (![view isEqualToString:c_view]) {
            return YES;
        }
    }
    
    return NO;
}

- (void)enableSeasonNav:(BOOL)enable
{
    if (enable) {
        [self.tvSeriesNext setHidden:NO];
        [self.tvSeriesPrev setHidden:NO];
    } else {
        [self.tvSeriesNext setHidden:YES];
        [self.tvSeriesPrev setHidden:YES];
    }
}

- (void)enableVideoControls:(BOOL)enable
{
    if (enable) {
        [self playToggle].alpha = 1;
        [self.control enableVideoControls:YES];
    } else {
        [self playToggle].alpha = 0;
        [self.control enableVideoControls:NO];
    }
}

- (void)handleViewStack:(NSArray *)stack
{
    
    if ([self viewStackHasChanged:stack]) {
        
        NSLog(@"STACK HAS CHANGED");
        
        self.fixSeriesNavBugActive = NO;
        
        [self enableSeasonNav:NO];
        
        NSString *current_stack;
        
        if (stack.count == 1) {
            
            NSLog(@"We are at main browsing area: %@", [stack objectAtIndex:0]);
            
            [self enableVideoControls:NO];
            
            
        } else if(stack.count == 2) {
            NSLog(@"We are 1 step in %@", [stack objectAtIndex:1]);
            
            current_stack = [stack objectAtIndex:1];
            
            [self enableVideoControls:NO];
            
            // Bug fix in PopcornTime
            if ([current_stack isEqualToString:@"shows-container-contain"]) {
                
                if (self.fixSeriesNavBug) {
                    self.fixSeriesNavBugActive = YES;
                    NSLog(@"TRIGGERING BUG FIX");
                }
                // Show series nav
                [self enableSeasonNav:YES];
            }
            
        } else if(stack.count == 3) {
            NSLog(@"We are 2 steps in %@", [stack objectAtIndex:2]);
            current_stack = [stack objectAtIndex:2];
            
            if ([current_stack isEqualToString:@"player"]) {
                [self enableVideoControls:YES];
            } else {
                [self enableVideoControls:NO];
            }
        }
        
        self.currentViewStack = [stack mutableCopy];
    }

}

- (void)updateViewStack:(BOOL)showHud
{
    
    MBProgressHUD *hud;
    
    if (showHud) {
        
        hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.backgroundColor = [UIColor colorWithWhite:0.0 alpha:.5];
        hud.labelText = NSLocalizedString(@"Initializing controller...", nil);
    
        [hud show:YES];
    }
    
    [self.listener send:@"getviewstack" params:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"we have view stack");
        
        NSArray *stack = (NSArray *)responseObject;
        
        NSArray *stack_list = [stack objectAtIndex:0];
        
        [self handleViewStack:stack_list];
        
        if (showHud) {
            [hud hide:YES];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"we could not get view stack");
        if (showHud) {
            [hud hide:YES];
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.searchBar) {
        [self.searchBar removeFromSuperview];
        
        [self.viewStackTimer invalidate];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self initializeController];
}

- (void)updatePlayerView
{
    [self sendCommand:@"getviewstack" params:nil];
}

- (void)handlePlay
{
    [self sendCommand:@"toggleplaying" params:nil];
}

- (void)handleSearch
{
    if (self.hasSearched) {
        
        [self clearSearch];
        
        [self sendCommand:@"clearsearch" params:nil];
        
    } else {
        
        [self showSearch];
        [self showCover];
        
    }
}

- (void)clearSearch
{
    if (self.hasSearched) {
        self.hasSearched = NO;
        self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"search"];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar setHidden:YES];
    [self.searchBar resignFirstResponder];
    [self hideCover];
}

- (void)hideSearch
{
    [self.searchBar setHidden:YES];
    [self.searchBar resignFirstResponder];
}

- (void)showSearch
{
    if (!self.searchBar) {
        self.searchBar = [[UISearchBar alloc] initWithFrame:self.navigationController.navigationBar.bounds];
        self.searchBar.showsCancelButton = YES;
        self.searchBar.placeholder = NSLocalizedString(@"Search", nil);
        self.searchBar.backgroundColor = UIColorFromRGB(kBackgroundColor);
        [self.navigationController.navigationBar addSubview:self.searchBar];
        self.searchBar.delegate = self;
        [self.searchBar setHidden:NO];
    } else {
        [self.searchBar setHidden:NO];
    }
    
    [self.searchBar becomeFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if ([searchBar.text length] > 0) {
        
        // TODO: do not hide instead, check for clear search
        [self sendCommand:@"filtersearch" params:@[searchBar.text]];
        
        [self.searchBar setHidden:YES];
        [self.searchBar setText:@""];
        [self.searchBar resignFirstResponder];
        [self hideCover];
        
        self.hasSearched = YES;
        
        [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"close-search"]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //
    
    [self.navigationController.navigationBar setTintColor:UIColorFromRGB(kDefaultColor)];
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(kBackgroundColor);
    self.navigationController.navigationBar.translucent = NO;
    
    //
    
    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStylePlain target:self action:@selector(handleSearch)];
    self.navigationItem.rightBarButtonItem = searchBtn;
    
    //
    
    self.listener = [[POPNetworking alloc] init];
    
    [self.listener connect:self.host port:self.port user:kPopcornUser password:kPopcornPass];
    
    [self.navigationItem setHidesBackButton:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
