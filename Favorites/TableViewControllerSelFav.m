//
//  TableViewControllerFav.m
//  DGTU
//
//  Created by Anton Pavlov on 14.02.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "TableViewControllerSelFav.h"
#import "ViewControllerPageFav.h"
#import "TableViewPageContFav.h"
#import "TableViewGraphFav.h"

@interface TableViewControllerSelFav ()

@end

@implementation TableViewControllerSelFav

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row == 0) {

        ViewControllerPageFav *viewControllerPageFav = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerPageFav"];
        viewControllerPageFav.tableTime = self.tableTime;
        [self.navigationController pushViewController:viewControllerPageFav animated:YES];

    }else if (indexPath.row == 1){
        
        TableViewGraphFav *tableViewGraphFav = [self.storyboard instantiateViewControllerWithIdentifier:@"TableViewGraphFav"];
        [tableViewGraphFav loadGraph:self.graph sem:self.semester];
        
        [self.navigationController pushViewController:tableViewGraphFav animated:YES];
        
    }
}






@end
