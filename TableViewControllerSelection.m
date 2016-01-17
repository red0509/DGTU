//
//  TableViewControllerSelection.m
//  DGTU
//
//  Created by Anton Pavlov on 17.01.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "TableViewControllerSelection.h"

@interface TableViewControllerSelection ()

@end

@implementation TableViewControllerSelection

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.group;
    [self loadGroupReference];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // [NSString stringWithFormat:@"http://stud.sssu.ru/Dek/Default.aspx%@",self.reference]];}
}


-(void) loadGroupReference{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://stud.sssu.ru/Dek/Default.aspx%@",self.reference]];
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithURL:URL completionHandler:
          ^(NSData *data, NSURLResponse *response, NSError *error) {
              NSString *contentType = nil;
              if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                  NSDictionary *headers = [(NSHTTPURLResponse *)response allHeaderFields];
                  contentType = headers[@"Content-Type"];
              }
            HTMLDocument *home = [HTMLDocument documentWithData:data
                                              contentTypeHeader:contentType];
              
            HTMLElement *refVed = [home firstNodeMatchingSelector:@"#_ctl0_ucLinks_lnkListVed"];
            HTMLElement *refRasp = [home firstNodeMatchingSelector:@"#_ctl0_ucLinks_lnkRasp"];
            HTMLElement *refGraph = [home firstNodeMatchingSelector:@"#_ctl0_ucLinks_lnkGraph"];
              
              NSLog(@"refVed %@",refVed.attributes.allValues.lastObject);
              NSLog(@"refRasp %@",refRasp.attributes.allValues.lastObject);
              NSLog(@"refGraph %@",refGraph.attributes.allValues.lastObject);
              double startTime = CACurrentMediaTime();
              
              NSLog(@"%@ Rstarted", [[NSThread currentThread] name]);
              

                  dispatch_async(dispatch_get_main_queue(), ^{
                      
                      
                      [self.referenceGroup addObject:refRasp.attributes.allValues.lastObject];
                      [self.referenceGroup addObject:refVed.attributes.allValues.lastObject];
                      [self.referenceGroup addObject:refGraph.attributes.allValues.lastObject];
                      NSLog(@"ref %@",self.referenceGroup);

//                          [self.EFfacul addObject:div.textContent];
//                          [self.EFfaculReferences addObject:div.attributes.allValues.lastObject];
//                          [self.tableView reloadData];
                      
                  });
                  
              NSLog(@"%@ Rfinished in %f", [[NSThread currentThread] name], CACurrentMediaTime() - startTime);
        }
          ] resume];
    });
}
#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
