//
//  GuideView.h
//  ProjectDemo
//
//  Created by 远方 on 2017/3/2.
//  Copyright © 2017年 远方. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageControl : UIView

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger count;

@end

@interface GuideView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray<NSString *> *images;

- (void)removeAll;

@end
