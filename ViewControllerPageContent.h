//
//  ViewControllerPageContent.h
//  DGTU
//
//  Created by Anton Pavlov on 18.01.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HTMLReader.h>


@interface ViewControllerPageContent : UITableViewController <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

@property NSUInteger pageIndex;
@property NSString *titleText;
@property (strong,nonatomic) HTMLDocument *document;

@end
