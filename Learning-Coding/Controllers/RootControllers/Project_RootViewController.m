//
//  Project_RootViewController.m
//  Learning-Coding
//
//  Created by 肖许 on 2016/11/3.
//  Copyright © 2016年 xiaoxu. All rights reserved.
//

#import "Project_RootViewController.h"
#import "PhotoViewController.h"

@interface Project_RootViewController ()

@end

@implementation Project_RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubview];
}

-(void)setupSubview
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake((kScreen_Width - 100)/2, 200, 100, 30)];
    [button setTitle:@"图片" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(presentPhotoOld) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)presentPhotoOld
{
    PhotoViewController *photoViewController = [[PhotoViewController alloc]init];
    [self presentViewController:photoViewController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
