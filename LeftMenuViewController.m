//
//  LeftMenuViewController.m
//  DGTU
//
//  Created by Anton Pavlov on 01.03.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "TableViewCellMenu.h"
#import "SlideNavigationContorllerAnimatorFade.h"
#import "SlideNavigationContorllerAnimatorSlide.h"
#import "SlideNavigationContorllerAnimatorScale.h"
#import "SlideNavigationContorllerAnimatorScaleAndFade.h"
#import "SlideNavigationContorllerAnimatorSlideAndFade.h"

#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad

@interface LeftMenuViewController ()

@end

@implementation LeftMenuViewController

#pragma mark - UIViewController Methods -

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.slideOutAnimationEnabled = YES;
    
    return [super initWithCoder:aDecoder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    id <SlideNavigationContorllerAnimator> revealAnimator;
    CGFloat animationDuration = 0;

    self.tableView.separatorColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu.jpg"]];
    self.tableView.backgroundView = imageView;
    

    revealAnimator = [[SlideNavigationContorllerAnimatorSlideAndFade alloc] initWithMaximumFadeAlpha:.8 fadeColor:[UIColor blackColor] andSlideMovement:100];
    animationDuration = .19;
    [SlideNavigationController sharedInstance].menuRevealAnimationDuration = animationDuration;
    [SlideNavigationController sharedInstance].menuRevealAnimator = revealAnimator;
    

    
    if ( IDIOM == IPAD ) {
        [SlideNavigationController sharedInstance].portraitSlideOffset = 500.0;
        NSLog(@"%f",self.tableView.frame.size.height);
//       ViewGetFrame(GetTableView(self)).size.height = 0;
        NSLog(@"ipad");
    } else {
        [SlideNavigationController sharedInstance].portraitSlideOffset = 120.0;
 self.view.autoresizesSubviews = NO;
        [self.tableView setFrame:CGRectMake(0, 0, 50, 50)];
        
        NSLog(@"%f",self.tableView.frame.size.height);
       NSLog(@"iPhone");
    }

}



#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 20)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{static NSString *identifier = @"leftMenuCell";
    TableViewCellMenu *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    switch (indexPath.row)
    {
        case 0:
            cell.labelName.text = @"Группы";
            cell.image.image = [UIImage imageNamed:@"users-2.png"];
            break;
            
        case 1:
            cell.labelName.text = @"Избранное";
            cell.image.image = [UIImage imageNamed:@"star-2.png"];
            break;
            
        case 2:
            cell.labelName.text = @"Кафедры";
            cell.image.image = [UIImage imageNamed:@"tribune-2.png"];
            break;
            
        case 3:
            cell.labelName.text = @"О программе";
            cell.image.image = [UIImage imageNamed:@"information-button-2.png"];
            break;
    }
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
    UIViewController *vc ;
    
    switch (indexPath.row)
    {
        case 0:
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"TableViewControllerFaculties"];
            break;
            
        case 1:
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"TableViewFav"];
            break;
            
        case 2:
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"TableViewControllerDept"];
            break;
            
        case 3:
            NSLog(@"info");
            return;
            break;
    }
    
    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
                                                             withSlideOutAnimation:self.slideOutAnimationEnabled
                                                                     andCompletion:nil];
}



@end
