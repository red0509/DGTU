//
//  TableViewControllerGroup.h
//  DGTU
//
//  Created by Anton Pavlov on 27.12.15.
//  Copyright © 2015 Anton Pavlov. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface TableViewControllerGroup : UITableViewController <UITableViewDataSource , UISearchBarDelegate>

-(void) loadGroup: (NSString*) URLFacul;
@property NSString *titleName;

@end
