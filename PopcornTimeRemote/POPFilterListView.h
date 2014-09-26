//
//  POPFilterListView.h
//  PopcornTimeRemote
//
//  Created by Isak Wiström on 9/23/14.
//  Copyright (c) 2014 skaggivara. All rights reserved.
//

#import <UIKit/UIKit.h>


@class POPFilterListView;

@protocol POPFilterListViewDelegate <NSObject>
@optional
- (void)selectedFilter:(POPFilterListView *)list index:(int)index;
@end

@interface POPFilterListView : UIView

@property(strong) NSMutableArray *btns;
@property(strong) NSMutableArray *filters;

@property(strong) UIScrollView *btnContainer;
@property(strong) UIButton* backg;

@property (nonatomic, weak) id <POPFilterListViewDelegate> delegate;

- (id)initWithFrameAndFilters:(CGRect)frame filters:(NSArray *)filters;
- (void)selectById:(int)identifier;
- (void)show;
- (void)hide;
- (void)updateList:(NSArray *)list;

@end
