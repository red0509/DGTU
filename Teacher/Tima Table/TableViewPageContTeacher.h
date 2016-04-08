//
//  TableViewPageContTeacher.h
//  DGTU
//
//  Created by Anton Pavlov on 25.03.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HTMLReader.h>


@interface TableViewPageContTeacher : UITableViewController <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *timeTable;

@end
