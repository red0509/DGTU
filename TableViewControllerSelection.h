//
//  TableViewControllerSelection.h
//  DGTU
//
//  Created by Anton Pavlov on 17.01.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HTMLReader.h>

@interface TableViewControllerSelection : UITableViewController

@property NSString *group;
@property NSString *reference;

@property (strong,nonatomic) NSMutableArray *referenceGroup;

@end
