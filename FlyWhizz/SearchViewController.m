//
//  SearchViewController.m
//  FlyWhizz
//
//  Created by Ben Jisa on 10/27/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import "SearchViewController.h"

@implementation SearchViewController

- (IBAction)searchTypePicker:(id)sender {
    switch (self.searchTypeSelector.selectedSegmentIndex)
    {
        case 0:
            self.carrierInput.placeholder = @"Carrier";
            self.flightNumInput.placeholder = @"Flight Number";
            self.searchType = @"byFlightNum";
            break;
        case 1:
            self.carrierInput.placeholder = @"Origin";
            self.flightNumInput.placeholder = @"Destination";
            self.searchType = @"byOriginDestination";
            break;
        default: 
            break; 
    } 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.carrierInput.placeholder = @"Carrier";
    self.flightNumInput.placeholder = @"Flight Number";
    self.searchType = @"byFlightNum";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
