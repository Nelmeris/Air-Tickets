//
//  NavigationController.m
//  Air Tickets
//
//  Created by Artem Kufaev on 17/03/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "NavigationController.h"
#import "MainViewController.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self pushViewController:[MainViewController new] animated:false];
    
    // Do any additional setup after loading the view.
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

