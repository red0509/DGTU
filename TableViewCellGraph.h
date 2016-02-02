//
//  TableViewCellGraph.h
//  DGTU
//
//  Created by Anton Pavlov on 29.01.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCellGraph : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *disLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *PredLabel;
@property (weak, nonatomic) IBOutlet UILabel *cabLabel;

@end
