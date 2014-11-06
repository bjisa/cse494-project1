//
//  FlightsViewController.h
//  FlyWhizz
//
//  Created by Ben Jisa on 10/22/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import <Parse/Parse.h>
#import <UIKit/UIKit.h>

@interface FlightsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
- (IBAction)searchFlights:(id)sender;

@end

