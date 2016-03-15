//
//  TableViewPageContFav.m
//  DGTU
//
//  Created by Anton Pavlov on 18.01.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "TableViewPageContFav.h"
#import "TableViewCellContent.h"

@interface TableViewPageContFav ()

@property (strong,nonatomic) NSMutableArray *timeArray;
@property (strong,nonatomic) NSMutableArray *weekArray;
@property (strong,nonatomic) NSMutableArray *subjectArray;
@property (strong,nonatomic) NSMutableArray *teacherArray;
@property (strong,nonatomic) NSMutableArray *classroomArray;

@property (strong,nonatomic) NSMutableArray *timeArrayWeekTwo;
@property (strong,nonatomic) NSMutableArray *weekArrayWeekTwo;
@property (strong,nonatomic) NSMutableArray *subjectArrayWeekTwo;
@property (strong,nonatomic) NSMutableArray *teacherArrayWeekTwo;
@property (strong,nonatomic) NSMutableArray *classroomArrayWeekTwo;

@end

@implementation TableViewPageContFav

- (void)viewDidLoad {
    [super viewDidLoad];
    self.labelTitle.text = self.titleText;
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    self.tableView.estimatedRowHeight = 68.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [dateFormatter setDateFormat:@"M"];
    NSString * strintDate = [dateFormatter stringFromDate:date];
    NSInteger intDate = [strintDate integerValue];
    NSString *semester;
    if (intDate > 8 || intDate == 1) {
        semester =  @"1";
    }else{
        semester = @"2";
    }
    
    
    if (self.pageIndex == 0) {
        [self loadGroupReference:self.timeTable day:@"Понедельник"];
        
    }else if (self.pageIndex == 1){
        [self loadGroupReference:self.timeTable day:@"Вторник"];
        
    }else if (self.pageIndex == 2){
        [self loadGroupReference:self.timeTable day:@"Среда"];
        
    }else if (self.pageIndex == 3){
        [self loadGroupReference:self.timeTable day:@"Четверг"];
        
    }else if (self.pageIndex == 4){
        [self loadGroupReference:self.timeTable day:@"Пятница"];
        
    }else if (self.pageIndex == 5){
        [self loadGroupReference:self.timeTable day:@"Суббота"];
    }
    
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) loadGroupReference:(NSString*) URLGroup day:(NSString*) weekDay{
    
    HTMLDocument *home = [[HTMLDocument alloc] initWithString:URLGroup];
    
    [self loadTimeTable:home day:weekDay];
}


-(void) loadTimeTable:(HTMLDocument*)home day:(NSString*) weekDay
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.timeArray = [NSMutableArray array];
        self.weekArray = [NSMutableArray array];
        self.subjectArray = [NSMutableArray array];
        self.teacherArray = [NSMutableArray array];
        self.classroomArray = [NSMutableArray array];
        
        self.timeArrayWeekTwo = [NSMutableArray array];
        self.weekArrayWeekTwo = [NSMutableArray array];
        self.subjectArrayWeekTwo = [NSMutableArray array];
        self.teacherArrayWeekTwo = [NSMutableArray array];
        self.classroomArrayWeekTwo = [NSMutableArray array];
        
        
        
        NSInteger dayNum = 2;
        NSNumber *dayRow;
        HTMLElement *day;
        // День недели
        while (YES) {
            day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(1)",(long)dayNum]];
            if ([day.textContent isEqualToString:weekDay]) {
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
                
                HTMLElement *teacher = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)teacherRow]];
                if (teacher.textContent == nil) {
                    
                    section++;
                }
                
                HTMLElement *time = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)timeRow]];
                HTMLElement *week = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)weekRow]];
                HTMLElement *subject = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)subjectRow]];
                teacher = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)teacherRow]];
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
            
            for (NSInteger i = 0; i<[self.weekArray count]; i++) {
                if ([self.weekArray[i] isEqual:@"2"]) {
                    [self.timeArrayWeekTwo addObject:self.timeArray[i]];
                    [self.weekArrayWeekTwo addObject:self.weekArray[i]];
                    [self.subjectArrayWeekTwo addObject:self.subjectArray[i]];
                    [self.teacherArrayWeekTwo addObject:self.teacherArray[i]];
                    [self.classroomArrayWeekTwo addObject:self.classroomArray[i]];
                }
                [self.tableView reloadData];
            }
            for (NSInteger i = 0; i<[self.weekArray count]; i++) {
                if ([self.weekArray[i] isEqual:@"2"]) {
                    [self.timeArray removeObjectAtIndex:i];
                    [self.weekArray removeObjectAtIndex:i];
                    [self.subjectArray removeObjectAtIndex:i];
                    [self.teacherArray removeObjectAtIndex:i];
                    [self.classroomArray removeObjectAtIndex:i];
                    i--;
                }
                [self.tableView reloadData];
            }
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
        if ([self.timeArray[indexPath.row] isEqualToString:@"8-3010-05"]) {
            cell.time.text = @"8-30 10-05";
        }else{
            cell.time.text = self.timeArray[indexPath.row];
        }
        cell.subject.text = self.subjectArray[indexPath.row];
        cell.room.text =[NSString stringWithFormat:@"Аудитория %@",  self.classroomArray[indexPath.row]];
        cell.teacher.text = self.teacherArray[indexPath.row];
        
    }else{
        cell.num.text = [NSString stringWithFormat:@"%d",(int)indexPath.row+1];
        if ([self.timeArrayWeekTwo[indexPath.row] isEqualToString:@"8-3010-05"]) {
            cell.time.text = @"8-30 10-05";
        }else{
            cell.time.text = self.timeArrayWeekTwo[indexPath.row];
        }
        cell.subject.text = self.subjectArrayWeekTwo[indexPath.row];
        cell.room.text =[NSString stringWithFormat:@"Аудитория %@",  self.classroomArrayWeekTwo[indexPath.row]];
        cell.teacher.text = self.teacherArrayWeekTwo[indexPath.row];
        
    }
    
    return cell;
    
}


@end
