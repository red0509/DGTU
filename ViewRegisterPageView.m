//
//  ViewRegisterPageView.m
//  DGTU
//
//  Created by Anton Pavlov on 26.01.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "ViewRegisterPageView.h"

@interface ViewRegisterPageView ()

@end

@implementation ViewRegisterPageView

- (void)viewDidLoad
{
    [super viewDidLoad];
    if([self.pageTitles[2] isEqualToString:@"Курсовой проект" ]){
        self.pageTitles = @[@"Курсовой проект"];
    }else if([self.pageTitles[2] isEqualToString:@"Курсовая работа" ]){
        self.pageTitles = @[@"Курсовая работа"];
    }
    self.referencePageView = [self.referencePageView substringFromIndex:self.referencePageView.length-6];
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    self.title = @"Ведомости";
    
    TableViewRegisterContent *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    self.pageViewController.view.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - 65);
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (TableViewRegisterContent *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    TableViewRegisterContent *tableViewRegisterContent = [self.storyboard instantiateViewControllerWithIdentifier:@"TableViewRegisterContent"];
    tableViewRegisterContent.titleText = self.pageTitles[index];
    
    if([self.pageTitles[0] isEqualToString:@"Курсовой проект" ]){
        tableViewRegisterContent.pageIndex = 4;
    }else if([self.pageTitles[0] isEqualToString:@"Курсовая работа" ]){
        tableViewRegisterContent.pageIndex = 4;
    }else{
        tableViewRegisterContent.pageIndex = index;
    }
    
    tableViewRegisterContent.referenceContent = self.referencePageView;
    return tableViewRegisterContent;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((TableViewRegisterContent*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((TableViewRegisterContent*) viewController).pageIndex;
    
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
    
    return 0;
}


@end
