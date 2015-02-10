//
//  ViewController.m
//  PlaceSearch
//
//  Created by Braymon Ramirez on 2/9/15.
//  Copyright (c) 2015 Braymon Ramirez. All rights reserved.
//

#import "ViewController.h"
#import "PlaceListViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)viewDidAppear:(BOOL)animated {
    PlaceListViewController *placeList = [[PlaceListViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:placeList];
    [self presentViewController:nav animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
