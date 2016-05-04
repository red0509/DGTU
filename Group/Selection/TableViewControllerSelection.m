//
//  TableViewControllerSelection.m
//  DGTU
//
//  Created by Anton Pavlov on 17.01.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "TableViewControllerSelection.h"
#import "TableViewControllerRegister.h"
#import "TableViewControllerGraph.h"
#import "DataManager.h"
#import "Favorites+CoreDataProperties.h"



@interface TableViewControllerSelection () 

@property (strong, nonatomic) HTMLDocument* docTime;
@property (strong, nonatomic) HTMLDocument* docGraph;
@property (strong, nonatomic) NSString *docString;
@property BOOL boolRef;
@property NSMutableArray *array;
@end

@implementation TableViewControllerSelection

- (void)viewDidLoad {
    [super viewDidLoad];
    self.docTime = [[HTMLDocument alloc]init];
    self.docGraph = [[HTMLDocument alloc]init];
    self.title = self.group;
    self.numberGroupString = [self.reference substringFromIndex:self.reference.length-5];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add1.png"] style:UIBarButtonItemStylePlain target:self action:@selector(addFavorites)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

-(void) addFavorites{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"M"];
    NSString * strintDate = [dateFormatter stringFromDate:date];
    NSInteger intDate = [strintDate integerValue];
    NSString *semester;
    if (intDate > 8 || intDate == 1) {
        semester =  @"1";
    }else{
        semester = @"2";
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *URLTime = [NSURL URLWithString:[NSString stringWithFormat:@"http://stud.sssu.ru/Rasp/Rasp.aspx?group=%@&sem=%@",self.numberGroupString, semester]];
        NSError *errorData = nil;
        NSData *dataTime = [[NSData alloc]initWithContentsOfURL:URLTime options:NSDataReadingUncached error:&errorData];
        
        NSString *contentType = @"text/html; charset=windows-1251";
        
        NSURL *URLGraph = [NSURL URLWithString:[NSString stringWithFormat:@"http://stud.sssu.ru/Graph/Graph.aspx?group=%@&sem=%@",self.numberGroupString, semester]];
        NSData *dataGraph = [[NSData alloc]initWithContentsOfURL:URLGraph options:NSDataReadingUncached error:&errorData];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (errorData != nil) {
                NSLog(@"error %@", [errorData localizedDescription]);
               
            } else {
                NSLog(@"Data has loaded successfully.");
                
                HTMLDocument *homeTime = [HTMLDocument documentWithData:dataTime
                                                      contentTypeHeader:contentType];
                HTMLDocument *homeTable = [HTMLDocument documentWithData:dataGraph
                                                       contentTypeHeader:contentType];
                
                DataManager *data = [[DataManager alloc]init];
                Favorites* favorites =
                [NSEntityDescription insertNewObjectForEntityForName:@"Favorites"
                                              inManagedObjectContext:data.managedObjectContext];
                
                NSString *graph= homeTable.serializedFragment;
                NSString *time= homeTime.serializedFragment;
                favorites.name = self.group;
                favorites.graph = graph;
                favorites.tableTime = time;
                favorites.semester = semester;
                
                NSError* error = nil;
                if (![data.managedObjectContext save:&error]) {
                    NSLog(@"%@", [error localizedDescription]);
                }
                
                UIAlertController *alert= [UIAlertController alertControllerWithTitle:@"Добавлено в избранное" message:nil preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                        style:UIAlertActionStyleDefault
                                                                      handler:nil];
                [alert addAction:defaultAction];
                
                [self.navigationController presentViewController:alert animated:YES completion:nil];
            }
        });
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0){//Расписание
       ViewControllerPageView *viewControllerPageView = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerPageView"];
        viewControllerPageView.referencePageView = self.numberGroupString;
        [self.navigationController pushViewController:viewControllerPageView animated:YES];
        
    }else if(indexPath.row == 1){//Ведомость
        TableViewControllerRegister *tableViewControllerRegister = [self.storyboard instantiateViewControllerWithIdentifier:@"TableViewControllerRegister"];
        [tableViewControllerRegister loadRegister:[NSString stringWithFormat:@"http://stud.sssu.ru/Ved/Default.aspx?sem=cur&group=%@",self.numberGroupString]];
        
        [self.navigationController pushViewController:tableViewControllerRegister animated:YES];
        
        
    }else if(indexPath.row == 2){//Графики
        
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        
        [dateFormatter setDateFormat:@"M"];
        NSString * strintDate = [dateFormatter stringFromDate:date];
        NSInteger intDate = [strintDate integerValue];
        NSString *semester;
        if (intDate > 8 || intDate == 1) {
            semester =  @"1";
        }else{
            semester = @"2";
        }
        TableViewControllerGraph *tableViewControllerGraph = [self.storyboard instantiateViewControllerWithIdentifier:@"TableViewControllerGraph"];
        [tableViewControllerGraph loadGraph:[NSString stringWithFormat:@"http://stud.sssu.ru/Graph/Graph.aspx?group=%@&sem=%@",self.numberGroupString, semester] sem:semester];
        
        [self.navigationController pushViewController:tableViewControllerGraph animated:YES];
        
    }
}

@end
