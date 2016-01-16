//
//  TableViewControllerFaculties.m
//  DGTU
//
//  Created by Anton Pavlov on 16.01.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "TableViewControllerFaculties.h"

@interface TableViewControllerFaculties ()

@end

@implementation TableViewControllerFaculties

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TableViewControllerGroup *tableViewControllerGroup = nil;
    

    
    if (indexPath.row == 0) {
    tableViewControllerGroup = [[TableViewControllerGroup alloc]init];
    tableViewControllerGroup.titleName = @"ЭФ";
    [tableViewControllerGroup loadGroup:@"http://stud.sssu.ru/Dek/?mode=group&f=facultet&id=7"];
        
    }else if (indexPath.row == 1){
    tableViewControllerGroup = [[TableViewControllerGroup alloc]init];
    tableViewControllerGroup.titleName = @"МРТФ";
    [tableViewControllerGroup loadGroup:@"http://stud.sssu.ru/Dek/?mode=group&f=facultet&id=8"];

    }else if (indexPath.row == 2){
    tableViewControllerGroup = [[TableViewControllerGroup alloc]init];
    tableViewControllerGroup.titleName = @"ФСТ";
    [tableViewControllerGroup loadGroup:@"http://stud.sssu.ru/Dek/?mode=group&f=facultet&id=9"];
        
    }else if (indexPath.row == 3){
    tableViewControllerGroup = [[TableViewControllerGroup alloc]init];
    tableViewControllerGroup.titleName = @"СГФ";
    [tableViewControllerGroup loadGroup:@"http://stud.sssu.ru/Dek/?mode=group&f=facultet&id=10"];
        
    }else if (indexPath.row == 4){
    tableViewControllerGroup = [[TableViewControllerGroup alloc]init];
    tableViewControllerGroup.titleName = @"КЭС";
    [tableViewControllerGroup loadGroup:@"http://stud.sssu.ru/Dek/?mode=group&f=facultet&id=11"];
    }
    
    [self.navigationController pushViewController:tableViewControllerGroup animated:YES];
    
    }

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
