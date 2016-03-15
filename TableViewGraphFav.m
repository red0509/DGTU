//
//  TableViewControllerGraph.m
//  DGTU
//
//  Created by Anton Pavlov on 29.01.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "TableViewGraphFav.h"
#import "TableViewCellGraph.h"


@interface TableViewGraphFav ()

@property (strong,nonatomic) NSMutableArray *subjectArray;
@property (strong,nonatomic) NSMutableArray *typeArray;
@property (strong,nonatomic) NSMutableArray *teacherArray;
@property (strong,nonatomic) NSMutableArray *dateArray;

@end

@implementation TableViewGraphFav

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"График";
    self.tableView.estimatedRowHeight = 68.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void) loadGraph:(NSString*) str sem:(NSString*) sem{
    
    self.subjectArray = [NSMutableArray array];
    self.typeArray = [NSMutableArray array];
    self.teacherArray = [NSMutableArray array];
    self.dateArray = [NSMutableArray array];
//    NSLog(@"doc %@",home.textContent);
   
    HTMLDocument *home = [[HTMLDocument alloc]initWithString:str];
    
    if ([sem isEqualToString:@"1"]) {
        NSInteger num = 5;
        while (YES) {
            HTMLElement *subject = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(2)",(long)num]];
            if (subject.textContent == nil) {
                break;
            }else{
                [self.subjectArray addObject:subject.textContent];
                num++;
            }
        }
        
        for (NSInteger i = 5; i<num; i++) {
            HTMLElement *type = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(3)",(long)i]];
            [self.typeArray addObject:type.textContent];
            
            HTMLElement *teacher = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(31)",(long)i]];
            if (teacher.textContent == nil) {
                [self.teacherArray addObject:@" "];
            }else{
                [self.teacherArray addObject:teacher.textContent];
            }
            
            HTMLElement *date;
            if ([self.typeArray[i-5] isEqualToString:@"Зачет"]) {
                date = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(29)",(long)i]];
            }else{
                date = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(30)",(long)i]];
            }
            if (date.textContent == nil) {
                [self.dateArray addObject:@" "];
            }else{
                [self.dateArray addObject:date.textContent];
            }
            [self.tableView reloadData];
        }
        
    }else if([sem isEqualToString:@"2"]){
        NSInteger num = 5;
        while (YES) {
            HTMLElement *subject = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(2)",(long)num]];
            if (subject.textContent == nil) {
                break;
            }else{
                [self.subjectArray addObject:subject.textContent];
                num++;
            }
        }
        
        for (NSInteger i = 5; i<num; i++) {
            HTMLElement *type = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(3)",(long)i]];
            [self.typeArray addObject:type.textContent];
            
            HTMLElement *teacher = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(37)",(long)i]];
            
            if (teacher.textContent == nil) {
                [self.teacherArray addObject:@" "];
            }else{
                [self.teacherArray addObject:teacher.textContent];
            }
            
            HTMLElement *date;
            if ([self.typeArray[i-5] isEqualToString:@"Зачет"]) {
                date = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(35)",(long)i]];
            }else{
                date = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblGr > tbody > tr:nth-child(%ld) > td:nth-child(36)",(long)i]];
            }
            if (date.textContent == nil) {
                [self.dateArray addObject:@" "];
            }else{
                [self.dateArray addObject:date.textContent];
            }
            
            [self.tableView reloadData];
        }
        
    }
    
    
}





#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.subjectArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cellGraph";
    TableViewCellGraph *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    cell.disLabel.text = [NSString stringWithFormat:@"Дисциплина: %@",self.subjectArray[indexPath.row]];
    NSString *pred =self.teacherArray[indexPath.row];
    
    NSArray* array = [pred componentsSeparatedByString:@"-Лек"];
    pred = [array componentsJoinedByString:@"-Лек\n"];
    array = [pred componentsSeparatedByString:@"-Пр"];
    pred = [array componentsJoinedByString:@"-Пр\n"];
    array = [pred componentsSeparatedByString:@"-Лаб"];
    pred = [array componentsJoinedByString:@"-Лаб\n"];
    array = [pred componentsSeparatedByString:@"(За)"];
    pred = [array componentsJoinedByString:@"(За)"];
    array = [pred componentsSeparatedByString:@"(Эк)"];
    pred = [array componentsJoinedByString:@"(Эк)"];
    
    cell.PredLabel.text = [NSString stringWithFormat:@"Преподаватели: %@",pred];
    cell.typeLabel.text = [NSString stringWithFormat:@"Вид контроля: %@",self.typeArray[indexPath.row]];
    
    NSString *len =self.dateArray[indexPath.row];
    
    if (len.length >10) {
        NSString *date = [self.dateArray[indexPath.row] substringToIndex:10];
        
        NSString *cab = [self.dateArray[indexPath.row] substringFromIndex:10];
        cell.dateLabel.text = [NSString stringWithFormat:@"Дата сдачи: %@",date];
        cell.cabLabel.text = [NSString stringWithFormat:@"Аудитория: %@",cab];
    }else{
        cell.cabLabel.hidden = YES;
        cell.dateLabel.text = [NSString stringWithFormat:@"Дата сдачи: %@",self.dateArray[indexPath.row]];
    }
    
    return cell;
}



@end
