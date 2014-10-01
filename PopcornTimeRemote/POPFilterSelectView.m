//
//  POPFilterSelectView.m
//  PopcornTimeRemote
//
//  Created by Isak Wiström on 9/23/14.
//  Copyright (c) 2014 skaggivara. All rights reserved.
//

#import "POPFilterSelectView.h"

@implementation POPFilterSelectView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.maxwidth = self.frame.size.width;
        [self setup:@"undefined" filter:@"undefined"];
    }
    return self;
}

- (id)initWithFrameAndTitle:(CGRect)frame
                      title:(NSString *)title
                     filter:(NSString *)filter
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.maxwidth = self.frame.size.width;
        [self setup:title filter:filter];
    }
    return self;
}


- (void)setup:(NSString *)title
       filter:(NSString *)filter
{
    self.title = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.title.frame = CGRectMake(0, 0, self.frame.size.width * .5, self.frame.size.height);
    //self.title.layer.borderWidth = 1;
    
    self.title.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //self.title.layer.borderColor = [UIColor redColor].CGColor;
    self.title.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.title setTitle:[[[title substringToIndex:1] uppercaseString] stringByAppendingString:[title substringFromIndex:1]] forState:UIControlStateNormal];
    [self.title sizeToFit];
    self.title.frame = CGRectMake(self.title.frame.origin.x, self.title.frame.origin.y, self.title.frame.size.width + 10, self.title.frame.size.height);
    [self.title setTitleColor:UIColorFromRGB(kDefaultColor) forState:UIControlStateNormal];
    [self.title addTarget:self action:@selector(handleTouch) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.title];
    
    self.filter = [UIButton buttonWithType:UIButtonTypeCustom];
    self.filter.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.filter.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.filter.titleLabel.font = [UIFont systemFontOfSize:14];
    self.filter.frame = CGRectMake(self.title.frame.size.width, 0, self.frame.size.width * .5, self.frame.size.height);
    [self.filter setTitle:[[[filter substringToIndex:1] uppercaseString] stringByAppendingString:[filter substringFromIndex:1]] forState:UIControlStateNormal];
    [self.filter sizeToFit];
    self.filter.frame = CGRectMake(self.filter.frame.origin.x, self.filter.frame.origin.y, self.filter.frame.size.width + 15, self.filter.frame.size.height);
    [self.filter setImage:[UIImage imageNamed:@"filter"] forState:UIControlStateNormal];
    [self.filter setTitleColor:UIColorFromRGB(kActiveColor) forState:UIControlStateNormal];
    [self.filter addTarget:self action:@selector(handleTouch) forControlEvents:UIControlEventTouchUpInside];
    
    [self updateSize];
    
    [self addSubview:self.filter];
}

- (void)handleTouch
{
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(selectedFilter:)]) {
            [self.delegate selectedFilter:self];
        }
    }
}


- (void)updateSize
{
    [self.title sizeToFit];
    
    self.title.frame = CGRectMake(self.title.frame.origin.x, self.title.frame.origin.y, self.title.frame.size.width + 10, self.title.frame.size.height);
    
    [self.filter sizeToFit];
    
    if ((self.title.frame.size.width + self.filter.frame.size.width) > self.maxwidth) {
        self.filter.frame = CGRectMake(self.filter.frame.origin.x, self.filter.frame.origin.y, self.maxwidth-self.title.frame.size.width, self.title.frame.size.height);
    } else {
        self.filter.frame = CGRectMake(self.filter.frame.origin.x, self.filter.frame.origin.y, self.filter.frame.size.width + 15, self.title.frame.size.height);
    }
    self.filter.titleEdgeInsets = UIEdgeInsetsMake(0, -self.filter.imageView.frame.size.width, self.title.titleEdgeInsets.bottom, self.filter.imageView.frame.size.width);
    
    self.filter.imageEdgeInsets = UIEdgeInsetsMake(0, self.filter.titleLabel.frame.size.width + 5, 0, -self.filter.titleLabel.frame.size.width);
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.title.frame.size.width + self.filter.frame.size.width, self.title.frame.size.height);
}

- (void)setFilterName:(NSString *)title
{
    [self.filter setTitle:[[[title substringToIndex:1] uppercaseString] stringByAppendingString:[title substringFromIndex:1]] forState:UIControlStateNormal];
    
    [self updateSize];
}

- (void)setTitleName:(NSString *)title
{
    [self.title setTitle:[[[title substringToIndex:1] uppercaseString] stringByAppendingString:[title substringFromIndex:1]] forState:UIControlStateNormal];
    [self updateSize];
}


@end
