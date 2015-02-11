//
//  BookmarkViewController.m
//  PlaceSearch
//
//  Created by Braymon Ramirez on 2/11/15.
//  Copyright (c) 2015 Braymon Ramirez. All rights reserved.
//

#import <CoreData+MagicalRecord.h>
#import "BookmarkViewController.h"
#import "Bookmark.h"


@interface BookmarkViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *bookmarks;
@property (nonatomic, weak) IBOutlet UITableView *bookmarkTable;

@end

@implementation BookmarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Bookmarks"];
    [self displayBookmarks];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Initialization
- (NSMutableArray *)bookmarks {
    if (!_bookmarks) _bookmarks = [[NSMutableArray alloc] init];
    return _bookmarks;
}


#pragma mark - Display records
- (void)displayBookmarks {
    self.bookmarks = (NSMutableArray *)[Bookmark MR_findAllSortedBy:@"name" ascending:YES];
//    NSLog(@"Bookmarks: %@", self.bookmarks);
    NSLog(@"Count: %lu", [self.bookmarks count]);
    [self.bookmarkTable reloadData];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"HERE!");
    return [self.bookmarks count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Load Table");
    NSString *identifier = @"BookmarkResults";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    Bookmark *bookmark = [self.bookmarks objectAtIndex:indexPath.row];
    cell.textLabel.text = bookmark.name;
    
    return cell;
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
