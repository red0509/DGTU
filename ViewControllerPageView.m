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
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    self.pageViewController.view.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - 30);
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
     [self loadGroupReference:@"http://stud.sssu.ru/Rasp/Rasp.aspx?group=18856&sem=1"];
    
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

    return 0;
}

-(void) loadGroupReference:(NSString*) URLGroup{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *URL = [NSURL URLWithString:URLGroup];
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithURL:URL completionHandler:
          ^(NSData *data, NSURLResponse *response, NSError *error) {
              NSString *contentType = nil;
              if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                  NSDictionary *headers = [(NSHTTPURLResponse *)response allHeaderFields];
                  contentType = headers[@"Content-Type"];
              }
              HTMLDocument *home = [HTMLDocument documentWithData:data
                                                contentTypeHeader:contentType];
              
             
              
              
              
              HTMLElement *div = [home firstNodeMatchingSelector:@"#cmbDayOfWeek"];
              
            NSLog(@"div -  %@",div.textContent);
              NSLog(@"div -  %@",div.attributes.allValues);
              dispatch_async(dispatch_get_main_queue(), ^{
                  
              });
              
          }
          ] resume];
    });
}
@end
