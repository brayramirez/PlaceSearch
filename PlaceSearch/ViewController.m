//
//  ViewController.m
//  PlaceSearch
//
//  Created by Braymon Ramirez on 2/9/15.
//  Copyright (c) 2015 Braymon Ramirez. All rights reserved.
//

#import "ViewController.h"
#import "PlaceListViewController.h"
#import "BookmarkViewController.h"
#import "MapDisplayViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)viewDidAppear:(BOOL)animated {
//    PlaceListViewController *rootController = [[PlaceListViewController alloc] init];
//    MapDisplayViewController *rootController = [[MapDisplayViewController alloc] init];
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    PlaceListViewController *placeListViewController = [[PlaceListViewController alloc] init];
    placeListViewController.title = @"Search";
    placeListViewController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:0];
    
    BookmarkViewController *bookmarkViewController = [[BookmarkViewController alloc] init];
    bookmarkViewController.title = @"Bookmarks";
    bookmarkViewController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:1];
    
    MapDisplayViewController *mapDisplayViewController = [[MapDisplayViewController alloc] init];
    mapDisplayViewController.title = @"Map";
    mapDisplayViewController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:2];
    
    [tabBarController setViewControllers:@[placeListViewController, bookmarkViewController, mapDisplayViewController]];
    [tabBarController setSelectedIndex:0];
    
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootController];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tabBarController];
    
    [self presentViewController:nav animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
