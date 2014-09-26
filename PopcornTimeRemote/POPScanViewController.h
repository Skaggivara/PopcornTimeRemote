//
//  POPScanViewController.h
//  PopcornTimeRemote
//
//  Created by Isak Wiström on 9/24/14.
//  Copyright (c) 2014 skaggivara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ScanLAN.h"

@interface POPScanViewController : UIViewController <ScanLANDelegate, UIAlertViewDelegate>

@property(strong, nonatomic) UIButton *scanBtn;
@property(strong, nonatomic) UIButton *connectBtn;
@property(strong, nonatomic) MBProgressHUD *hud;
@property(strong, nonatomic) ScanLAN *scanner;
@property(strong, nonatomic) NSMutableArray *connectedDevices;

@property(strong, nonatomic) UILabel *desc;
@property(strong, nonatomic) UILabel *divider;
@property(strong, nonatomic) UILabel *footnote;
@property(strong, nonatomic) UILabel *notice;

@end
