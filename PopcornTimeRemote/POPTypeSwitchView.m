//
//  POPTypeSwitchView.m
//  PopcornTimeRemote
//
//  Created by Isak Wiström on 9/23/14.
//  Copyright (c) 2014 skaggivara. All rights reserved.
//

#import "POPTypeSwitchView.h"

@implementation POPTypeSwitchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setup];
    }
    return self;
}

- (id)initWithFrameAndTitles:(CGRect)frame titles:(NSArray *)titles
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.titles = [titles mutableCopy];
        [self setup];
    }
    return self;
}

-(void)setup
{
    if (self.titles) {
        self.options = [[NSMutableArray alloc] init];
        
        float btn_w = self.frame.size.width / self.titles.count;
        
        for ( NSInteger i = 0; i < [self.titles count]; i++ ) {
            
            NSString *title = [self.titles objectAtIndex:i];
            
            UIButton *option = [UIButton buttonWithType:UIButtonTypeCustom];
            [option setTitle:title forState:UIControlStateNormal];
            [option setTitleColor:UIColorFromRGB(kDefaultColor) forState:UIControlStateNormal];
            option.frame = CGRectMake(i * btn_w, 0, btn_w, self.frame.size.height - 4);
            
            option.tag = i;
            
            [option addTarget:self action:@selector(handleSelect:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:option];
            
            [self.options addObject:option];
            
        }
        
        self.underscore = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 4, self.frame.size.width / self.titles.count, 4)];
        self.underscore.backgroundColor = UIColorFromRGB(kActiveColor);
        [self addSubview:self.underscore];
    }
}

- (void)handleSelect:(id)sender
{
    
    UIButton *btn = (UIButton *)sender;
    
    int index = (int)btn.tag;
    
    [self selectAtIndex:index];
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(selectedType:index:)]) {
            [self.delegate selectedType:self index:index];
        }
    }
}

- (void)selectAtIndex:(int)index
{
    float btn_w = self.frame.size.width / self.titles.count;
    
    self.underscore.frame = CGRectMake(btn_w * index, self.underscore.frame.origin.y, self.underscore.frame.size
                                       .width, self.underscore.frame.size.height);
}

@end
