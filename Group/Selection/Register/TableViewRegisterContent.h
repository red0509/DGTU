//
//  TableViewRegisterContent.h
//  DGTU
//
//  Created by Anton Pavlov on 26.01.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewRegisterContent : UITableViewController
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property NSUInteger pageIndex;
@property NSInteger count;
@property NSString *titleText;
@property NSString *referenceContent;
@property (strong,nonatomic) NSString *referenceUniversity;

@end
