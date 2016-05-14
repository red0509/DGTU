//
//  TableViewRegisterContent.m
//  DGTU
//
//  Created by Anton Pavlov on 26.01.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "TableViewRegisterContent.h"
#import <HTMLReader.h>
#import "TableViewCellRegister.h"

@interface TableViewRegisterContent ()

@property (strong,nonatomic) NSMutableArray *nameArray;
@property (strong,nonatomic) NSMutableArray *lecArray;
@property (strong,nonatomic) NSMutableArray *praArray;
@property (strong,nonatomic) NSMutableArray *labArray;
@property (strong,nonatomic) NSMutableArray *drArray;
@property (strong,nonatomic) NSMutableArray *totalArray;
@property (strong,nonatomic) NSMutableArray *examArray;
@property (strong,nonatomic) NSMutableArray *examNumArray;
@property (strong,nonatomic) NSMutableArray *projectNameArray;
@property (strong,nonatomic) NSMutableArray *projectExamArray;
@end

@implementation TableViewRegisterContent

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = self.titleText;
    
    
    if (self.pageIndex == 0) {
        [self loadReference:
         [NSString stringWithFormat:@"http://stud.sssu.ru/Ved/Ved.aspx?id=%@",self.referenceContent] KT:YES];
    }else if (self.pageIndex == 1){
        [self loadReference:
         [NSString stringWithFormat:@"http://stud.sssu.ru/Ved/Ved.aspx?id=%@",self.referenceContent] KT:NO];
    }else if (self.pageIndex == 2){
        [self loadReference:
         [NSString stringWithFormat:@"http://stud.sssu.ru/Ved/Ved.aspx?id=%@",self.referenceContent] KT:NO];
    }else if (self.pageIndex == 3){
        [self loadReference:
         [NSString stringWithFormat:@"http://stud.sssu.ru/Ved/Ved.aspx?id=%@",self.referenceContent] KT:NO];
    }else if (self.pageIndex ==  4){
        [self loadReference:
         [NSString stringWithFormat:@"http://stud.sssu.ru/Ved/Ved.aspx?id=%@",self.referenceContent] KT:NO];
    }
    
    self.tableView.estimatedRowHeight = 68.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) loadReference:(NSString*) URLGroup KT:(BOOL)KTbool{
    self.nameArray = [NSMutableArray array];
    self.lecArray = [NSMutableArray array];
    self.praArray = [NSMutableArray array];
    self.labArray = [NSMutableArray array];
    self.drArray = [NSMutableArray array];
    self.totalArray = [NSMutableArray array];
    self.examArray = [NSMutableArray array];
    self.examNumArray = [NSMutableArray array];
    self.projectNameArray = [NSMutableArray array];
    self.projectExamArray = [NSMutableArray array];
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
                  
                  NSInteger nameNum = 5;
                  
                  HTMLElement *name;
                  
                  while (YES) {
                      
                      name = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ucVedBox_tblVed > tbody > tr:nth-child(%ld) > td:nth-child(3)",(long)nameNum]];
                      
                      if (name != nil) {
                          [self.nameArray addObject:name.textContent];
                      }else{
                          break;
                      }
                      
                      nameNum++;
                  }
                  nameNum -=5;
                  
                  HTMLElement *projectName;
                  HTMLElement *projectExam;
                  
                  
                  if (self.pageIndex == 3) {
                      for (NSInteger i = 5; i<nameNum+5; i++) {
                          
                          projectName = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ucVedBox_tblVed > tbody > tr:nth-child(%ld) > td:nth-child(5)",(long)i]];
                          if (projectName == nil) {
                              [self.projectExamArray addObject:@" "];
                          }else{
                              [self.projectExamArray addObject:projectName.textContent];
                          }
                          
                      }
                  }
                  
                  if (self.pageIndex == 4) {
                      for (NSInteger i = 5; i<nameNum+5; i++) {
                          
                          projectName = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ucVedBox_tblVed > tbody > tr:nth-child(%ld) > td:nth-child(13)",(long)i]];
                          if (projectName == nil) {
                              [self.projectNameArray addObject:@" "];
                          }else{
                              [self.projectNameArray addObject:projectName.textContent];
                          }
                          projectExam = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ucVedBox_tblVed > tbody > tr:nth-child(%ld) > td:nth-child(5)",(long)i]];
                          if (projectExam == nil) {
                              [self.projectExamArray addObject:@" "];
                          }else{
                              [self.projectExamArray addObject:projectExam.textContent];
                          }
                          
                      }
                  }
                  
                  
                  HTMLElement *pred;
                  
                  if (KTbool == YES) {
                      for (NSInteger i = 5; i<nameNum+5; i++) {
                          
                          pred = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ucVedBox_tblVed > tbody > tr:nth-child(%ld) > td:nth-child(4)",(long)i]];
                          if (pred == nil) {
                              [self.lecArray addObject:@" "];
                          }else{
                              [self.lecArray addObject:pred.textContent];
                          }
                          
                          pred = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ucVedBox_tblVed > tbody > tr:nth-child(%ld) > td:nth-child(5)",(long)i]];
                          if (pred == nil) {
                              [self.praArray addObject:@" "];
                          }else{
                              [self.praArray addObject:pred.textContent];
                          }
                          
                          pred = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ucVedBox_tblVed > tbody > tr:nth-child(%ld) > td:nth-child(6)",(long)i]];
                          if (pred == nil) {
                              [self.labArray addObject:@" "];
                          }else{
                              [self.labArray addObject:pred.textContent];
                          }
                          
                          pred = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ucVedBox_tblVed > tbody > tr:nth-child(%ld) > td:nth-child(7)",(long)i]];
                          if (pred == nil) {
                              [self.drArray addObject:@" "];
                          }else{
                              [self.drArray addObject:pred.textContent];
                          }
                          
                          pred = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ucVedBox_tblVed > tbody > tr:nth-child(%ld) > td:nth-child(8)",(long)i]];
                          if (pred == nil) {
                              [self.totalArray addObject:@" "];
                          }else{
                              [self.totalArray addObject:pred.textContent];
                          }
                          
                          [self.tableView reloadData];
                      }
                      
                  }else{
                      for (NSInteger i = 5; i<nameNum+5; i++) {
                          
                          pred = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ucVedBox_tblVed > tbody > tr:nth-child(%ld) > td:nth-child(9)",(long)i]];
                          if (pred == nil) {
                              [self.lecArray addObject:@" "];
                          }else{
                              [self.lecArray addObject:pred.textContent];
                          }
                          
                          pred = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ucVedBox_tblVed > tbody > tr:nth-child(%ld) > td:nth-child(10)",(long)i]];
                          if (pred == nil) {
                              [self.praArray addObject:@" "];
                          }else{
                              [self.praArray addObject:pred.textContent];
                          }
                          
                          pred = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ucVedBox_tblVed > tbody > tr:nth-child(%ld) > td:nth-child(11)",(long)i]];
                          if (pred == nil) {
                              [self.labArray addObject:@" "];
                          }else{
                              [self.labArray addObject:pred.textContent];
                          }
                          
                          pred = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ucVedBox_tblVed > tbody > tr:nth-child(%ld) > td:nth-child(12)",(long)i]];
                          if (pred == nil) {
                              [self.drArray addObject:@" "];
                          }else{
                              [self.drArray addObject:pred.textContent];
                          }
                          
                          pred = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ucVedBox_tblVed > tbody > tr:nth-child(%ld) > td:nth-child(13)",(long)i]];
                          if (pred == nil) {
                              [self.totalArray addObject:@" "];
                          }else{
                              [self.totalArray addObject:pred.textContent];
                          }
                          
                          [self.tableView reloadData];
                          
                      }
                      
                  }
                  HTMLElement *examNum;
                  HTMLElement *exam;
                  
                  for (NSInteger i = 5; i<nameNum+5; i++) {
                      
                      examNum = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ucVedBox_tblVed > tbody > tr:nth-child(%ld) > td:nth-child(15)",(long)i]];
                      
                      if (examNum == nil) {
                          [self.examNumArray addObject:@" "];
                      }else{
                          [self.examNumArray addObject:examNum.textContent];
                      }
                      
                      exam = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ucVedBox_tblVed > tbody > tr:nth-child(%ld) > td:nth-child(18)",(long)i]];
                      
                      if (exam == nil) {
                          [self.examArray addObject:@" "];
                      }else if (([exam.textContent isEqualToString:@"Н/я"])||([exam.textContent isEqualToString:@"Незачет"])||([exam.textContent isEqualToString:@"Неуд"])){
                          exam = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#ucVedBox_tblVed > tbody > tr:nth-child(%ld) > td:nth-child(21)",(long)i]];
                          
                          if (exam == nil) {
                              [self.examArray addObject:@" "];
                          }else{
                              [self.examArray addObject:exam.textContent];
                          }
                          
                          
                      }
                      else{
                          [self.examArray addObject:exam.textContent];
                      }
                      
                      [self.tableView reloadData];
                  }
                  
              });
              
          }
      }] resume];
}



#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (self.pageIndex == 2) {
        return 0;
        
    }else if (self.pageIndex == 3) {
        return 0;
        
    }else if (self.pageIndex == 4) {
        return 0;
        
    }else{
        return 30;
        
    }
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:
                                 CGRectMake(0, 0, tableView.frame.size.width, 20)];
    sectionHeaderView.backgroundColor = [UIColor colorWithRed:100.0f/255.0f green:181.0f/255.0f blue:246.0f/255.0f alpha:1.0f];
    UILabel *lec = [[UILabel alloc] initWithFrame:
                    CGRectMake(130, 10, 50, 15)];
    UILabel *pra = [[UILabel alloc] initWithFrame:
                    CGRectMake(180, 10, 50, 15)];
    UILabel *lab = [[UILabel alloc] initWithFrame:
                    CGRectMake(230, 10, 50, 15)];
    UILabel *dr = [[UILabel alloc] initWithFrame:
                   CGRectMake(280, 10, 50, 15)];
    
    
    lec.textColor = [UIColor whiteColor];
    lec.backgroundColor = [UIColor clearColor];
    lec.textAlignment = NSTextAlignmentLeft;
    [lec setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
    
    pra.textColor = [UIColor whiteColor];
    pra.backgroundColor = [UIColor clearColor];
    pra.textAlignment = NSTextAlignmentLeft;
    [pra setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
    
    lab.textColor = [UIColor whiteColor];
    lab.backgroundColor = [UIColor clearColor];
    lab.textAlignment = NSTextAlignmentLeft;
    [lab setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
    
    dr.textColor = [UIColor whiteColor];
    dr.backgroundColor = [UIColor clearColor];
    dr.textAlignment = NSTextAlignmentLeft;
    [dr setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
    
    [sectionHeaderView addSubview:lec];
    [sectionHeaderView addSubview:pra];
    [sectionHeaderView addSubview:lab];
    [sectionHeaderView addSubview:dr];
    
    lec.text = @"Лек.";
    pra.text = @"Пр.";
    lab.text = @"Лаб.";
    dr.text = @"Др.";
    
    return sectionHeaderView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.nameArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = nil;
    TableViewCellRegister *cell = nil;
    
    
    if (self.pageIndex == 0) {
        identifier = @"cellRegister";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.nameLabel.text = self.nameArray[indexPath.row];
        cell.lecLabel.text = self.lecArray[indexPath.row];
        cell.praLabel.text = self.praArray[indexPath.row];
        cell.labLabel.text = self.labArray[indexPath.row];
        cell.drLabel.text = self.drArray[indexPath.row];
        cell.totalLabel.text = self.totalArray[indexPath.row];
        cell.totalLabel.text = [NSString stringWithFormat:@"Итог по КТ 1: %@" ,self.totalArray[indexPath.row]];
        
    }else if (self.pageIndex == 1) {
        identifier = @"cellRegister";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.nameLabel.text = self.nameArray[indexPath.row];
        cell.lecLabel.text = self.lecArray[indexPath.row];
        cell.praLabel.text = self.praArray[indexPath.row];
        cell.labLabel.text = self.labArray[indexPath.row];
        cell.drLabel.text = self.drArray[indexPath.row];
        cell.totalLabel.text = self.totalArray[indexPath.row];
        cell.totalLabel.text = [NSString stringWithFormat:@"Итог по КТ 2: %@" ,self.totalArray[indexPath.row]];
        
    }else if(self.pageIndex == 2){
        identifier = @"cellExam";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.nameLabel.text = self.nameArray[indexPath.row];
        cell.examNumLabel.text =  [NSString stringWithFormat:@"Итоговый Рейтинг: %@",self.examNumArray[indexPath.row]];
        cell.examLabel.text =  [NSString stringWithFormat:@"Итог: %@",self.examArray[indexPath.row]];
    }else if(self.pageIndex == 3){
        identifier = @"cellPra";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.NamePra.text = self.nameArray[indexPath.row];
        cell.numPra.text =[NSString stringWithFormat:@"Оценка: %@",self.projectExamArray[indexPath.row]];
        
    }else if(self.pageIndex == 4){
        identifier = @"cellProject";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.projectNameLabel.text = self.nameArray[indexPath.row];
        cell.projectNumLabel.text =[NSString stringWithFormat:@"Оценка: %@",self.projectExamArray[indexPath.row]];
        cell.project.text =[NSString stringWithFormat:@"Тема: %@",self.projectNameArray[indexPath.row]];
        
    }
    
    
    
    
    
    return cell;
}



@end
