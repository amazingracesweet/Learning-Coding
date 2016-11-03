//
//  RootTabViewController.m
//  Learning-Coding
//
//  Created by 肖许 on 2016/11/3.
//  Copyright © 2016年 xiaoxu. All rights reserved.
//

#import "RootTabViewController.h"
#import "BaseNavigationController.h"
#import "Project_RootViewController.h"

#import "RDVTabBarItem.h"

@interface RootTabViewController ()

@end

@implementation RootTabViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setupViewControllers
{
    Project_RootViewController *project = [[Project_RootViewController alloc] init];
    UINavigationController *nav_project = [[BaseNavigationController alloc] initWithRootViewController:project];
    
    BaseViewController *fake1 = [[BaseViewController alloc]init];
    UINavigationController *nav_fake1 = [[BaseNavigationController alloc] initWithRootViewController:fake1];
    
    BaseViewController *fake2 = [[BaseViewController alloc]init];
    UINavigationController *nav_fake2 = [[BaseNavigationController alloc] initWithRootViewController:fake2];
    
    BaseViewController *fake3 = [[BaseViewController alloc]init];
    UINavigationController *nav_fake3 = [[BaseNavigationController alloc] initWithRootViewController:fake3];
    
    BaseViewController *fake4 = [[BaseViewController alloc]init];
    UINavigationController *nav_fake4 = [[BaseNavigationController alloc] initWithRootViewController:fake4];
    
    [self setViewControllers:@[nav_project, nav_fake1, nav_fake2, nav_fake3, nav_fake4]];
    
    [self customizeTabBarForController];
    self.delegate = self;
}

- (void)customizeTabBarForController {
    UIImage *backgroundImage = [UIImage imageWithColor:kColorNavBG];
    NSArray *tabBarItemImages = @[@"project", @"task", @"tweet", @"privatemessage", @"me"];
    NSArray *tabBarItemTitles = @[@"项目", @"任务", @"冒泡", @"消息", @"我"];
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[self tabBar] items]) {
        item.titlePositionAdjustment = UIOffsetMake(0, 3);
        [item setBackgroundSelectedImage:backgroundImage withUnselectedImage:backgroundImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        [item setTitle:[tabBarItemTitles objectAtIndex:index]];
        index++;
    }
    [self.tabBar addLineUp:YES andDown:NO andColor:kColorCCC];
}



@end
