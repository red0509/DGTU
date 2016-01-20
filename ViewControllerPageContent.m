//
//  ViewControllerPageContent.m
//  DGTU
//
//  Created by Anton Pavlov on 18.01.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "ViewControllerPageContent.h"

@interface ViewControllerPageContent ()
@property NSArray *array;

@end

@implementation ViewControllerPageContent

- (void)viewDidLoad {
    [super viewDidLoad];
    self.array = @[@"0",@"",@"2"];
    self.labelTitle.text = self.titleText;
//    tableViewContent.forever=self.titleText;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
//    cell.textLabel.text = self.titleText;
    
    if (self.pageIndex == 0) {
        cell.textLabel.text = self.array[self.pageIndex];
    }else if (self.pageIndex == 1) {
        cell.textLabel.text = self.array[self.pageIndex];
    }else if (self.pageIndex == 2) {
        cell.textLabel.text = self.array[self.pageIndex];
    }
    return cell;

}


@end
