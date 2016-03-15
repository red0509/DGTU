//
//  TableViewControllerInfo.m
//  DGTU
//
//  Created by Anton Pavlov on 31.01.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "TableViewControllerInfo.h"
#import <HTMLReader.h>

@interface TableViewControllerInfo ()

@property (strong,nonatomic) NSMutableArray *nameArray;
@property (strong,nonatomic) NSMutableArray *valueArray;

@end

@implementation TableViewControllerInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.referenceInfo = [self.referenceInfo substringFromIndex:self.referenceInfo.length-6];
    [self loadInfo:
     [NSString stringWithFormat:@"http://stud.sssu.ru/Ved/Ved.aspx?id=%@",self.referenceInfo]];
    self.title = @"Информация";
    self.tableView.estimatedRowHeight = 68.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void) loadInfo:(NSString*) URLIngo{
    self.valueArray = [NSMutableArray array];
    self.nameArray = [NSMutableArray array];
    NSURL *URL = [NSURL URLWithString:URLIngo];
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
          HTMLElement *vid = [home firstNodeMatchingSelector:@"#tblTitle > tbody > tr:nth-child(2) > td:nth-child(6)"];
              NSLog(@"vid %@",vid.textContent);
              
          dispatch_async(dispatch_get_main_queue(), ^{
              HTMLElement *info;
        for (NSInteger i = 2; i<7; i++) {
            for (NSInteger j = 1; j<7; j++) {
                if ((i==4)&&(j==1)) {
                    info = [home firstNodeMatchingSelector:@"#ucVedBox_lblSemName"];
                }else if((i==2)&&(j==6)){
                     info = [home firstNodeMatchingSelector:@"#ucVedBox_lblKafName"];
                }
                else{
                    info = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#tblTitle > tbody > tr:nth-child(%ld) > td:nth-child(%ld)",(long)i,(long)j ]];
                }
            
                if (info.textContent == nil) {
                    if (j%2==0) {
                        [self.valueArray addObject:@" "];
                    }else{
                        [self.nameArray addObject:@" "];
                    }
                    
                }else{
                    if (j%2==0) {
                        [self.valueArray addObject:info.textContent];
                    }else{
                        [self.nameArray addObject:info.textContent];
                    }                }
                [self.tableView reloadData];
                
               
            }
            
        }
          });
          }
      }] resume];
}


#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.valueArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *identifier = @"cellInfo";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
   
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                
    }
    
     cell.textLabel.text = [NSString stringWithFormat:@"%@: %@",self.nameArray[indexPath.row],self.valueArray[indexPath.row]];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
