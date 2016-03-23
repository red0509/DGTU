//
//  TableViewControllerGraph.m
//  DGTU
//
//  Created by Anton Pavlov on 29.01.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "TableViewControllerGraph.h"
#import "TableViewCellGraph.h"
#import <HTMLReader.h>

@interface TableViewControllerGraph ()

@property (strong,nonatomic) NSMutableArray *subjectArray;
@property (strong,nonatomic) NSMutableArray *typeArray;
@property (strong,nonatomic) NSMutableArray *teacherArray;
@property (strong,nonatomic) NSMutableArray *dateArray;

@end

@implementation TableViewControllerGraph

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



-(void) loadGraph:(NSString*) URLGroup sem:(NSString*) sem{
    
    self.subjectArray = [NSMutableArray array];
    self.typeArray = [NSMutableArray array];
    self.teacherArray = [NSMutableArray array];
    self.dateArray = [NSMutableArray array];
    
    
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
              NSLog(@"respo %@",response);
              HTMLDocument *home = [HTMLDocument documentWithData:data
                                                contentTypeHeader:contentType];
              dispatch_async(dispatch_get_main_queue(), ^{
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
              });
          }
      }
      ] resume];
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
