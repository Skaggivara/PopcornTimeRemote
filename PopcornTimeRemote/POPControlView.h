//
//  POPControlView.h
//  PopcornTimeRemote
//
//  Created by Isak Wiström on 9/23/14.
//  Copyright (c) 2014 skaggivara. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    POPControlViewEnterCommand,
    POPControlViewUpCommand,
    POPControlViewLeftCommand,
    POPControlViewRightCommand,
    POPControlViewDownCommand,
    POPControlViewBackCommand,
    POPControlViewIncreaseVolumeCommand,
    POPControlViewDecreaseVolumeCommand,
    POPControlViewMuteCommand
} POPControlViewCommand;

@class POPControlView;

@protocol POPControlViewDelegate <NSObject>
@optional
- (void)selectedCommand:(POPControlViewCommand)command;
@end

@interface POPControlView : UIView

@property(strong, nonatomic) UIButton *up;
@property(strong, nonatomic) UIButton *down;
@property(strong, nonatomic) UIButton *left;
@property(strong, nonatomic) UIButton *right;
@property(strong, nonatomic) UIButton *enter;
@property(strong, nonatomic) UIButton *back;
@property(strong, nonatomic) UIButton *increaseVolume;
@property(strong, nonatomic) UIButton *decreaseVolume;
@property(strong, nonatomic) UIButton *toggleMute;

@property (nonatomic, weak) id <POPControlViewDelegate> delegate;

- (void)enableVideoControls:(BOOL)enable;

@end
