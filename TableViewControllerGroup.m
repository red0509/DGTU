//
//  TableViewControllerGroup.m
//  DGTU
//
//  Created by Anton Pavlov on 27.12.15.
//  Copyright © 2015 Anton Pavlov. All rights reserved.
//

#import "TableViewControllerGroup.h"
#import <HTMLReader.h>

@interface TableViewControllerGroup ()

@property (strong,nonatomic) NSMutableArray *EFfacul;
@property (strong,nonatomic) NSMutableArray *EFfaculReferences;


@end

@implementation TableViewControllerGroup


- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.titleName;
    
    UISearchBar *bar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 414, 40)];
    [self.view addSubview:bar];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void) loadGroup: (NSString*) URLFacul{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSLog(@"%@",[NSThread currentThread].name);
    self.EFfacul= [NSMutableArray array];
    self.EFfaculReferences= [NSMutableArray array];

    NSURL *URL = [NSURL URLWithString:URLFacul];
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
          NSInteger numFacul = 2;

          HTMLElement *div = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#_ctl0_ContentPage_ucGroups_Grid > tbody > tr:nth-child(%ld) > td:nth-child(1) > a",(long)numFacul]];
          double startTime = CACurrentMediaTime();
          
          NSLog(@"%@ started", [[NSThread currentThread] name]);
          
          while (!(div == nil)) {
              
                div = [home firstNodeMatchingSelector:[NSString stringWithFormat:@"#_ctl0_ContentPage_ucGroups_Grid > tbody > tr:nth-child(%ld) > td:nth-child(1) > a",(long)numFacul]];
              
                  NSLog(@"%@",div.textContent);
          
                  dispatch_async(dispatch_get_main_queue(), ^{
                      if (div != nil) {
                          
                  [self.EFfacul addObject:div.textContent];
                  [self.EFfaculReferences addObject:div.attributes.allValues.lastObject];
                  [self.tableView reloadData];
                      }
                });
          
              numFacul++;
              
          }
      
          NSLog(@"%@ finished in %f", [[NSThread currentThread] name], CACurrentMediaTime() - startTime);
          
          }
      ] resume];
    });
    }



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [self.EFfacul count];
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
//    cell.textLabel.text = [self.EFfacul objectAtIndex:indexPath.row];
    cell.textLabel.text = @"1";
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
