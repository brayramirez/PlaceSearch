//
//  PlaceListViewController.m
//  PlaceSearch
//
//  Created by Braymon Ramirez on 2/9/15.
//  Copyright (c) 2015 Braymon Ramirez. All rights reserved.
//

#import <AFNetworking.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreData+MagicalRecord.h>
#import "PlaceListViewController.h"
#import "MapDisplayViewController.h"
#import "BookmarkViewController.h"
#import "Bookmark.h"


@interface PlaceListViewController () <CLLocationManagerDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableDictionary *currentLocation;
@property (nonatomic, strong) NSMutableArray *places;
@property (nonatomic, strong) NSString *apiKey;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UITableView *placesTable;

@end

@implementation PlaceListViewController

static const NSString *BASE_URL = @"https://maps.googleapis.com/maps/api/place/nearbysearch/json?";


- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
//    [self setNavigationItems];
    [self.tabBarController.navigationItem setTitle:@"Search"];
    
    [self.searchBar becomeFirstResponder];
    self.placesTable.allowsMultipleSelectionDuringEditing = NO;
    
    [self updateLocation];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Instantiation
- (CLLocationManager *)locationManager {
    if (!_locationManager) _locationManager = [[CLLocationManager alloc] init];
    return _locationManager;
}


- (NSMutableDictionary *)currentLocation {
    if (!_currentLocation) _currentLocation = [[NSMutableDictionary alloc] init];
    return _currentLocation;
}


- (NSMutableArray *)places {
    if (!_places) _places = [[NSMutableArray alloc] init];
    return _places;
}


- (NSString *)apiKey {
    if (!_apiKey) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"keys" ofType:@"plist"];
        NSDictionary *keys = [[NSDictionary alloc] initWithContentsOfFile:path];
        _apiKey = keys[@"Google API Key"];
    }
    return _apiKey;
}


#pragma mark - Navigation
- (void)setNavigationItems {
//    [self setTitle:@"Place Search"];
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
//    UIBarButtonItem *bookmarkButton = [[UIBarButtonItem alloc] initWithTitle:@"Bookmarks" style:UIBarButtonItemStylePlain target:nil action:@selector(visitBookmarks)];
//    self.navigationItem.rightBarButtonItem = bookmarkButton;
}


- (void)visitBookmarks {
    BookmarkViewController *bookmarkViewController = [[BookmarkViewController alloc] init];
    [self.navigationController pushViewController:bookmarkViewController animated:YES];
}


#pragma mark - Location
- (void)updateLocation {
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 500;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
};


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Determining Location"
                                                       message:@"Failed to get current location"
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
    [alertView show];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"Updating Location: %@", [locations lastObject]);
    CLLocation *updatedLocation = [locations lastObject];
    
    [self.currentLocation setObject:[NSNumber numberWithDouble:updatedLocation.coordinate.longitude] forKey:@"longitude"];
    [self.currentLocation setObject:[NSNumber numberWithDouble:updatedLocation.coordinate.latitude] forKey:@"latitude"];
}


#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Button Clicked");
    NSLog(@"value: %@", searchBar.text);
    [self searchPlace:[searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText isEqualToString:@""]) {
        [self.places removeAllObjects];
        [self.placesTable reloadData];
    }
}


#pragma mark - Search Places
- (void)searchPlace:(NSString *)query {
    query = [NSString stringWithFormat:@"&keyword=%@", query];
    NSString *locationQuery = [NSString stringWithFormat:@"location=%@,%@&radius=300", self.currentLocation[@"latitude"], self.currentLocation[@"longitude"]];
    NSString *queryString = [NSString stringWithFormat:@"%@%@%@&key=%@", BASE_URL, locationQuery, query, self.apiKey];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:queryString]];

//    NSLog(@"query: %@", queryString);
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *response = (NSMutableDictionary *)responseObject;
        self.places = (NSMutableArray *)[response[@"results"] mutableCopy];

//        NSLog(@"Place search success!");
//        NSLog(@"Results: %@", self.places);
        
        [self.placesTable reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showAlertWithTitle:@"Error Searching Places" withMessage:[error localizedDescription]];
    }];
    
    [operation start];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.places count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"Results";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    NSDictionary *data = [self.places objectAtIndex:indexPath.row];
    cell.textLabel.text = data[@"name"];
    
    [self setTapGesture:cell];
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *bookmarkAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                              title:@"Bookmark"
                                                                            handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
                                                                                [self createBookmark:[self.places objectAtIndex:indexPath.row]];
                                                                                [tableView setEditing:NO animated:YES];
                                                                            }];
    
    return @[bookmarkAction];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView reloadData];
}


#pragma mark - Create Bookmark
- (void)createBookmark:(NSDictionary *)data {
//    NSLog(@"Data: %@", data);

    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    
    Bookmark *bookmark = [Bookmark MR_createInContext:context];
    bookmark.name = data[@"name"];
    bookmark.vicinity = data[@"vicinity"];
    bookmark.latitude = [[[data objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"];
    bookmark.longitude = [[[data objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"];
    
    [context MR_saveOnlySelfAndWait];
    
    [self showAlertWithTitle:@"Bookmark" withMessage:@"Bookmark has been saved."];
}


#pragma mark - Gestures
- (void)setTapGesture:(UITableViewCell *)cell {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGestureRecognizer.delegate = self;
    [cell addGestureRecognizer:tapGestureRecognizer];
}


- (IBAction)handleTapGesture:(UITapGestureRecognizer *)recognizer {
    NSIndexPath *indexPath = [self.placesTable indexPathForCell:(UITableViewCell *)recognizer.view];
    NSDictionary *data = [self.places objectAtIndex:indexPath.row];
    NSMutableDictionary *location = [[NSMutableDictionary alloc] init];
    
    [location setObject:[data objectForKey:@"name"] forKey:@"name"];
    [location setObject:[data objectForKey:@"vicinity"] forKey:@"vicinity"];
    [location setObject:[[[data objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"] forKey:@"latitude"];
    [location setObject:[[[data objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"] forKey:@"longitude"];
    
    NSLog(@"Location: %@", location);
    
    MapDisplayViewController *mapDisplayViewController = [[MapDisplayViewController alloc] init];
    [mapDisplayViewController setLocation:location];
    [self.navigationController pushViewController:mapDisplayViewController animated:YES];
}


#pragma mark - Alert Method
- (void)showAlertWithTitle:(NSString *)title withMessage:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
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
