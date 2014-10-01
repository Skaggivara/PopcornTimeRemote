//
//  POPControlView.m
//  PopcornTimeRemote
//
//  Created by Isak Wiström on 9/23/14.
//  Copyright (c) 2014 skaggivara. All rights reserved.
//

#import "POPControlView.h"

@implementation POPControlView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

-(void)setup
{
    self.up = [UIButton buttonWithType:UIButtonTypeCustom];
    self.up.frame = CGRectMake(self.frame.size.width * .25, 0, self.frame.size.width * .5, self.frame.size.height * .25);
    [self.up setImage:[UIImage imageNamed:@"up"] forState:UIControlStateNormal];
    [self.up setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.up.tag = POPControlViewUpCommand;
    [self.up addTarget:self action:@selector(handleCommand:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.up];
    
    //
    
    self.down = [UIButton buttonWithType:UIButtonTypeCustom];
    self.down.frame = CGRectMake(self.frame.size.width * .25, self.frame.size.height * .75, self.frame.size.width * .5, self.frame.size.height * .25);
    [self.down setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    [self.down setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.down.tag = POPControlViewDownCommand;
    
    [self.down addTarget:self action:@selector(handleCommand:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.down];
    
    //
    
    self.left = [UIButton buttonWithType:UIButtonTypeCustom];
    self.left.frame = CGRectMake(0, self.frame.size.height * .25, self.frame.size.width * .25, self.frame.size.height *.5);
    [self.left setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    self.left.tag = POPControlViewLeftCommand;
    [self.left addTarget:self action:@selector(handleCommand:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.left];
    
    //
    
    self.right = [UIButton buttonWithType:UIButtonTypeCustom];
    self.right.frame = CGRectMake(self.frame.size.width * .75, self.frame.size.height * .25, self.frame.size.width * .25, self.frame.size.height * .5);
    self.right.tag = POPControlViewRightCommand;
    [self.right setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
    
    [self.right addTarget:self action:@selector(handleCommand:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.right];
    
    //
    
    self.enter = [UIButton buttonWithType:UIButtonTypeCustom];
    self.enter.frame = CGRectMake(self.frame.size.width * .25, self.frame.size.height * .25, self.frame.size.width * .5, self.frame.size.height * .5);
    [self.enter setTitle:NSLocalizedString(@"Enter", nil) forState:UIControlStateNormal];
    [self.enter setTitleColor:UIColorFromRGB(kBackgroundColor) forState:UIControlStateNormal];
    [self.enter setBackgroundColor:UIColorFromRGB(kDefaultColor)];
    self.enter.layer.cornerRadius = 5;
    self.enter.tag = POPControlViewEnterCommand;
    
    [self.enter addTarget:self action:@selector(handleCommand:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.enter];
    
    //
    
    self.back = [UIButton buttonWithType:UIButtonTypeCustom];
    self.back.frame = CGRectMake(0, 0, self.frame.size.width * .25, self.frame.size.height * .25);
    self.back.layer.borderColor = [UIColor whiteColor].CGColor;
    //self.back.layer.borderWidth = 1;
    //self.back.layer.cornerRadius = 5;
    [self.back setTitle:NSLocalizedString(@"Back", nil) forState:UIControlStateNormal];
    [self.back setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.back.tag = POPControlViewBackCommand;
    [self.back addTarget:self action:@selector(handleCommand:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.back];
    
    //
    
    self.toggleMute = [UIButton buttonWithType:UIButtonTypeCustom];
    self.toggleMute.frame = CGRectMake(self.frame.size.width * .75, 0, self.frame.size.width * .25, self.frame.size.height * .25);
    self.toggleMute.layer.borderColor = [UIColor whiteColor].CGColor;
    //self.toggleMute.layer.borderWidth = 1;
    [self.toggleMute setTitle:NSLocalizedString(@"Mute", nil) forState:UIControlStateNormal];
    [self.toggleMute setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.toggleMute.tag = POPControlViewMuteCommand;
    [self.toggleMute addTarget:self action:@selector(handleCommand:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.toggleMute];
    
    //
    
    self.decreaseVolume = [UIButton buttonWithType:UIButtonTypeCustom];
    self.decreaseVolume.frame = CGRectMake(0, self.frame.size.height * .75, self.frame.size.width * .25, self.frame.size.height * .25);
    self.decreaseVolume.layer.borderColor = [UIColor whiteColor].CGColor;
    //self.decreaseVolume.layer.borderWidth = 1;
    [self.decreaseVolume.titleLabel setFont:[UIFont systemFontOfSize:24]];
    [self.decreaseVolume setTitle:@"-" forState:UIControlStateNormal];
    [self.decreaseVolume setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.decreaseVolume.tag = POPControlViewDecreaseVolumeCommand;
    [self.decreaseVolume addTarget:self action:@selector(handleCommand:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.decreaseVolume];
    
    //
    
    self.increaseVolume = [UIButton buttonWithType:UIButtonTypeCustom];
    self.increaseVolume.frame = CGRectMake(self.frame.size.width * .75, self.frame.size.height * .75, self.frame.size.width * .25, self.frame.size.height * .25);
    self.increaseVolume.layer.borderColor = [UIColor whiteColor].CGColor;
    //self.increaseVolume.layer.borderWidth = 1;
    [self.increaseVolume.titleLabel setFont:[UIFont systemFontOfSize:24]];
    [self.increaseVolume setTitle:@"+" forState:UIControlStateNormal];
    self.increaseVolume.tag = POPControlViewIncreaseVolumeCommand;
    [self.increaseVolume setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.increaseVolume addTarget:self action:@selector(handleCommand:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.increaseVolume];
    
}

- (void)enableVideoControls:(BOOL)enable
{
    [self decreaseVolume].enabled = enable;
    [self increaseVolume].enabled = enable;
    [self toggleMute].enabled = enable;
    
    if (enable) {
        [self decreaseVolume].alpha = 1.0;
        [self increaseVolume].alpha = 1.0;
        [self toggleMute].alpha = 1.0;
    } else {
        [self decreaseVolume].alpha = 0.5;
        [self increaseVolume].alpha = 0.5;
        [self toggleMute].alpha = 0.5;
    }
}

- (void)handleCommand:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(selectedCommand:)]) {
            [self.delegate selectedCommand:(POPControlViewCommand)btn.tag];
        }
    }
}

@end
