//
//  TabBarTeacher.m
//  DGTU
//
//  Created by Anton Pavlov on 09.04.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "TabBarTeacher.h"
#import "DataManager.h"
#import "Favorites+CoreDataProperties.h"
#import <HTMLReader.h>
#import "TableViewControllerClamping.h"
#import "ViewControllerPageTeacher.h"



@interface TabBarTeacher ()

@end

@implementation TabBarTeacher

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add1.png"] style:UIBarButtonItemStylePlain target:self action:@selector(addFavorites)];
    TableViewControllerClamping *clamping = [self.storyboard instantiateViewControllerWithIdentifier:@"TableViewControllerClamping"];
    clamping.reference = self.reference;
    ViewControllerPageTeacher *teacher = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerPageTeacher"];
    teacher.reference = self.reference;
    
    teacher.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Расписание занятий" image:[UIImage imageNamed:@"agenda"] tag:1];
    
    clamping.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Фиксированные занятия" image:[UIImage imageNamed:@"note"] tag:2];
    
    if([self.graph isEqualToString:@"teacher"]){
        self.title = self.name;
        clamping.graph = self.graph;
        clamping.tableTime = self.tableTime;
        teacher.graph = self.graph;
        teacher.tableTime = self.tableTime;
    }else{
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        self.title = self.surname;
    }
    
    [self setViewControllers:@[teacher,clamping]];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) addFavorites{
    

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"ter - %@",self.reference);
        NSURL *URLTeacher = [NSURL URLWithString:self.reference];
        NSError *errorData = nil;
        NSData *dataTeacher = [[NSData alloc]initWithContentsOfURL:URLTeacher options:NSDataReadingUncached error:&errorData];
        
        NSString *contentType = @"text/html; charset=windows-1251";
        

        dispatch_async(dispatch_get_main_queue(), ^{
            if (errorData != nil) {
                NSLog(@"error %@", [errorData localizedDescription]);
                
            } else {
                NSLog(@"Data has loaded successfully.");
                
                HTMLDocument *homeTeacher = [HTMLDocument documentWithData:dataTeacher
                                                      contentTypeHeader:contentType];
                
                DataManager *data = [[DataManager alloc]init];
                Favorites* favorites =
                [NSEntityDescription insertNewObjectForEntityForName:@"Favorites"
                                              inManagedObjectContext:data.managedObjectContext];
                
                NSString *teacher= homeTeacher.serializedFragment;
                favorites.name = self.surname;
                favorites.tableTime = teacher;
                favorites.graph = @"teacher";
                favorites.semester = @"teacher";
                
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

@end
