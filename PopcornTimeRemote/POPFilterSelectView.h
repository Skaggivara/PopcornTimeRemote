//
//  POPFilterSelectView.h
//  PopcornTimeRemote
//
//  Created by Isak Wiström on 9/23/14.
//  Copyright (c) 2014 skaggivara. All rights reserved.
//

#import <UIKit/UIKit.h>

@class POPFilterSelectView;

@protocol POPFilterSelectViewDelegate <NSObject>
@optional
- (void)selectedFilter:(POPFilterSelectView *)filter;
@end

@interface POPFilterSelectView : UIView

@property(strong, nonatomic) UIButton *title;
@property(strong, nonatomic) UIButton *filter;

@property (nonatomic, weak) id <POPFilterSelectViewDelegate> delegate;

@property float maxwidth;

- (id)initWithFrameAndTitle:(CGRect)frame title:(NSString *)title filter:(NSString *)filter;
- (void)setFilterName:(NSString *)title;
- (void)setTitleName:(NSString *)title;
- (void)updateSize;

@end
