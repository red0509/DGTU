//
//  TableViewControllerGroup.h
//  DGTU
//
//  Created by Anton Pavlov on 27.12.15.
//  Copyright © 2015 Anton Pavlov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewControllerSelection.h"
#import <HTMLReader.h>
#import "SlideNavigationController.h"





@interface TableViewControllerGroup : UITableViewController <UITableViewDataSource ,UISearchResultsUpdating,SlideNavigationControllerDelegate>

-(void) loadGroup: (NSString*) URLFacul;

@property NSString *titleName;

@property (strong, nonatomic) NSMutableArray *searchResult;
@end
