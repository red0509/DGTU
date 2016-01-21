//
//  ViewControllerPageView.m
//  DGTU
//
//  Created by Anton Pavlov on 18.01.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "ViewControllerPageView.h"

@interface ViewControllerPageView ()

@property (strong,nonatomic) NSMutableArray *timeArray;
@property (strong,nonatomic) NSMutableArray *weekArray;
@property (strong,nonatomic) NSMutableArray *subjectArray;

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
    self.timeArray = [NSMutableArray array];
    self.weekArray = [NSMutableArray array];
    self.subjectArray = [NSMutableArray array];
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
              NSInteger dayNum = 2;
              NSNumber *dayRow;
              // День недели
              while (YES) {
              HTMLElement *day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(1)",(long)dayNum]];
                  if ([day.textContent isEqualToString:@"Понедельник"]) {
                      dayRow = day.attributes.allValues.lastObject;
                      break;
                  }else if (day.textContent == nil){
                      break;
                  }
                  dayNum++;
              }
              NSInteger dayRowInt = [dayRow integerValue];
              
              NSInteger timeNum = dayNum;
              NSInteger timeRow;
              //Время
              for (; timeNum < dayRowInt+dayNum; timeNum++) {
                  
                  if (timeNum == dayNum) {
                      timeRow = 2;
                  }else{
                      timeRow = 1;
                  }
                  
              HTMLElement *time = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)timeNum,(long)timeRow]];
                  if ([time.textContent isEqualToString:@"2"]) {
                      [self.timeArray addObject:[self.timeArray objectAtIndex:[self.timeArray count]-1]];
                  }else{
                      [self.timeArray addObject:time.textContent];

                  }
                }
              NSInteger weekNum = dayNum;
              NSInteger weekRow;
              // номер Неделя
              for (; weekNum < dayRowInt+dayNum; weekNum++) {
                  
                  if (weekNum == dayNum) {
                      weekRow = 3;
                  }else{
                      weekRow = 2;
                  }
                  
                  HTMLElement *week = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)weekNum,(long)weekRow]];
                  if (![week.textContent isEqualToString:@"1"]) {
                      [self.weekArray addObject:@"2"];
                      [self.weekArray addObject:@"Привет"];
                  }else{
                      [self.weekArray addObject:week.textContent];
                      
                  }
              }
              
              NSInteger subjectNum = dayNum;
              NSInteger subjectRow;
              //Дисциплина
              
              for (; subjectNum < dayRowInt+dayNum; subjectNum++) {
                  
                  NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] ст."];
                  if (subjectNum == dayNum) {
                      subjectRow = 4;
                  }else{
                      subjectRow = 3;
                  }
                  
                  HTMLElement *subject = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)subjectNum,(long)subjectRow]];
                  if ([subject.textContent isEqualToString:@"ст."]) {
                      subjectRow--;
                      HTMLElement *subject = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)subjectNum,(long)subjectRow]];
                      [self.subjectArray addObject:subject.textContent];
                      subjectRow++;
                  }else{
                      [self.subjectArray addObject:subject.textContent];

                  }
                  
              }

              
           //              NSLog(@"div -  %@",day.attributes.allValues);
              dispatch_async(dispatch_get_main_queue(), ^{
//                  NSLog(@"%@",self.timeArray);
//                  NSLog(@"%@",self.weekArray);
                  for (NSString *str in self.subjectArray) {
                      NSLog(@"%@",str);
                  }
                  
              });
              
          }
          ] resume];
    });
}
@end
