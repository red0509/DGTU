//
//  ViewControllerPageFav.h
//  DGTU
//
//  Created by Anton Pavlov on 15.02.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewPageContFav.h"

@interface ViewControllerPageFav : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong ,nonatomic) NSString *tableTime;
@property(strong,nonatomic) NSNumber *university;

@end

