//
//  SearchViewController.m
//  FlyWhizz
//
//  Created by Ben Jisa on 10/27/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResultsTableViewController.h"

@implementation SearchViewController

- (IBAction)searchTypePicker:(id)sender {
    
    self.input1.text = @"";
    self.input2.text = @"";
    
    switch (self.searchTypeSelector.selectedSegmentIndex)
    {
        case 0:
            self.input1.placeholder = @"Carrier";
            self.input2.placeholder = @"Flight Number";
            self.searchType = @"byFlightNum";
            break;
        case 1:
            self.input1.placeholder = @"Origin";
            self.input2.placeholder = @"Destination";
            self.searchType = @"byOriginDestination";
            break;
        default: 
            break; 
    } 
}

- (IBAction)datePicker:(id)sender {
    switch (self.searchTypeSelector.selectedSegmentIndex)
    {
        case 0:
            self.dateSelection = @"Today";
            break;
        case 1:
            self.dateSelection = @"Tomorrow";
            break;
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.input1.placeholder = @"Carrier";
    self.input2.placeholder = @"Flight Number";
    self.searchType = @"byFlightNum";
    self.dateSelection = @"Today";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SearchResultsTableViewController * dest = segue.destinationViewController;
    
    NSString *inputBox1 = self.input1.text;
    NSString *inputBox2 = self.input2.text;
    
    dest.searchType = self.searchType;
    dest.dateSelection = self.dateSelection;
    
    if ([self.input1.text length] == 0 || [self.input2.text length] == 0) {
        inputBox1 = @"Error";
        inputBox2 = @"Error";
    }
    
    if ([self.searchType isEqualToString:@"byOriginDestination"])
    {
        dest.originCode = inputBox1;
        dest.destinationCode = inputBox2;
    }
    else // Search by Flight Number
    {
        dest.flightNumber = inputBox2;
        dest.carrier = inputBox1;
    }
    
}

@end
