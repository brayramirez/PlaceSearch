//
//  ViewController.m
//  PlaceSearch
//
//  Created by Braymon Ramirez on 2/9/15.
//  Copyright (c) 2015 Braymon Ramirez. All rights reserved.
//

#import "ViewController.h"
#import "PlaceListViewController.h"
#import "MapDisplayViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)viewDidAppear:(BOOL)animated {
    PlaceListViewController *rootController = [[PlaceListViewController alloc] init];
//    MapDisplayViewController *rootController = [[MapDisplayViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootController];
    
    [self presentViewController:nav animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
