//
//  SearchResultsTableViewController.h
//  FlyWhizz
//
//  Created by Ben Jisa on 10/29/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultsTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property NSMutableArray *results;
@property NSMutableArray *flights2;
@property NSString *originCode;
@property NSString *destinationCode;
@property NSString *flightNumber;
@property NSString *carrier;
@property NSString *searchType;
@property NSString *dateSelection;

@end
