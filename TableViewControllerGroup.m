//
//  TableViewControllerGroup.m
//  DGTU
//
//  Created by Anton Pavlov on 27.12.15.
//  Copyright © 2015 Anton Pavlov. All rights reserved.
//

#import "TableViewControllerGroup.h"


@interface TableViewControllerGroup ()

@property (strong,nonatomic) NSMutableArray *EFfacul;
@property (strong,nonatomic) NSMutableArray *EFfaculReferences;


@property (strong,nonatomic) UISearchController *resultSearchController ;

@end

@implementation TableViewControllerGroup



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleName;
    self.searchResult = [NSMutableArray arrayWithCapacity:[self.EFfacul count]];
    self.resultSearchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    self.resultSearchController.searchResultsUpdater = self;
    self.resultSearchController.dimsBackgroundDuringPresentation = NO;
    self.resultSearchController.searchBar.placeholder = @"Поиск";
    self.resultSearchController.searchBar.tintColor = [UIColor whiteColor];
    [self.resultSearchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.resultSearchController.searchBar;
    self.definesPresentationContext = YES;

    [self.tableView reloadData];

    
    
     }

-(void) loadGroup: (NSString*) URLFacul{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
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

#pragma mark - UITableViewDatasource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.resultSearchController.active)
    {
        return [self.searchResult count];
    }
    else
    {
        return [self.EFfacul count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    

    
     if (self.resultSearchController.active)
    {
        cell.textLabel.text = [self.searchResult objectAtIndex:indexPath.row];
    }
    else
    {
        cell.textLabel.text = self.EFfacul[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewControllerSelection *tableViewControllerSelection = [self.storyboard instantiateViewControllerWithIdentifier:@"TableViewControllerSelection"];
    
    if (self.resultSearchController.active)
    {
        tableViewControllerSelection.group = self.searchResult[indexPath.row];
       
        for (int i = 0; i < [self.EFfacul count]; i++) {
            if ([self.EFfacul[i] isEqualToString:self.searchResult[indexPath.row]]) {
                 tableViewControllerSelection.reference = self.EFfaculReferences[i];
            }
        }
    }
    else
    {
        tableViewControllerSelection.group = self.EFfacul[indexPath.row];
        tableViewControllerSelection.reference = self.EFfaculReferences[indexPath.row];

    }
    
    [self.navigationController pushViewController:tableViewControllerSelection animated:YES];
    
    
}


#pragma mark - UISearchResultsUpdating


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
    [self.searchResult removeAllObjects];
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchController.searchBar.text];
    
    self.searchResult = [NSMutableArray arrayWithArray: [self.EFfacul filteredArrayUsingPredicate:resultPredicate]];
    [self.tableView reloadData];
    
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
