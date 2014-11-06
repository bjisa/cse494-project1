//
//  ViewController.m
//  mapTest
//
//  Created by tltang1 on 11/2/14.
//  Copyright (c) 2014 tltang1. All rights reserved.
//

#import "TrackViewController.h"
#import <MapKit/MapKit.h>

@interface TrackViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) MKPolyline *flightpath;
@property (nonatomic, strong) MKPolylineView *polylineView;

@end

@implementation TrackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self addFlightPath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) addFlightPath {
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    // API Keys
    NSString *apiAppId = @"2aaf4e79";
    NSString *apiAppKey = @"6aa2d9d9b3dfbd7720e7e1a9cffaaf8d";
    
    BOOL landed = YES;
    
    // Flight data needed; these are used for testing
    if (![self.flightStatus isEqualToString:@"L"]) {
        landed = NO;
    }
    
    
    NSString *apiCall = [NSString stringWithFormat:@"https://api.flightstats.com/flex/flightstatus/rest/v2/json/flight/track/%@?appId=%@&appKey=%@&includeFlightPlan=true&maxPositions=9001", self.flightID, apiAppId, apiAppKey];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:apiCall]];
    
    NSDictionary *flight = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:Nil];
    NSArray *waypoints = flight[@"flightTrack"][@"positions"];
    
    MKMapPoint* mappoints = malloc(sizeof(MKMapPoint) * waypoints.count);
    CLLocationCoordinate2D* pathcoordinates = malloc(sizeof(CLLocationCoordinate2D) * waypoints.count);

    for (int i = 0; i < waypoints.count; i++) {
        pathcoordinates[i] = CLLocationCoordinate2DMake([waypoints[i][@"lat"] doubleValue], [waypoints[i][@"lon"] doubleValue]);
        mappoints[i] = MKMapPointForCoordinate(pathcoordinates[i]);
    }
    
    MKPolyline *flightpath = [MKPolyline polylineWithPoints:mappoints count:waypoints.count];
    self.flightpath = flightpath;
    [self.mapView addOverlay:flightpath];
    
    // Point annotations for airports
    
    NSArray *airports = flight[@"appendix"][@"airports"];
    
    MKPointAnnotation *startAnnotation = [[MKPointAnnotation alloc] init];
    startAnnotation.coordinate = CLLocationCoordinate2DMake([airports[0][@"latitude"] doubleValue], [airports[0][@"longitude"] doubleValue]);
    startAnnotation.title = airports[0][@"city"];
    startAnnotation.subtitle = airports[0][@"name"];
    
    MKPointAnnotation *endAnnotation = [[MKPointAnnotation alloc] init];
    endAnnotation.coordinate = CLLocationCoordinate2DMake([airports[1][@"latitude"] doubleValue], [airports[1][@"longitude"] doubleValue]);
    endAnnotation.title = airports[1][@"city"];
    endAnnotation.subtitle = airports[1][@"name"];
    
    [self.mapView addAnnotation:startAnnotation];
    [self.mapView addAnnotation:endAnnotation];
    
    if (!landed) {
    MKPointAnnotation *currentLocAnnotation = [[MKPointAnnotation alloc] init];
        currentLocAnnotation.coordinate = pathcoordinates[0];
        currentLocAnnotation.title = @"Current Location";
        [self.mapView addAnnotation:currentLocAnnotation];
    }
    
    
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    self.polylineView = [[MKPolylineView alloc] initWithPolyline:self.flightpath];
    self.polylineView.lineWidth = 5;
    self.polylineView.strokeColor = [UIColor blueColor];

    return self.polylineView;
}

@end
