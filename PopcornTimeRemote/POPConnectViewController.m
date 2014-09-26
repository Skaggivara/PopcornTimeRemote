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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.host = kPopcornHost;
        self.port = kPopcornPort;
        self.user = kPopcornUser;
        self.pass = kPopcornPass;
        self.volume = 0.8;
    }
    return self;
}

- (id)initWithHost:(NSString *)host port:(int)port user:(NSString *)user password:(NSString *)password
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        self.host = host;
        self.port = port;
        self.user = user;
        self.pass = password;
        self.volume = 0.8;
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
    self.typeSwitch = [[POPTypeSwitchView alloc] initWithFrameAndTitles:CGRectMake(0, 0, self.view.frame.size.width, 44) titles:@[@"Movies", @"TV Series"]];
    self.typeSwitch.delegate = self;
    [self.view addSubview:self.typeSwitch];
    
    //
    
    self.playToggle = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playToggle setTitle:@"Toggle Playstate" forState:UIControlStateNormal];
    [self.playToggle setTitleColor:UIColorFromRGB(kBackgroundColor) forState:UIControlStateNormal];
    [self.playToggle setBackgroundColor:UIColorFromRGB(kDefaultColor)];
    
    [self.playToggle addTarget:self action:@selector(handlePlay) forControlEvents:UIControlEventTouchUpInside];
    
    self.playToggle.frame = CGRectMake(0, (self.view.frame.size.height - 64) - 62, self.view.frame.size.width, 62);
    self.playToggle.alpha = 0.0;
    
    [self.view addSubview:self.playToggle];
    
    //
    
    self.tvSeriesPrev = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tvSeriesPrev setTitle:@"Prev season" forState:UIControlStateNormal];
    self.tvSeriesPrev.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.tvSeriesPrev setTitleColor:UIColorFromRGB(kDefaultColor) forState:UIControlStateNormal];
    self.tvSeriesPrev.frame = CGRectMake(20, 100, 140, 30);
    [self.tvSeriesPrev addTarget:self action:@selector(handleSeriesNav:) forControlEvents:UIControlEventTouchUpInside];
    [self.tvSeriesPrev setHidden:YES];
    
    [self.view addSubview:self.tvSeriesPrev];
    
    //
    self.tvSeriesNext = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tvSeriesNext setTitle:@"Next season" forState:UIControlStateNormal];
    self.tvSeriesNext.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.tvSeriesNext setTitleColor:UIColorFromRGB(kDefaultColor) forState:UIControlStateNormal];
    self.tvSeriesNext.frame = CGRectMake(160, 100, 140, 30);
    [self.tvSeriesNext addTarget:self action:@selector(handleSeriesNav:) forControlEvents:UIControlEventTouchUpInside];
    [self.tvSeriesNext setHidden:YES];
    
    [self.view addSubview:self.tvSeriesNext];
    
    //
    
    self.category = [[POPFilterSelectView alloc] initWithFrameAndTitle:CGRectMake(20, 60, 140, 30) title:@"Genre" filter:@"All"];
    self.category.delegate = self;
    
    [self.view addSubview:self.category];
    
    //
    
    self.sort = [[POPFilterSelectView alloc] initWithFrameAndTitle:CGRectMake(160, 60, 140, 30) title:@"Sort by" filter:@"Popularity"];
    self.sort.delegate = self;
    
    [self.view addSubview:self.sort];
    
    //
    self.genres = @[@"All", @"Action", @"Adventure", @"Animation"];
    
    
    self.categoryList = [[POPFilterListView alloc] initWithFrameAndFilters:CGRectMake(0, 0, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height) filters:self.genres];
    self.categoryList.delegate = self;
    
    [self.navigationController.view addSubview:self.categoryList];
    
    //
    
    self.ordering = @[@"Popularity", @"Date Added", @"Year", @"Rating"];
    
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
    
    [self setTitle:@"Popcorn Time Remote"];
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

- (void)selectedFilter:(POPFilterListView *)filter index:(int)index
{
    // TODO: check which type is selected, tv or another
    
    if (filter == self.categoryList) {
        NSLog(@"genre: %@", [self.genres objectAtIndex:index]);
        [self.category setFilterName:[self.genres objectAtIndex:index]];
        
        [self sendCommand:@"filtergenre" params:@[[self.genres objectAtIndex:index]]];
        
    } else if(filter == self.sortList){
        //NSLog(@"sorting on: %i", index);
        NSLog(@"sorting: %@", [self.ordering objectAtIndex:index]);
        [self.sort setFilterName:[self.ordering objectAtIndex:index]];
        
        [self sendCommand:@"filtersorter" params:@[[self.ordering objectAtIndex:index]]];
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
    if(filter == self.category){
        NSLog(@"open category");
        [self.categoryList show];
    } else if(filter == self.sort){
        NSLog(@"open sort");
        [self.sortList show];
    }
}

- (void)selectedCommand:(POPControlViewCommand)command
{
    switch(command){
        case POPControlViewEnterCommand:

            [self sendCommand:@"enter" params:nil];
            // update view stack
            
            //[self updateViewStack:NO];
            //[self updateViewStackWithDelay:1.0];
            
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

            [self sendCommand:@"back" params:nil];

        break;
            
        case POPControlViewMuteCommand:

            [self sendCommand:@"togglemute" params:nil];

        break;
            
        case POPControlViewIncreaseVolumeCommand:
            
            self.volume += 0.1;
            if(self.volume > 1.0){
                self.volume = 1.0;
            }
            
            [self sendCommand:@"setvolume" params:@[@(self.volume)]];

        break;
            
        case POPControlViewDecreaseVolumeCommand:

            self.volume -= 0.1;
            if(self.volume < 0.0){
                self.volume = 0.0;
            }
            
            [self sendCommand:@"setvolume" params:@[@(self.volume)]];

        break;
    }
}

- (void)selectedType:(POPTypeSwitchView *)type index:(int)index
{
    if (index == 0) {
        
        [self sendCommand:@"movieslist" params:nil];
        [self.tvSeriesNext setHidden:YES];
        [self.tvSeriesPrev setHidden:YES];
        
    } else {
        
        [self sendCommand:@"showslist" params:nil];
        [self.tvSeriesNext setHidden:NO];
        [self.tvSeriesPrev setHidden:NO];
    }
    
    [self clearSearch];
}


- (void)initializeController
{
    [self updateViewStack:NO];
    
    int __block responsCount = 2;
    BOOL __block hadError = NO;
    
    [self.listener send:@"getgenres" params:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"got all the sorters");
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
    
}

- (void)updateViewStackWithDelay:(float)delay
{
    if (self.viewStackTimer) {
        [self.viewStackTimer invalidate];
    } else {
        self.viewStackTimer = [NSTimer scheduledTimerWithTimeInterval:delay
                                                          target:self
                                                        selector:@selector(handleViewStackTimer:)
                                                        userInfo:nil
                                                         repeats:NO];
    }
}

- (void)handleViewStackTimer:(NSTimer *)timer
{
    [self updateViewStack:NO];
}

- (void)handleViewStack:(NSArray *)stack
{
    
    // main-browser
    //  movie-detail
    
    
    NSString *stack_trace = @"VIEW";
    for(NSString *view in stack){
        stack_trace = [stack_trace stringByAppendingString:[NSString stringWithFormat:@"- %@", view]];
    }
    
    NSLog(@"%@", stack_trace);
    
    if (stack.count == 1) {
        NSLog(@"We are at main browsing area");
        
        [self playToggle].alpha = 0;
        [self.control enableVideoControls:NO];
        
    } else if(stack.count == 2) {
        NSLog(@"We are one step in");
        [self playToggle].alpha = 0;
        [self.control enableVideoControls:NO];
        
    } else if(stack.count == 3) {
        NSLog(@"We are playing something");
        [self playToggle].alpha = 1;
        [self.control enableVideoControls:YES];
    }

}

- (void)updateViewStack:(BOOL)showHud
{
    
    MBProgressHUD *hud;
    
    if (showHud) {
        
        hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.backgroundColor = [UIColor colorWithWhite:0.0 alpha:.5];
        hud.labelText = @"Initializing controller...";
    
        [hud show:YES];
    }
    
    [self.listener send:@"getviewstack" params:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"we have view stack");
        
        NSArray *stack = (NSArray *)responseObject;
        
        NSArray *stack_list = [stack objectAtIndex:0];
        
        /*
        for (NSString *view in stack_list) {
            NSLog(@"STACK: %@", view);
        }*/
        
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
    if(!self.searchBar){
        self.searchBar = [[UISearchBar alloc] initWithFrame:self.navigationController.navigationBar.bounds];
        self.searchBar.showsCancelButton = YES;
        self.searchBar.placeholder = @"Search";
        self.searchBar.backgroundColor = UIColorFromRGB(kBackgroundColor);
        [self.navigationController.navigationBar addSubview:self.searchBar];
        self.searchBar.delegate = self;
        [self.searchBar setHidden:NO];
    }else{
        [self.searchBar setHidden:NO];
    }
    
    //self.searchBar.layer.borderColor = [UIColor redColor].CGColor;
    //self.searchBar.layer.borderWidth = 1;
    
    [self.searchBar becomeFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"We are searching");
    
    if([searchBar.text length] > 0){
        
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
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setTintColor:UIColorFromRGB(kDefaultColor)];
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(kBackgroundColor);
    self.navigationController.navigationBar.translucent = NO;
    
    //
    
    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStylePlain target:self action:@selector(handleSearch)];
    self.navigationItem.rightBarButtonItem = searchBtn;
    //
    
    self.listener = [[POPNetworking alloc] init];
    
    //[self.listener findPopcornTime];
    
    [self.listener connect:self.host port:self.port user:kPopcornUser password:kPopcornPass];
    
    [self.navigationItem setHidesBackButton:YES];
    
    [self listenForChanges];
    
}

- (void)listenForChanges
{
    /*
    [self.listener listen:self.host port:self.port user:kPopcornUser password:kPopcornPass success:^(id responseObject) {
        NSLog(@"MESSAGE FROM NOT ENDING..");
        [self listenForChanges];
    } failure:^(NSError *error) {
        NSLog(@"ERROR FROM NOT ENDING: %@", error.description);
        // wait a while then restant
    }];*/
   
    /*
    NSURL *URL = [NSURL URLWithString:@"http://example.com"];
    AFRocketClient *client = [[AFRocketClient alloc] initWithBaseURL:URL];
    
    [client SUBSCRIBE:@"/listennotifications" usingBlock:^(NSArray *operations, NSError *error) {
        
        NSLog(@"hello...");
        for (AFJSONPatchOperation *operation in operations) {
            switch (operation.type) {
                case AFJSONAddOperationType:
                    //[resources addObject:operation.value];
                    break;
                default:
                    break;
            }
        }
    } error:nil];*/
    
    //NSMutableData * responseData;
    //NSURLConnection * connection;
    
    
    NSMutableDictionary *payload = [NSMutableDictionary dictionary];
    payload[@"jsonrpc"] = @"2.0";
    payload[@"method"] = @"listennotifications";
    payload[@"params"] = @[];
    payload[@"id"] = @"1";
    
    //return [self.requestSerializer requestWithMethod:@"POST" URLString:[self.endpointURL absoluteString] parameters:payload error:nil];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@:%i", self.host, self.port]];
    
    self.listenChunks = [[NSMutableData alloc] initWithLength:0] ;
    
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", kPopcornUser, kPopcornPass];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:80]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:300.0];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    //[NSJSONSerialization
    
    NSError *error;
    
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:payload options:0 error:&error];
  
    //NSData *requestData = [[payload JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%i", (int)[requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    
    self.listenConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // You may have received an HTTP 200 here, or not...
    [self.listenChunks setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSString* aStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    
    NSLog(@"This is my first chunk %@", aStr);
    
   
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Done with chunked response..");
    //[self listenForChanges];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Something went wrong...%@", error.description);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
