//
//  TableViewPageContFav.h
//  DGTU
//
//  Created by Anton Pavlov on 15.02.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HTMLReader.h>


@interface TableViewPageContFav : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmented;
@property (strong, nonatomic) IBOutlet UIView *viewSeg;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)ActionSegmented:(id)sender;

@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *timeTable;
@property (strong,nonatomic) NSNumber *university;
@end
