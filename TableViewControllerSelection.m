//
//  TableViewControllerSelection.m
//  DGTU
//
//  Created by Anton Pavlov on 17.01.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "TableViewControllerSelection.h"
#import "TableViewControllerRegister.h"

@interface TableViewControllerSelection () 

@property (strong,nonatomic) HTMLDocument* doc;
@property (strong, nonatomic) NSString *docString;
@property NSURLSession *sess;
@end

@implementation TableViewControllerSelection

- (void)viewDidLoad {
    [super viewDidLoad];
    self.doc = [[HTMLDocument alloc]init];
    self.title = self.group;
    self.numberGroupString = [self.reference substringFromIndex:self.reference.length-5];
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0){//Расписание
       ViewControllerPageView *viewControllerPageView = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerPageView"];
        viewControllerPageView.referencePageView = self.numberGroupString;
        [self.navigationController pushViewController:viewControllerPageView animated:YES];
        
    }else if(indexPath.row == 1){//Ведомость
        TableViewControllerRegister *tableViewControllerRegister = [self.storyboard instantiateViewControllerWithIdentifier:@"TableViewControllerRegister"];
        [tableViewControllerRegister loadRegister:[NSString stringWithFormat:@"http://stud.sssu.ru/Ved/Default.aspx?sem=cur&group=%@",self.numberGroupString]];
        
        [self.navigationController pushViewController:tableViewControllerRegister animated:YES];
        
        
    }else if(indexPath.row == 2){//Графики
//        [viewControllerPageView loadGroupReference:[NSString stringWithFormat:@"http://stud.sssu.ru/Graph/Graph.aspx?group=%@&sem=1",[self numberGroupString]]];
        
    }
    
    
}


-(void) loadGroupReference:(NSString*) URLGroup{
    
        NSURL *URL = [NSURL URLWithString:URLGroup];
        self.sess = [NSURLSession sharedSession];
        [[self.sess dataTaskWithURL:URL completionHandler:
          ^(NSData *data, NSURLResponse *response, NSError *error) {
              NSString *contentType = nil;
              if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                  NSDictionary *headers = [(NSHTTPURLResponse *)response allHeaderFields];
                  contentType = headers[@"Content-Type"];
              }
//              HTMLDocument *home = [HTMLDocument documentWithData:data
//                                                contentTypeHeader:contentType];
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  
              });
              
          }
          ] resume];
   }

//-(void) loadTimeTable:(HTMLDocument*)home day:(NSString*) day
//{
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        self.timeArray = [NSMutableArray array];
//        self.weekArray = [NSMutableArray array];
//        self.subjectArray = [NSMutableArray array];
//        self.teacherArray = [NSMutableArray array];
//        self.classroomArray = [NSMutableArray array];
//        
//        
//        
//        NSInteger dayNum = 2;
//        NSNumber *dayRow;
//        HTMLElement *day;
//        // День недели
//        while (YES) {
//            day = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(1)",(long)dayNum]];
//            if ([day.textContent isEqualToString:day]) {
//                dayRow = day.attributes.allValues.lastObject;
//                break;
//            }else if (day.textContent == nil){
//                break;
//            }
//            dayNum++;
//        }
//        
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            NSInteger dayRowInt = [dayRow integerValue];
//            
//            NSInteger section = dayNum;
//            NSInteger timeRow;
//            NSInteger weekRow;
//            NSInteger subjectRow;
//            NSInteger teacherRow;
//            NSInteger classroomRow;
//            
//            for (; section < dayRowInt+dayNum; section++) {
//                if (section == dayNum) {
//                    timeRow = 2;
//                    weekRow = 3;
//                    subjectRow = 4;
//                    teacherRow = 5;
//                    classroomRow = 6;
//                }else{
//                    timeRow = 1;
//                    weekRow = 2;
//                    subjectRow = 3;
//                    teacherRow = 4;
//                    classroomRow = 5;
//                }
//                
//                HTMLElement *time = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)timeRow]];
//                HTMLElement *week = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)weekRow]];
//                HTMLElement *subject = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)subjectRow]];
//                HTMLElement *teacher = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)teacherRow]];
//                HTMLElement *classroom = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)classroomRow]];
//                if ([week.attributes.allValues.lastObject isEqual:@"2"]) {
//                    [self.timeArray addObject:time.textContent];
//                    [self.timeArray addObject:time.textContent];
//                    
//                    [self.weekArray addObject:@"1"];
//                    [self.weekArray addObject:@"2"];
//                    subject = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)subjectRow-1]];
//                    [self.subjectArray addObject:subject.textContent];
//                    [self.subjectArray addObject:subject.textContent];
//                    
//                    teacher = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)teacherRow-1]];
//                    [self.teacherArray addObject:teacher.textContent];
//                    [self.teacherArray addObject:teacher.textContent];
//                    
//                    classroom = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)classroomRow-1]];
//                    [self.classroomArray addObject:classroom.textContent];
//                    [self.classroomArray addObject:classroom.textContent];
//                    
//                }else{
//                    if ([time.textContent isEqualToString:@"2"]) {
//                        
//                        [self.timeArray addObject:[self.timeArray objectAtIndex:[self.timeArray count]-1]];
//                        [self.weekArray addObject:@"2"];
//                        
//                        subject = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)subjectRow-1]];
//                        [self.subjectArray addObject:subject.textContent];
//                        
//                        teacher = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)teacherRow-1]];
//                        [self.teacherArray addObject:teacher.textContent];
//                        
//                        classroom = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)section,(long)classroomRow-1]];
//                        [self.classroomArray addObject:classroom.textContent];
//                        
//                    }else{
//                        
//                        [self.timeArray addObject:time.textContent];
//                        [self.weekArray addObject:week.textContent];
//                        [self.subjectArray addObject:subject.textContent];
//                        
//                        
//                        [self.teacherArray addObject:teacher.textContent];
//                        [self.classroomArray addObject:classroom.textContent];
//                    }
//                }
//                [self.tableView reloadData];
//            }
//        });
//    });
//}

@end
