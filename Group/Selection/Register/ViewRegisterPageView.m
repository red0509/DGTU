//
//  ViewRegisterPageView.m
//  DGTU
//
//  Created by Anton Pavlov on 26.01.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "ViewRegisterPageView.h"
#import <HTMLReader.h>


@interface ViewRegisterPageView ()



@end

@implementation ViewRegisterPageView

#define STATE_EXAM 30
#define PRACTICE 30
#define GRADUATION_WORK 30
#define COURSE_PROJECT 40
#define COURSE_WORK 40


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.referencePageView = [self.referencePageView substringFromIndex:self.referencePageView.length-6];
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    self.title = @"Ведомости";
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    TableViewRegisterContent *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [self OrientationDidChange];
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}




-(void)OrientationDidChange
{
    UIDeviceOrientation Orientation=[[UIDevice currentDevice]orientation];
    
    if(Orientation==UIDeviceOrientationLandscapeLeft || Orientation==UIDeviceOrientationLandscapeRight){
        self.pageViewController.view.frame = CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height - 65);
    }else if(Orientation==UIDeviceOrientationPortrait){
        self.pageViewController.view.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - 65);
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        tableViewRegisterContent.pageIndex = COURSE_PROJECT;
    }else if([self.pageTitles[0] isEqualToString:@"Курсовая работа" ]){
        tableViewRegisterContent.pageIndex = COURSE_WORK;
    }else if([self.pageTitles[0] isEqualToString:@"Практика" ]){
        tableViewRegisterContent.pageIndex = PRACTICE;
    }else if([self.pageTitles[0] isEqualToString:@"ГосЭкзамен" ]){
        tableViewRegisterContent.pageIndex = STATE_EXAM;
    }else if([self.pageTitles[0] isEqualToString:@"Выпуская работа" ]){
        tableViewRegisterContent.pageIndex = GRADUATION_WORK;
    }else{
        tableViewRegisterContent.pageIndex = index;
        tableViewRegisterContent.count = [self.pageTitles count];

    }
        tableViewRegisterContent.referenceUniversity = self.referenceUniversity;
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
