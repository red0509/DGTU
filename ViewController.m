//
//  ViewController.m
//  DGTU
//
//  Created by Anton Pavlov on 27.12.15.
//  Copyright © 2015 Anton Pavlov. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    self.button.layer.cornerRadius = 75;
    self.button.clipsToBounds = YES;
//    self.button.layer.shadowRadius = 75;
//    self.button.layer.shadowOpacity = 1;
//    self.button.layer.shadowOffset = CGSizeMake(2, 2);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonActionGroup:(id)sender {
}
@end
