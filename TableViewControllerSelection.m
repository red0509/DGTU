//
//  TableViewControllerSelection.m
//  DGTU
//
//  Created by Anton Pavlov on 17.01.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "TableViewControllerSelection.h"

@interface TableViewControllerSelection ()

@end

@implementation TableViewControllerSelection

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.group;
    self.numberGroupString = [self.reference substringFromIndex:self.reference.length-5];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ViewControllerPageView *viewControllerPageView = nil;
    
    
    if(indexPath.row == 0){//Расписание
        viewControllerPageView = [[ViewControllerPageView alloc]init];
        
        [viewControllerPageView loadGroupReference:[NSString stringWithFormat:@"http://stud.sssu.ru/Rasp/Rasp.aspx?group=%@&sem=1",[self numberGroupString]]];
       viewControllerPageView = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerPageView"];
        
    }else if(indexPath.row == 1){//Ведомость
//        [viewControllerPageView loadGroupReference:[NSString stringWithFormat:@"http://stud.sssu.ru/Ved/Default.aspx?sem=cur&group=%@",[self numberGroupString]]];
        
        
    }else if(indexPath.row == 2){//Графики
//        [viewControllerPageView loadGroupReference:[NSString stringWithFormat:@"http://stud.sssu.ru/Graph/Graph.aspx?group=%@&sem=1",[self numberGroupString]]];
        
    }
    
    [self.navigationController pushViewController:viewControllerPageView animated:YES];
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
