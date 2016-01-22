//
//  ViewControllerPageView.h
//  DGTU
//
//  Created by Anton Pavlov on 18.01.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HTMLReader.h>
#import "ViewControllerPageContent.h"

@interface ViewControllerPageView : UIViewController <UIPageViewControllerDataSource>

-(void) loadGroupReference:(NSString*) URLGroup;

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;


@end