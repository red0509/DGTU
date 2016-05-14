//
//  TableViewPageContFav.h
//  DGTU
//
//  Created by Anton Pavlov on 15.02.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HTMLReader.h>


@interface TableViewPageContFav : UITableViewController <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *timeTable;
@property (strong,nonatomic) NSNumber *university;
@end
