//
//  TableViewControllerSelection.h
//  DGTU
//
//  Created by Anton Pavlov on 17.01.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewControllerPageView.h"
#import <HTMLReader.h>
#import "ViewControllerPageContent.h"




@interface TableViewControllerSelection : UITableViewController 



@property (strong,nonatomic) NSString *group;
@property (strong,nonatomic) NSString *reference;
@property (strong,nonatomic) NSString *numberGroupString;


@end
