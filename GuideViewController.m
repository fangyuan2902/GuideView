//
//  GuideViewController.m
//  AllKinds
//
//  Created by 远方 on 2017/6/28.
//  Copyright © 2017年 远方. All rights reserved.
//

#import "GuideViewController.h"
#import "GuideView.h"

@interface GuideViewController ()

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    GuideView *banner = [[GuideView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    banner.images = @[@"1",@"2",@"3",@"4"];
    [self.view addSubview:banner];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
