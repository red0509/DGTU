//
//  ViewControllerPageContent.h
//  DGTU
//
//  Created by Anton Pavlov on 18.01.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerPageContent : UIViewController


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@property NSUInteger pageIndex;
@property NSString *titleText;

@end
