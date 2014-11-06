//
//  SelectAircraftViewController.m
//  PlaneDetails
//
//  Created by Joshua Baldwin on 11/1/14.
//  Copyright (c) 2014 Joshua Baldwin. All rights reserved.
//

#import "SelectAircraftViewController.h"
#import "AircraftDetailsViewController.h"

@interface SelectAircraftViewController ()

@property NSArray *aircraft;
@property NSString *selectedAircraft;

@end


@implementation SelectAircraftViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Extract the aircraft list from the PList
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"AircraftList" ofType:@"plist"];
    self.aircraft = [[NSArray alloc] initWithArray:[NSArray arrayWithContentsOfFile:filepath]];
    self.selectedAircraft = @"NONE";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Return the # of columns in the picker
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


// Return the number of rrows in a specific component
- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.aircraft.count;
}


// Specify the title for each row
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    self.selectedAircraft = [self.aircraft objectAtIndex:row];
    return self.selectedAircraft;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    AircraftDetailsViewController *destination = segue.destinationViewController;
    destination.aircraftName = self.selectedAircraft;
    destination.nameNeedsProcessing = NO;
}

@end
