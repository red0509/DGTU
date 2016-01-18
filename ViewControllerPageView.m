//
//  ViewControllerPageView.m
//  DGTU
//
//  Created by Anton Pavlov on 18.01.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "ViewControllerPageView.h"

@interface ViewControllerPageView ()

@end

@implementation ViewControllerPageView

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pageTitles = @[@"Понедельник", @"Вторник", @"Среда", @"Четверг",@"Пятница",@"Суббота"];
        
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    self.title = @"Расписание";
    
    ViewControllerPageContent *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (ViewControllerPageContent *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    ViewControllerPageContent *viewControllerPageContent = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerPageContent"];
    viewControllerPageContent.titleText = self.pageTitles[index];
    viewControllerPageContent.pageIndex = index;
    
    return viewControllerPageContent;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((ViewControllerPageContent*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((ViewControllerPageContent*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    NSString *calendarId = [[NSLocale currentLocale] objectForKey:NSLocaleCalendar];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:calendarId];
    NSUInteger firstDay = [calendar firstWeekday];
   
    NSLog(@"%ld",firstDay);
    return firstDay;
}


@end
