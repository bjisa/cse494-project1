//
//  ViewController.h
//  mapTest
//
//  Created by tltang1 on 11/2/14.
//  Copyright (c) 2014 tltang1. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MapKit;

@interface TrackViewController : UIViewController <MKMapViewDelegate>

@property NSString *flightID;
@property NSString *flightStatus;

@end

