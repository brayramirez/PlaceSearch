//
//  BookmarkViewController.m
//  PlaceSearch
//
//  Created by Braymon Ramirez on 2/11/15.
//  Copyright (c) 2015 Braymon Ramirez. All rights reserved.
//

#import <CoreData+MagicalRecord.h>
#import "BookmarkViewController.h"
#import "MapDisplayViewController.h"
#import "Bookmark.h"


@interface BookmarkViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *bookmarks;
@property (nonatomic, weak) IBOutlet UITableView *bookmarkTable;

@end

@implementation BookmarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [self setTitle:@"Bookmarks"];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [self displayBookmarks];
    self.bookmarkTable.allowsMultipleSelectionDuringEditing = NO;
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
    self.bookmarks = (NSMutableArray *)[[Bookmark MR_findAllSortedBy:@"name" ascending:YES] mutableCopy];
    [self.bookmarkTable reloadData];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.bookmarks count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"BookmarkResults";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    Bookmark *bookmark = [self.bookmarks objectAtIndex:indexPath.row];
    cell.textLabel.text = bookmark.name;
    
    [self setTapGesture:cell];
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
        
        Bookmark *bookmark = [self.bookmarks objectAtIndex:indexPath.row];
        [bookmark MR_deleteInContext:context];
        [context MR_saveToPersistentStoreAndWait];
        
        [self.bookmarks removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


#pragma mark - Gestures
- (void)setTapGesture:(UITableViewCell *)cell {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGestureRecognizer.delegate = self;
    [cell addGestureRecognizer:tapGestureRecognizer];
}


- (IBAction)handleTapGesture:(UITapGestureRecognizer *)recognizer {
    NSIndexPath *indexPath = [self.bookmarkTable indexPathForCell:(UITableViewCell *)recognizer.view];
    Bookmark *bookmark = [self.bookmarks objectAtIndex:indexPath.row];
    NSMutableDictionary *location = [[NSMutableDictionary alloc] init];
    
    [location setObject:bookmark.name forKey:@"name"];
    [location setObject:bookmark.vicinity forKey:@"vicinity"];
    [location setObject:bookmark.latitude forKey:@"latitude"];
    [location setObject:bookmark.longitude forKey:@"longitude"];
    
    MapDisplayViewController *mapDisplayViewController = [[MapDisplayViewController alloc] init];
    [mapDisplayViewController setLocation:location];
    [self.navigationController pushViewController:mapDisplayViewController animated:YES];
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
