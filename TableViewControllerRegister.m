//
//  TableViewControllerRegister.m
//  DGTU
//
//  Created by Anton Pavlov on 26.01.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "TableViewControllerRegister.h"

@interface TableViewControllerRegister ()

@property (strong,nonatomic) NSMutableArray *subjectArray;
@property (strong,nonatomic) NSMutableArray *typeArray;
@property (strong,nonatomic) NSMutableArray *closedArray;
@property (strong,nonatomic) NSMutableArray *registerReferences;

@end

@implementation TableViewControllerRegister

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Дисциплины";
    [self.tableView reloadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void) loadRegister: (NSString*) URLFacul{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.subjectArray = [NSMutableArray array];
        self.typeArray = [NSMutableArray array];
        self.closedArray = [NSMutableArray array];
        self.registerReferences = [NSMutableArray array];
        
        NSURL *URL = [NSURL URLWithString:URLFacul];
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
                  NSInteger section = 2;
                  
//                  #_ctl0_ContentPage_ucListVedBox_Grid > tbody > tr:nth-child(2) > td:nth-child(1) > a
//                  #_ctl0_ContentPage_ucListVedBox_Grid > tbody > tr:nth-child(2) > td:nth-child(2)
//                  #_ctl0_ContentPage_ucListVedBox_Grid > tbody > tr:nth-child(2) > td:nth-child(3)
//                  #_ctl0_ContentPage_ucListVedBox_Grid > tbody > tr:nth-child(3) > td:nth-child(1) > a
                HTMLElement *subject = [home firstNodeMatchingSelector:
                                    [NSString stringWithFormat:@"#_ctl0_ContentPage_ucListVedBox_Grid > tbody > tr:nth-child(%ld) > td:nth-child(1) > a",(long)section]];
                HTMLElement *type;
                HTMLElement *closed;
                  
                  while (subject != nil) {
                  
                      
                      subject = [home firstNodeMatchingSelector:
                                 [NSString stringWithFormat:@"#_ctl0_ContentPage_ucListVedBox_Grid > tbody > tr:nth-child(%ld) > td:nth-child(1) > a",(long)section]];
                      type = [home firstNodeMatchingSelector:
                              [NSString stringWithFormat:@"#_ctl0_ContentPage_ucListVedBox_Grid > tbody > tr:nth-child(%ld) > td:nth-child(2)",(long)section]];
                      closed = [home firstNodeMatchingSelector:
                      [NSString stringWithFormat:@"#_ctl0_ContentPage_ucListVedBox_Grid > tbody > tr:nth-child(%ld) > td:nth-child(3)",(long)section]];
                      
                      
                      dispatch_async(dispatch_get_main_queue(), ^{
                          if (subject != nil) {
                              
                              [self.subjectArray addObject:subject.textContent];
                              [self.registerReferences addObject:subject.attributes.allValues.lastObject];
                              [self.typeArray addObject:type.textContent];
                              [self.closedArray addObject:closed.textContent];
                              [self.tableView reloadData];
                          }
                      });
                      
                      section++;
                      
                  }
              }
          }] resume];
    });
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.subjectArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.lineBreakMode = 2;
    cell.textLabel.text = self.subjectArray[indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Тип ведомости: %@      Закрыта: %@",self.typeArray[indexPath.row],self.closedArray[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *type = [NSString stringWithFormat:@"%@",self.typeArray[indexPath.row]];
    ViewRegisterPageView *viewRegisterPageView = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewRegisterPageView"];
    
    viewRegisterPageView.pageTitles = @[@"Контрольная точка 1", @"Контрольная точка 2",type];
        viewRegisterPageView.referencePageView = self.registerReferences[indexPath.row];
    
    
    
    [self.navigationController pushViewController:viewRegisterPageView animated:YES];
    

    
    
}


@end