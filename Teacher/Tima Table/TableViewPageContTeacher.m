//
//  TableViewPageContTeacher.m
//  DGTU
//
//  Created by Anton Pavlov on 25.03.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "TableViewPageContTeacher.h"
#import "TableViewCellContent.h"


@interface TableViewPageContTeacher ()

@property (strong,nonatomic) NSMutableArray *timeArray;
@property (strong,nonatomic) NSMutableArray *weekArray;
@property (strong,nonatomic) NSMutableArray *subjectArray;
@property (strong,nonatomic) NSMutableArray *groupArray;
@property (strong,nonatomic) NSMutableArray *classroomArray;

@property (strong,nonatomic) NSMutableArray *timeArrayWeekTwo;
@property (strong,nonatomic) NSMutableArray *weekArrayWeekTwo;
@property (strong,nonatomic) NSMutableArray *subjectArrayWeekTwo;
@property (strong,nonatomic) NSMutableArray *groupArrayWeekTwo;
@property (strong,nonatomic) NSMutableArray *classroomArrayWeekTwo;

@end

@implementation TableViewPageContTeacher

- (void)viewDidLoad {
    [super viewDidLoad];
    self.labelTitle.text = self.titleText;
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"M"];
    NSString * strintDate = [dateFormatter stringFromDate:date];
    NSInteger intDate = [strintDate integerValue];
    NSString *semester;
    if (intDate > 8 || intDate == 1) {
        semester =  @"1";
    }else{
        semester = @"2";
    }
    
    self.tableView.estimatedRowHeight = 135.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    // мальцев
    // http://stud.sssu.ru/Rasp/Rasp.aspx?&year=2015-2016&prep=%CC%E0%EB%FC%F6%E5%E2%20%C8.%CC.&sem=2
    // михайлов
    // http://stud.sssu.ru/Rasp/Rasp.aspx?&year=2015-2016&prep=%CC%E8%F5%E0%E9%EB%EE%E2%20%C0.%C1.&sem=2
    // медведев
    // http://stud.sssu.ru/Rasp/Rasp.aspx?&year=2015-2016&prep=%CC%E5%E4%E2%E5%E4%E5%E2%20%C4.%C2.&sem=2
    
    
    if (self.pageIndex == 0) {
        [self loadGroupReference:@"http://stud.sssu.ru/Rasp/Rasp.aspx?&year=2015-2016&prep=%C1%E0%F0%E0%F8%FF%ED%20%CB.%D0.&sem=2" day:@"Понедельник"];
        
    }else if (self.pageIndex == 1){
        [self loadGroupReference:
         @"http://stud.sssu.ru/Rasp/Rasp.aspx?&year=2015-2016&prep=%C1%E0%F0%E0%F8%FF%ED%20%CB.%D0.&sem=2"day:@"Вторник"];
        
    }else if (self.pageIndex == 2){
        [self loadGroupReference:
         @"http://stud.sssu.ru/Rasp/Rasp.aspx?&year=2015-2016&prep=%C1%E0%F0%E0%F8%FF%ED%20%CB.%D0.&sem=2" day:@"Среда"];
        
    }else if (self.pageIndex == 3){
        [self loadGroupReference:
         @"http://stud.sssu.ru/Rasp/Rasp.aspx?&year=2015-2016&prep=%C1%E0%F0%E0%F8%FF%ED%20%CB.%D0.&sem=2" day:@"Четверг"];
        
    }else if (self.pageIndex == 4){
        [self loadGroupReference:
         @"http://stud.sssu.ru/Rasp/Rasp.aspx?&year=2015-2016&prep=%C1%E5%F0%E5%E7%E0%20%C0.%CD.&sem=2"  day:@"Пятница"];
        
    }else if (self.pageIndex == 5){
        [self loadGroupReference:
         @"http://stud.sssu.ru/Rasp/Rasp.aspx?&year=2015-2016&prep=%C1%E5%F0%E5%E7%E0%20%C0.%CD.&sem=2"
                             day:@"Суббота"];
    }
    
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) loadGroupReference:(NSString*) URLGroup day:(NSString*) weekDay{
    
    NSURL *URL = [NSURL URLWithString:URLGroup];
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.timeoutIntervalForResource = 5;
    sessionConfig.timeoutIntervalForRequest = 5;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    
    [[session dataTaskWithURL:URL completionHandler:
      ^(NSData *data, NSURLResponse *response, NSError *error) {
          
          if (error != nil) {
              dispatch_async(dispatch_get_main_queue(), ^{
                  UIAlertController *alert= [UIAlertController alertControllerWithTitle:@"Ошибка" message:@"Не удается подключится." preferredStyle:UIAlertControllerStyleAlert];
                  
                  UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                          style:UIAlertActionStyleDefault
                                                                        handler:^(UIAlertAction * action) {
                                                                            [self.navigationController popViewControllerAnimated:YES];
                                                                        }];
                  [alert addAction:defaultAction];
                  
                  [self.navigationController presentViewController:alert animated:YES completion:nil];
              });
          }else{
              
              NSString *contentType = nil;
              if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                  NSDictionary *headers = [(NSHTTPURLResponse *)response allHeaderFields];
                  contentType = headers[@"Content-Type"];
              }
              HTMLDocument *home = [HTMLDocument documentWithData:data
                                                contentTypeHeader:contentType];
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  [self loadTimeTable:home day:weekDay];
              });
          }
      }] resume];
}


-(void) loadTimeTable:(HTMLDocument*)home day:(NSString*) weekDay
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.timeArray = [NSMutableArray array];
        self.weekArray = [NSMutableArray array];
        self.subjectArray = [NSMutableArray array];
        self.groupArray = [NSMutableArray array];
        self.classroomArray = [NSMutableArray array];
        
        self.timeArrayWeekTwo = [NSMutableArray array];
        self.weekArrayWeekTwo = [NSMutableArray array];
        self.subjectArrayWeekTwo = [NSMutableArray array];
        self.groupArrayWeekTwo = [NSMutableArray array];
        self.classroomArrayWeekTwo = [NSMutableArray array];
        
        
        
        NSInteger dayNum = 2;
        NSNumber *dayRow;
        HTMLElement *day;
        // День недели
        while (YES) {
            day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(1)",(long)dayNum]];
            if ([day.textContent isEqualToString:weekDay]) {
                if ([day.attributes.allValues.lastObject isEqual:@"center"]) {
                    dayRow=@1;
                }else{
                    dayRow = day.attributes.allValues.lastObject;
                }
                
                break;
            }else if (day.textContent == nil){
                break;
            }
            dayNum++;
        }
        NSLog(@"%@",day.textContent);
        NSLog(@"dayNum - %ld",dayNum);
        NSLog(@"dayRow - %@",dayRow);
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSInteger dayRowInt = [dayRow integerValue];
            
            NSInteger section = dayNum;
            NSInteger timeRow;
            NSInteger weekRow;
            NSInteger subjectRow;
            NSInteger groupRow;
            NSInteger classroomRow;
            for (; section < dayRowInt+dayNum; section++) {
                if (section == dayNum) {
                    timeRow = 2;
                    weekRow = 3;
                    subjectRow = 4;
                    groupRow = 5;
                    classroomRow = 6;
                }else{
                    timeRow = 1;
                    weekRow = 2;
                    subjectRow = 3;
                    groupRow = 4;
                    classroomRow = 5;
                }
                HTMLElement *subject = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)subjectRow]];
                HTMLElement *time = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)timeRow]];
                HTMLElement *week = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)weekRow]];
                HTMLElement *group = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)groupRow]];
                HTMLElement *classroom = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)classroomRow]];

                
                if(![week.textContent isEqualToString:@"1"]){
                    if ([week.textContent isEqualToString:@"2"]) {
                        week = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)weekRow]];
                        subject = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)subjectRow]];
                        group = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)groupRow]];
                        classroom = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)classroomRow]];
                    }else{

                        week = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)weekRow-1]];
                        subject = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)subjectRow-1]];
                        group = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)groupRow-1]];
                        classroom = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)classroomRow-1]];
                    }
                    if (week.textContent.length>3) {

                            subject = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)subjectRow-2]];
                            group = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)groupRow-2]];
                            classroom = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)classroomRow-2]];
                    }
                }
                if (classroom.textContent == nil) {
                    subject = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section-1,(long)subjectRow]];
                    group = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)groupRow-2]];
                    classroom = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)classroomRow-2]];
                }
                
                NSNumber *timeNum = time.attributes.allValues.lastObject;
                NSInteger timeInt = [timeNum integerValue];
                if (timeInt != 0 ||[timeNum isEqual:@"center"]) {
                    if (![time.textContent isEqualToString:@"2"]) {
                        if ([timeNum isEqual:@"center"]) {
                            timeInt=1;
                        }
                        for (NSInteger i = 0; i<timeInt; i++) {
                            [self.timeArray addObject:time.textContent];
                        }
                    }
                }
                NSNumber *weekNum = week.attributes.allValues.lastObject;
                NSInteger weekInt = [weekNum integerValue];
                if (weekInt != 0 ||[weekNum isEqual:@"center"]) {
                    if ([weekNum isEqual:@"center"]) {
                        weekInt=1;
                    }
                    
                    for (NSInteger i = 0; i<weekInt; i++) {
                        [self.weekArray addObject:week.textContent];
                        
                    }
                }

                [self.subjectArray addObject:subject.textContent];
                [self.groupArray addObject:group.textContent];
                [self.classroomArray addObject:classroom.textContent];
                
                
            }
            
            
            for (NSInteger i = 0; i<[self.weekArray count]; i++) {
                if ([self.weekArray[i] isEqual:@"2"]) {
                    [self.timeArrayWeekTwo addObject:self.timeArray[i]];
                    [self.weekArrayWeekTwo addObject:self.weekArray[i]];
                    [self.subjectArrayWeekTwo addObject:self.subjectArray[i]];
                    [self.groupArrayWeekTwo addObject:self.groupArray[i]];
                    [self.classroomArrayWeekTwo addObject:self.classroomArray[i]];
                }
                [self.tableView reloadData];
            }
            for (NSInteger i = 0; i<[self.weekArray count]; i++) {
                if ([self.weekArray[i] isEqual:@"2"]) {
                    [self.timeArray removeObjectAtIndex:i];
                    [self.weekArray removeObjectAtIndex:i];
                    [self.subjectArray removeObjectAtIndex:i];
                    [self.groupArray removeObjectAtIndex:i];
                    [self.classroomArray removeObjectAtIndex:i];
                    i--;
                }
                [self.tableView reloadData];
            }
            
            

            NSLog(@"------------------------");
        });
    });
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:
                                 CGRectMake(0, 0, tableView.frame.size.width, 20)];
    sectionHeaderView.backgroundColor = [UIColor colorWithRed:100.0f/255.0f green:181.0f/255.0f blue:246.0f/255.0f alpha:1.0f];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:
                            CGRectMake(15, 10, sectionHeaderView.frame.size.width, 15)];
    
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textAlignment = NSTextAlignmentLeft;
    [headerLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
    [sectionHeaderView addSubview:headerLabel];
    
    switch (section) {
        case 0:
            if ([self.timeArray count]==0) {
                headerLabel.text = @"Первая неделя - выходной";
            }else{
                headerLabel.text = @"Первая неделя";
            }
            
            return sectionHeaderView;
            break;
        case 1:
            if ([self.timeArrayWeekTwo count]==0) {
                headerLabel.text = @"Вторая неделя - выходной";
            }else{
                headerLabel.text = @"Вторая неделя";
            }
            
            return sectionHeaderView;
            break;
        default:
            break;
    }
    
    return sectionHeaderView;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return [self.timeArray count];
    }else {
        return [self.timeArrayWeekTwo count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    TableViewCellContent *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (indexPath.section == 0) {
        cell.num.text = [NSString stringWithFormat:@"%d",(int)indexPath.row+1];
        NSMutableString* time= self.timeArray[indexPath.row];
        if (time.length>6) {
            [time insertString:@" " atIndex:time.length-5];
        }
        cell.time.text = [NSString stringWithFormat:@"Время: %@",time];
        cell.subject.text = [NSString stringWithFormat:@"Дисциплина: %@",self.subjectArray[indexPath.row]];
        cell.room.text =[NSString stringWithFormat:@"Аудитория: %@",  self.classroomArray[indexPath.row]];
        cell.teacher.text = [NSString stringWithFormat:@"Группа: %@",self.groupArray[indexPath.row]];
        
    }else{
        cell.num.text = [NSString stringWithFormat:@"%d",(int)indexPath.row+1];
        NSMutableString* time2= self.timeArrayWeekTwo[indexPath.row];
        if (time2.length>6) {
            [time2 insertString:@" " atIndex:time2.length-5];
        }
        cell.time.text = [NSString stringWithFormat:@"Время: %@",time2];
        cell.subject.text = [NSString stringWithFormat:@"Дисциплина: %@",self.subjectArrayWeekTwo[indexPath.row]];
        cell.room.text =[NSString stringWithFormat:@"Аудитория: %@",  self.classroomArrayWeekTwo[indexPath.row]];
        cell.teacher.text = [NSString stringWithFormat:@"Группа: %@",self.groupArrayWeekTwo[indexPath.row]];
        
    }
    return cell;
    
}


@end
