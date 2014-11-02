//
//  FlightDetailViewController.h
//  FlyWhizz
//
//  Created by Amy Baldwin on 10/29/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import <Parse/Parse.h>
#import <UIKit/UIKit.h>
#import "FlightModel.h"
#import "SavedFlights.h"

@interface FlightDetailViewController : UIViewController

@property FlightModel *flight;
@property NSDictionary *airports;
@property NSDictionary *airlines;

@end
