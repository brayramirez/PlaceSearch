//
//  MapDisplayViewController.m
//  PlaceSearch
//
//  Created by Braymon Ramirez on 2/10/15.
//  Copyright (c) 2015 Braymon Ramirez. All rights reserved.
//

#import "MapDisplayViewController.h"
#import <GoogleMaps/GoogleMaps.h>


@interface MapDisplayViewController ()

@end

@implementation MapDisplayViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"Map View"];
    
    [self showMap];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Initialization
// TODO: Set to current location if not yet initialized
//- (NSDictionary *)location {
//    if (!_location) {
//        [_location setValue:<#(id)#> forKeyPath:<#(NSString *)#>
//    }
//    
//    return _location;
//}


#pragma mark - Map
- (void)showMap {
    GMSMapView *mapView;
    
    CLLocationDegrees latitude = [[self.location objectForKey:@"latitude"] doubleValue];
    CLLocationDegrees longitude = [[self.location objectForKey:@"longitude"] doubleValue];
   
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude longitude:longitude zoom:18];
    
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.myLocationEnabled = YES;
    self.view = mapView;
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(latitude, longitude);
    marker.title = self.location[@"name"];
    marker.snippet = self.location[@"vicinity"];
    marker.map = mapView;
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
