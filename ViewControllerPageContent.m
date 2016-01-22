//
//  ViewControllerPageContent.m
//  DGTU
//
//  Created by Anton Pavlov on 18.01.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "ViewControllerPageContent.h"

@interface ViewControllerPageContent ()

@property (strong,nonatomic) NSMutableArray *timeArray;
@property (strong,nonatomic) NSMutableArray *weekArray;
@property (strong,nonatomic) NSMutableArray *subjectArray;
@property (strong,nonatomic) NSMutableArray *teacherArray;
@property (strong,nonatomic) NSMutableArray *classroomArray;

@end

@implementation ViewControllerPageContent

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.labelTitle.text = self.titleText;
//    [self loadTimeTable];
    NSLog(@"3");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



-(void) loadTimeTable
{
    self.timeArray = [NSMutableArray array];
    self.weekArray = [NSMutableArray array];
    self.subjectArray = [NSMutableArray array];
    self.teacherArray = [NSMutableArray array];
    self.classroomArray = [NSMutableArray array];
    
       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        self.document = [[HTMLDocument alloc] init];
        HTMLDocument *home;
        NSLog(@"home - %@",self.document.textContent);
              NSInteger dayNum = 2;
              NSNumber *dayRow;
              HTMLElement *day;
              // День недели
              while (YES) {
                  day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(1)",(long)dayNum]];
                  if ([day.textContent isEqualToString:@"Вторник"]) {
                      dayRow = day.attributes.allValues.lastObject;
                      break;
                  }else if (day.textContent == nil){
                      break;
                  }
                  dayNum++;
              }

              
              dispatch_async(dispatch_get_main_queue(), ^{
                  
                  NSInteger dayRowInt = [dayRow integerValue];
                  
                  NSInteger section = dayNum;
                  NSInteger timeRow;
                  NSInteger weekRow;
                  NSInteger subjectRow;
                  NSInteger teacherRow;
                  NSInteger classroomRow;
                  
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
                          
                          teacher = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)teacherRow-1]];
                          [self.teacherArray addObject:teacher.textContent];
                          [self.teacherArray addObject:teacher.textContent];
                          
                          classroom = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)classroomRow-1]];
                          [self.classroomArray addObject:classroom.textContent];
                          [self.classroomArray addObject:classroom.textContent];
                          
                      }else{
                          if ([time.textContent isEqualToString:@"2"]) {
                              
                              [self.timeArray addObject:[self.timeArray objectAtIndex:[self.timeArray count]-1]];
                              [self.weekArray addObject:@"2"];
                              
                              subject = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)subjectRow-1]];
                              [self.subjectArray addObject:subject.textContent];
                              
                              teacher = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)teacherRow-1]];
                              [self.teacherArray addObject:teacher.textContent];
                              
                              classroom = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)classroomRow-1]];
                              [self.classroomArray addObject:classroom.textContent];
                              
                          }else{
                              
                              [self.timeArray addObject:time.textContent];
                              [self.weekArray addObject:week.textContent];
                              [self.subjectArray addObject:subject.textContent];
                              [self.teacherArray addObject:teacher.textContent];
                              [self.classroomArray addObject:classroom.textContent];
                          }
                      }
                  }
                  NSLog(@"%@",self.timeArray);
                  
        });
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    
    if (self.pageIndex == 0) {
        [self loadTimeTable];
    }else if (self.pageIndex == 1) {
    }else if (self.pageIndex == 2) {
    }
    return cell;

}


@end
