//
//  TableViewControllerDept.m
//  DGTU
//
//  Created by Anton Pavlov on 29.02.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "TableViewControllerDept.h"
#import <HTMLReader.h>
#import "TableViewCellDept.h"

@interface TableViewControllerDept ()
@property (strong,nonatomic) NSMutableArray *name;
@property (strong,nonatomic) NSMutableArray *zavDept;
@property (strong,nonatomic) NSMutableArray *number;
@property (strong,nonatomic) NSMutableArray *cab;
@property (strong,nonatomic) NSMutableArray *ref;
@property (nonatomic, strong) NSString *nameSize;


@end

@implementation TableViewControllerDept

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"Кафедры";
    [self loadDept];
    CGSizeMake(100.0f, CGFLOAT_MAX);
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) loadDept{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.name= [NSMutableArray array];
        self.zavDept= [NSMutableArray array];
        self.number= [NSMutableArray array];
        self.cab= [NSMutableArray array];
        self.ref= [NSMutableArray array];
        NSURL *URL = [NSURL URLWithString:@"http://stud.sssu.ru/Dek/Default.aspx?mode=kaf"];
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfig.timeoutIntervalForResource = 7;
        sessionConfig.timeoutIntervalForRequest = 7;
        
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
                  NSInteger numFacul = 2;
                  
                  HTMLElement *div = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#_ctl0_ContentPage_ucKaf_Grid > tbody > tr:nth-child(%ld) > td:nth-child(1) > a",(long)numFacul]];
                  HTMLElement *zav;
                  HTMLElement *num;
                  HTMLElement *cab;
                  
                  double startTime = CACurrentMediaTime();
                  
                  NSLog(@"%@ started", [[NSThread currentThread] name]);
                  
                  while (!(div == nil)) {
                      
                      div = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#_ctl0_ContentPage_ucKaf_Grid > tbody > tr:nth-child(%ld) > td:nth-child(1) > a",(long)numFacul]];
                      
                      zav = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#_ctl0_ContentPage_ucKaf_Grid > tbody > tr:nth-child(%ld) > td:nth-child(3)",(long)numFacul]];
                      num = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#_ctl0_ContentPage_ucKaf_Grid > tbody > tr:nth-child(%ld) > td:nth-child(4)",(long)numFacul]];
                      cab = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#_ctl0_ContentPage_ucKaf_Grid > tbody > tr:nth-child(%ld) > td:nth-child(5)",(long)numFacul]];
                      dispatch_async(dispatch_get_main_queue(), ^{
                          if (div != nil) {
                              
                              [self.name addObject:div.textContent];
                              [self.ref addObject:div.attributes.allValues.firstObject];
                              [self.zavDept addObject:zav.textContent];
                              [self.number addObject:num.textContent];
                              [self.cab addObject:cab.textContent];
                              [self.tableView reloadData];
                          }
                      });
                      
                      numFacul++;
                      
                  }
                  
                  NSLog(@"%@ finished in %f", [[NSThread currentThread] name], CACurrentMediaTime() - startTime);
              }
          }] resume];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.name count];
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    CGSize constraintSize = CGSizeMake(286.0f, CGFLOAT_MAX);
//    UIFont *theFont  = [UIFont systemFontOfSize:14.0f];
//    CGSize theSize;
//    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
//    {
//        CGRect frame = [[self.name objectAtIndex:indexPath.row] boundingRectWithSize:constraintSize options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:theFont} context:nil];
//        theSize = frame.size;
//    }
//    else
//    {
//        theSize = [[self.name objectAtIndex:indexPath.row] sizeWithFont:theFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
//    }
//    
//    return theSize.height;
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cellDept";
    TableViewCellDept *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    cell.labelName.numberOfLines = 0;
    cell.labelZav.numberOfLines = 0;
    [cell.labelName sizeToFit];
    
    cell.labelName.text = self.name[indexPath.row];
    cell.labelZav.text =  [NSString stringWithFormat:@"Зав. Кафедрой: %@",self.zavDept[indexPath.row]];
    cell.labelNum.text = [NSString stringWithFormat:@"Телефон: %@",self.number[indexPath.row]];
    cell.labelCab.text = [NSString stringWithFormat:@"Аудитория: %@",self.cab[indexPath.row]];
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSURL *url = [NSURL URLWithString:self.ref[indexPath.row]];
    
    if (![[UIApplication sharedApplication] openURL:url]) {
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }}

@end
