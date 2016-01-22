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
@property (strong,nonatomic) NSMutableArray *teacherArray;
@property (strong,nonatomic) NSMutableArray *classroomArray;

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
    
    self.pageViewController.view.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - 90);
    
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

    return 0;
}

-(void) loadGroupReference:(NSString*) URLGroup{
    self.timeArray = [NSMutableArray array];
    self.weekArray = [NSMutableArray array];
    self.subjectArray = [NSMutableArray array];
    self.teacherArray = [NSMutableArray array];
    self.classroomArray = [NSMutableArray array];
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
              HTMLElement *day;
              // День недели
              while (YES) {
              day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(1)",(long)dayNum]];
                  if ([day.textContent isEqualToString:@"Понедельник"]) {
                      dayRow = day.attributes.allValues.lastObject;
                      break;
                  }else if (day.textContent == nil){
                      break;
                  }
                  dayNum++;
              }
              NSInteger dayRowInt = [dayRow integerValue];
              
              NSInteger section = dayNum;
              NSInteger timeRow;
              NSInteger weekRow;
              NSInteger subjectRow;
              NSInteger teacherRow;
              NSInteger classroomRow;
//              Время
              for (; section < dayRowInt+dayNum; section++) {
                  
                  if (section == dayNum) {
                      timeRow = 2;
                      weekRow = 3;
                      subjectRow = 4;
                      teacherRow = 5;
                      classroomRow = 6;
                  }else{
                      timeRow = 1;
                      weekRow = 2;
                      subjectRow = 3;
                      teacherRow = 4;
                      classroomRow = 5;
                  }
                  
              HTMLElement *time = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)timeRow]];
              HTMLElement *week = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)weekRow]];
              HTMLElement *subject = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)subjectRow]];
              HTMLElement *teacher = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)teacherRow]];
              HTMLElement *classroom = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)classroomRow]];
                  if ([week.attributes.allValues.lastObject isEqual:@"2"]) {
                      [self.timeArray addObject:time.textContent];
                      [self.timeArray addObject:time.textContent];
                      
                      [self.weekArray addObject:@"1"];
                      [self.weekArray addObject:@"2"];
                      subject = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)subjectRow-1]];
                      [self.subjectArray addObject:subject.textContent];
                      [self.subjectArray addObject:subject.textContent];
                      NSLog(@"subject0-   %@",subject.textContent);
                      
                      teacher = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)teacherRow-1]];
                      [self.teacherArray addObject:teacher.textContent];
                      [self.teacherArray addObject:teacher.textContent];
                      NSLog(@"teacher0-   %@",teacher.textContent);
                      
                      classroom = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)classroomRow-1]];
                      [self.classroomArray addObject:classroom.textContent];
                      [self.classroomArray addObject:classroom.textContent];
                      NSLog(@"classroom0- %@",classroom.textContent);

                  }else{
                  if ([time.textContent isEqualToString:@"2"]) {
                      
                      [self.timeArray addObject:[self.timeArray objectAtIndex:[self.timeArray count]-1]];
                      NSLog(@"time1-      %@",time.textContent);
                      
                      [self.weekArray addObject:@"2"];
                      NSLog(@"week1-      %@",week.textContent);
                      
                    subject = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)subjectRow-1]];
                      [self.subjectArray addObject:subject.textContent];
                      NSLog(@"subject1-   %@",subject.textContent);
                      
                    teacher = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)teacherRow-1]];
                      [self.teacherArray addObject:teacher.textContent];
                       NSLog(@"teacher1-   %@",teacher.textContent);
                      
                    classroom = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)classroomRow-1]];
                      [self.classroomArray addObject:classroom.textContent];
                       NSLog(@"classroom1- %@",classroom.textContent);
                      
                  }else{
                      
                      [self.timeArray addObject:time.textContent];
                      NSLog(@"time2-      %@",time.textContent);
                      
                      [self.weekArray addObject:week.textContent];
                      NSLog(@"week2-      %@",week.textContent);
                      
                      [self.subjectArray addObject:subject.textContent];
                      NSLog(@"subject2-   %@",subject.textContent);
                      
                      [self.teacherArray addObject:teacher.textContent];
                      NSLog(@"teacher2-   %@",teacher.textContent);
                      
                      [self.classroomArray addObject:classroom.textContent];
                      NSLog(@"classroom2- %@",classroom.textContent);
                  }
                }
            }
              
              
           //              NSLog(@"div -  %@",day.attributes.allValues);
              dispatch_async(dispatch_get_main_queue(), ^{
                  NSLog(@"%@",self.timeArray);
                  NSLog(@"%@",self.weekArray);
                  for (NSString *str in self.subjectArray) {
                      NSLog(@"%@",str);
                  }
                  for (NSString *str in self.teacherArray) {
                      NSLog(@"%@",str);
                  }
                  for (NSString *str in self.classroomArray) {
                      NSLog(@"%@",str);
                  }
              });
              
          }
          ] resume];
    });
}
@end
