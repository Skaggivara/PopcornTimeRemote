//
//  POPScanViewController.m
//  PopcornTimeRemote
//
//  Created by Isak Wiström on 9/24/14.
//  Copyright (c) 2014 skaggivara. All rights reserved.
//

#import "POPScanViewController.h"
#import "POPNetworking.h"
#import "Device.h"
#import "POPConnectViewController.h"
#import "POPDevice.h"

@interface POPScanViewController ()

@end

@implementation POPScanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.scanner = [[ScanLAN alloc] initWithDelegate:self];
    }
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view setBackgroundColor:UIColorFromRGB(kBackgroundColor)];
    
    //
    
    self.desc = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, 260, 50)];
    
    [self.desc setTextColor:UIColorFromRGB(kDefaultColor)];
    self.desc.textAlignment = NSTextAlignmentCenter;
    self.desc.lineBreakMode = NSLineBreakByWordWrapping;
    self.desc.numberOfLines = 0;
    [self.desc setText:NSLocalizedString(@"Connect this device to the same network as your computer running Popcorn Time.", nil)];
    
    [self.desc sizeToFit];
    
    [self.view addSubview:self.desc];
    
    //
    
    self.scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.scanBtn setTitleColor:UIColorFromRGB(kDefaultColor) forState:UIControlStateNormal];
    [self.scanBtn setBackgroundColor:UIColorFromRGB(kActiveColor)];
    [self.scanBtn setImage:[UIImage imageNamed:@"search-light"] forState:UIControlStateNormal];
    [self.scanBtn setTitle:NSLocalizedString(@"Find Popcorn Time", nil) forState:UIControlStateNormal];
    
    [self.scanBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -45, 0, 0)];
    [self.scanBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, self.scanBtn.imageView.image.size.width)];
    
    self.scanBtn.layer.cornerRadius = 5;
    
    [self.scanBtn addTarget:self action:@selector(handleScan) forControlEvents:UIControlEventTouchUpInside];
    
    self.scanBtn.frame = CGRectMake(30, self.desc.frame.origin.y + self.desc.frame.size.height + 40, 260, 60);
    
    [self.view addSubview:self.scanBtn];
    
    //
    
    self.divider = [[UILabel alloc] initWithFrame:CGRectMake(30, self.scanBtn.frame.origin.y + self.scanBtn.frame.size.height + 10, 260, 50)];
    
    [self.divider setTextColor:UIColorFromRGB(kDefaultColor)];
    self.divider.textAlignment = NSTextAlignmentCenter;
    [self.divider setFont:[UIFont systemFontOfSize:12]];
  
    [self.divider setText:NSLocalizedString(@"OR", nil)];
    
    [self.view addSubview:self.divider];
    
    //
    
    self.connectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.connectBtn setTitleColor:UIColorFromRGB(kBackgroundColor) forState:UIControlStateNormal];
    [self.connectBtn setBackgroundColor:UIColorFromRGB(kDefaultColor)];
    [self.connectBtn setTitle:NSLocalizedString(@"Connect to IP address*", nil) forState:UIControlStateNormal];
    
    self.connectBtn.layer.cornerRadius = 5;
    
    [self.connectBtn addTarget:self action:@selector(handleInput) forControlEvents:UIControlEventTouchUpInside];
    
    self.connectBtn.frame = CGRectMake(30, self.divider.frame.origin.y + self.divider.frame.size.height + 10, 260, 44);
    
    [self.view addSubview:self.connectBtn];
    
    //
    self.footnote = [[UILabel alloc] initWithFrame:CGRectMake(30, self.connectBtn.frame.origin.y + self.connectBtn.frame.size.height + 10, 260, 18)];
    
    [self.footnote setTextColor:UIColorFromRGB(kDefaultColor)];
    self.footnote.textAlignment = NSTextAlignmentCenter;
    [self.footnote setFont:[UIFont systemFontOfSize:14]];
    
    [self.footnote setText:NSLocalizedString(@"*Your computers IP address", nil)];
    
    [self.view addSubview:self.footnote];
    
    //
    
    self.notice = [[UILabel alloc] initWithFrame:CGRectMake(30, self.connectBtn.frame.origin.y + self.connectBtn.frame.size.height + 80, 260, 50)];
    
    [self.notice setTextColor:UIColorFromRGB(kSecondaryColor)];
    self.notice.textAlignment = NSTextAlignmentLeft;
    self.notice.lineBreakMode = NSLineBreakByWordWrapping;
    self.notice.numberOfLines = 0;
    [self.notice setFont:[UIFont systemFontOfSize:14]];
    
    [self.notice setText:NSLocalizedString(@"This remote control works with Popcorn Time version 3.3 and above found at http://popcorntime.io", nil)];
    
    [self.notice sizeToFit];
    
    [self.view addSubview:self.notice];
    
    //
    
    
    [self setTitle:NSLocalizedString(@"Popcorn Time Remote", nil)];
    
}

- (void)handleInput
{
    if (![[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi]) {
        //update text
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Problem Connecting", nil) message:[NSString stringWithFormat:NSLocalizedString(@"Please connect to the same network (WIFI) as your computer running popcorn time.", nil)] delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil] show];
    } else {
        
        POPDevice *existing = [POPDevice savedAddress];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connect", nil) message:NSLocalizedString(@"Enter the IP address of the computer running Popcorn Time:", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Connect", nil), nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        
        if (existing) {
            UITextField *field = [alertView textFieldAtIndex:0];
            [field setTextAlignment:NSTextAlignmentCenter];
            field.text = existing.address;
        }
        
        alertView.delegate = self;
        
        alertView.tag = 1;

        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    // TODO: check index instead of string
    if ([title isEqualToString:@"Connect"]) {
        
        NSLog(@"Connect %@", [alertView textFieldAtIndex:0].text);
        
        NSString *address = [alertView textFieldAtIndex:0].text;
        NSArray *a = [address componentsSeparatedByString:@"."];
        

        if (![self.scanner isIpAddressValid:address] || a.count < 4) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Invalid address", nil) message:[NSString stringWithFormat:NSLocalizedString(@"Please use a valid IP address.",nil)] delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil] show];
        } else {
            
            // TODO: make ping first
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.backgroundColor = [UIColor colorWithWhite:0.0 alpha:.5];
            // TODO: check how to translate correctly
            hud.labelText = [NSString stringWithFormat:@"Connecting to %@", address];
            
            [hud show:YES];
            
            // TODO: check if we have other user/pass saved
            [POPNetworking validatePopcorn:address
                                      port:kPopcornPort
                                      user:kPopcornUser
                                  password:kPopcornPass
                                   success:^(id responseObject)
             {
                 [self.scanner stopScan];
                 
                 [hud hide:YES];
                 
                 POPDevice *working = [POPDevice deviceWithAddress:address];
                 [working save];
                 
                 POPConnectViewController *controls = [[POPConnectViewController alloc] initWithHost:address port:kPopcornPort user:kPopcornUser password:kPopcornPass];
                 
                 [self.navigationController pushViewController:controls animated:YES];
                 
             } failure:^(NSError *error){
                 
                 [hud hide:YES];
                 
                 [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Popcorn Time not found", nil) message:[NSString stringWithFormat:NSLocalizedString(@"Please make sure Popcorn Time is runnning.", nil)] delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil] show];
                }
             ];
        }
    }
}

- (void)handleScan
{
    if (![[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi]) {
        //update text
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Problem Connecting", nil) message:[NSString stringWithFormat:NSLocalizedString(@"Please connect to the same network (WIFI) as your computer running popcorn time.", nil)] delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil] show];
    } else {
        
        if (!self.hud) {
            self.hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
            self.hud.mode = MBProgressHUDModeDeterminate;
            self.hud.backgroundColor = [UIColor colorWithWhite:0.0 alpha:.8];
            self.hud.labelText = NSLocalizedString(@"Searching... (Tap to cancel)", nil);
            UITapGestureRecognizer *HUDSingleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
            [self.hud addGestureRecognizer:HUDSingleTap];

        }

        [self.hud show:YES];
            
        self.connectedDevices = [[NSMutableArray alloc] init];

        [self.scanner stopScan];
        [self.scanner startScanFromIP:[POPNetworking getIPAddress]];
    }
    
}

- (void)singleTap:(id)sender
{
    if (self.hud) {
        [self.hud hide:YES];
    }
    
    if (self.scanner) {
        [self.scanner stopScan];
    }
}

#pragma mark LAN Scanner delegate method
- (void)scanLANDidFindNewAddress:(NSString *)address
                  havingHostName:(NSString *)hostName
{
    Device *device = [[Device alloc] init];
    if (hostName) {
        device.name = hostName;
    } else {
        device.name = @"unknown";
    }
    
    device.address = address;
    
    NSLog(@"Trying to validate: %@", device.address);
    
    [POPNetworking validatePopcorn:device.address
                              port:kPopcornPort
                              user:kPopcornUser
                          password:kPopcornPass
                           success:^(id responseObject)
     {
         [self.scanner stopScan];
         
         if (self.hud) {
             [self.hud hide:YES];
         }
         
         POPDevice *working = [POPDevice deviceWithAddress:device.address];
         [working save];
         
         POPConnectViewController *controls = [[POPConnectViewController alloc] initWithHost:device.address port:kPopcornPort user:kPopcornUser password:kPopcornPass];
         
         [self.navigationController pushViewController:controls animated:YES];
         
     } failure:^(NSError *error){
         NSLog(@"error: %@", error.description);
     }
    ];
    
    [self.connectedDevices addObject:device];
}

- (void)scanLANDidFinishScanning {
    NSLog(@"Scan finished");
    
    for (Device *device in self.connectedDevices) {
        if (device) {
            NSLog(@"device");
        }
        NSLog(@"device at: %@, called: %@", device.address, device.name);
    }
    
    // TODO: timeout then alert and hide hud
    // TODO: check copy in format
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Scan Finished", nil) message:[NSString stringWithFormat:@"Number of devices connected to the Local Area Network : %i", (int)self.connectedDevices.count] delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil] show];
    
    if (self.hud) {
        [self.hud hide:YES];
    }
}

- (void)scanLANProgress:(float)progress
{
    if (self.hud) {
        self.hud.progress = progress;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self checkExisting];
}

- (void)checkExisting
{
    
    POPDevice *existing = [POPDevice savedAddress];
    
    if (existing && [[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi]) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.backgroundColor = [UIColor colorWithWhite:0.0 alpha:.5];
        hud.labelText = NSLocalizedString(@"Connecting to existing...", nil);
    
        [hud show:YES];
        
        [POPNetworking validatePopcorn:[existing validAddress] port:kPopcornPort user:kPopcornUser password:kPopcornPass success:^(id responseObject) {
            
            [hud hide:YES];
            
            POPConnectViewController *controls = [[POPConnectViewController alloc] initWithHost:[existing validAddress] port:kPopcornPort user:kPopcornUser password:kPopcornPass];
            
            
            [UIView beginAnimations: @"Remote" context: nil];
            [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.75];
            [self.navigationController pushViewController:controls animated:NO];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
            [UIView commitAnimations];
            
            //[self.navigationController pushViewController:controls animated:NO];
            
        } failure:^(NSError *error) {
            
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Problem Connecting", nil) message:[NSString stringWithFormat:NSLocalizedString(@"There was a problem connecting to your saved computer, please try the scan again.", nil)] delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil] show];
            
            [hud hide:YES];
            
        }];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setTintColor:UIColorFromRGB(kDefaultColor)];
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(kBackgroundColor);
    self.navigationController.navigationBar.translucent = NO;
    
    // check if we have saved address
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
}

- (void)dealloc
{
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
