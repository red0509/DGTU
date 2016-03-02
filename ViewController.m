//
//  ViewController.m
//  DGTU
//
//  Created by Anton Pavlov on 27.12.15.
//  Copyright © 2015 Anton Pavlov. All rights reserved.
//

#import "ViewController.h"
#import "TableViewFav.h"
#import "TableViewControllerFaculties.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *logo;

@end

@implementation ViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.button.layer.cornerRadius = 75;
//    self.button.clipsToBounds = YES;
//    self.button.layer.shadowRadius = 75;
//    self.button.layer.shadowOpacity = 1;
//    self.button.layer.shadowOffset = CGSizeMake(2, 2);
//http://www.flaticon.com/free-icon/users_22412#term=group&page=1&position=7
//http://www.flaticon.com/free-icon/tribune_88250#term=tribune&page=1&position=7
//http://www.flaticon.com/free-icon/star_22273#term=favorite&page=1&position=38
// http://www.flaticon.com/free-icon/information-button_22240#term=info&page=1&position=9
    self.title = @" ";
    self.label.backgroundColor = [UIColor colorWithRed:0.48 green:0.75 blue:0.97 alpha:1];
    self.logo.image = [UIImage imageNamed:@"logo.png"];
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)favorites:(id)sender {
    
//    TableViewFav *fav = [[TableViewFav alloc] init];
//    [self.navigationController pushViewController:fav animated:YES];
    
}

@end
