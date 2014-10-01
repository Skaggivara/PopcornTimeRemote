//
//  POPFilterListView.m
//  PopcornTimeRemote
//
//  Created by Isak Wiström on 9/23/14.
//  Copyright (c) 2014 skaggivara. All rights reserved.
//

#import "POPFilterListView.h"

@implementation POPFilterListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (id)initWithFrameAndFilters:(CGRect)frame filters:(NSArray *)filters
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.filters = [filters mutableCopy];
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    
    if (self.filters) {
        [self build];
    }
    
    self.userInteractionEnabled = NO;
    self.alpha = 0.0;
    
}

- (void)updateList:(NSArray *)list
{
    self.filters = [list mutableCopy];
    
    [self build];
}

- (void)build
{
    if (!self.backg) {
        self.backg = [UIButton buttonWithType:UIButtonTypeCustom];
        self.backg.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        self.backg.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        [self.backg addTarget:self action:@selector(handleClose) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.backg];
    }
    
    float margin = 30;
    
    if (!self.btnContainer) {
        self.btnContainer = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - (margin * 2), self.frame.size.height - (margin * 2))];
    
        self.btnContainer.scrollEnabled = YES;
        self.btnContainer.backgroundColor = [UIColor colorWithWhite:0.0 alpha:1.0];
    
        [self addSubview:self.btnContainer];
    }
    
    float size = 0;
    
    if (self.btns) {
       // loop through and
        for (UIButton *btn in self.btns) {
            [btn removeTarget:self action:@selector(handleDown:) forControlEvents:UIControlEventTouchDown];
            [btn removeTarget:self action:@selector(handleSelect:) forControlEvents:UIControlEventTouchUpInside];
            [btn removeTarget:self action:@selector(handleUp:) forControlEvents:UIControlEventTouchUpOutside];
            [btn removeFromSuperview];
        }
    }
    
    self.btns = [[NSMutableArray alloc] init];
    
    float spacing = 1.0;
    float btn_h = 45;
    
    for (NSInteger i = 0; i < self.filters.count; i++) {
        
        NSString *text = [self.filters objectAtIndex:i];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, i * (btn_h + spacing), self.btnContainer.frame.size.width, btn_h);
        btn.backgroundColor = UIColorFromRGB(kBackgroundColor);
        [btn setTitle:[[[text substringToIndex:1] uppercaseString] stringByAppendingString:[text substringFromIndex:1]] forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(handleDown:) forControlEvents:UIControlEventTouchDown];
        [btn addTarget:self action:@selector(handleSelect:) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(handleUp:) forControlEvents:UIControlEventTouchUpOutside];
        [self.btnContainer addSubview:btn];
        
        [self.btns addObject:btn];
        
        size += btn.frame.size.height + spacing;
        
    }
    
    size -= spacing;
    
    float content_size = size;
    
    float target_h = self.frame.size.height - (margin * 2);
    
    if (size > target_h) {
        self.btnContainer.contentSize = CGSizeMake(self.btnContainer.frame.size.width, size);
        
        float closest_target_h = target_h - fmodf(target_h, (btn_h + spacing));
        
        size = closest_target_h - spacing;
    }
    
    self.btnContainer.frame = CGRectMake(0, 0, self.btnContainer.frame.size.width, size);
    self.btnContainer.bounds = self.btnContainer.frame;
    self.btnContainer.center = CGPointMake(self.frame.size.width * .5, self.frame.size.height * .5);
    self.btnContainer.layer.cornerRadius = 5;
    self.btnContainer.layer.masksToBounds = YES;
    
    [self.btnContainer setContentOffset:CGPointMake(0,0) animated:NO];
    [self.btnContainer setContentSize:CGSizeMake(self.btnContainer.frame.size.width, content_size)];
    
    [self selectById:0];
}

- (void)selectById:(int)identifier
{
    for (UIButton* btn in self.btns) {
        if (btn.tag == identifier) {
            btn.backgroundColor = UIColorFromRGB(kActiveColor);
            btn.userInteractionEnabled = NO;
        } else {
            btn.backgroundColor = UIColorFromRGB(kBackgroundColor);
            btn.userInteractionEnabled = YES;
        }
    }
}

- (void)handleDown:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [self selectById:(int)btn.tag];
}

- (void)handleUp:(id)sender
{
    [self selectById:-1];
}

- (void)handleSelect:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    [self selectById:(int)btn.tag];
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(selectedFilter:index:)]) {
            [self.delegate selectedFilter:self index:(int)btn.tag];
        }
    }
    
    [self hide];
}

- (void)handleClose
{
    [self hide];
}

- (void)show
{
    self.userInteractionEnabled = YES;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = NO;
    }];
    
}

@end
