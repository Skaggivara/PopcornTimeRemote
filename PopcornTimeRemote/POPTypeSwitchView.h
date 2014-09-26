//
//  POPTypeSwitchView.h
//  PopcornTimeRemote
//
//  Created by Isak Wiström on 9/23/14.
//  Copyright (c) 2014 skaggivara. All rights reserved.
//

#import <UIKit/UIKit.h>

@class POPTypeSwitchView;

@protocol POPTypeSwitchViewDelegate <NSObject>
@optional
- (void)selectedType:(POPTypeSwitchView *)type index:(int)index;
@end

@interface POPTypeSwitchView : UIView

@property(strong, nonatomic) NSMutableArray *titles;
@property(strong, nonatomic) NSMutableArray *options;

@property(strong, nonatomic) UIView *underscore;

@property (nonatomic, weak) id <POPTypeSwitchViewDelegate> delegate;

- (id)initWithFrameAndTitles:(CGRect)frame titles:(NSArray *)titles;
- (void)selectAtIndex:(int)index;

@end
