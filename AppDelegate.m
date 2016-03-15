//
//  AppDelegate.m
//  DGTU
//
//  Created by Anton Pavlov on 27.12.15.
//  Copyright © 2015 Anton Pavlov. All rights reserved.
//

#import "AppDelegate.h"





@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
//    application.statusBarStyle = UIStatusBarStyleLightContent;
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.backgroundColor = [UIColor whiteColor];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
    LeftMenuViewController *leftMenu = (LeftMenuViewController*)[mainStoryboard
                                                                 instantiateViewControllerWithIdentifier: @"LeftMenuViewController"];
    
    [SlideNavigationController sharedInstance].leftMenu = leftMenu;
    [SlideNavigationController sharedInstance].menuRevealAnimationDuration = .18;
    
//    DataManager *data = [[DataManager alloc]init];
    
//    Favorites* favorites =
//    [NSEntityDescription insertNewObjectForEntityForName:@"Favorites"
//                                 inManagedObjectContext:data.managedObjectContext];
//    favorites.name= @"1";
//    NSError* error = nil;
//    if (![data.managedObjectContext save:&error]) {
//        NSLog(@"%@", [error localizedDescription]);
//    }
//    NSFetchRequest* request = [[NSFetchRequest alloc] init];
//    
//    NSEntityDescription* description =
//    [NSEntityDescription entityForName:@"Favorites"
//                inManagedObjectContext:data.managedObjectContext];
//    
//    [request setEntity:description];
//    
//    NSError* requestError = nil;
//    NSArray* resultArray = [data.managedObjectContext executeFetchRequest:request error:&requestError];
//  
//    
//
//        for (id object in resultArray) {
////            [data.managedObjectContext deleteObject:object];
////            [data.managedObjectContext save:nil];
//            Favorites *favorites = (Favorites*) object;
//            NSLog(@"NAME: %@ , TABLE:%@ , GRAPH%@",favorites.name ,favorites.tableTime,favorites.graph);
//           
//           }

    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [[DataManager sharedManager] saveContext];
}


@end
