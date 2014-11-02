//
//  FlightDetailViewController.m
//  FlyWhizz
//
//  Created by Amy Baldwin on 10/29/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import "FlightDetailViewController.h"

@interface FlightDetailViewController()
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *flightDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *planeModelLabel;
@property (weak, nonatomic) IBOutlet UILabel *routeLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *originGateLabel;
@property (weak, nonatomic) IBOutlet UILabel *originAirportLabel;
@property (weak, nonatomic) IBOutlet UILabel *originLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *departureTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *destGateLabel;
@property (weak, nonatomic) IBOutlet UILabel *destAirportLabel;
@property (weak, nonatomic) IBOutlet UILabel *destLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrivalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *delayLabel;

@end

@implementation FlightDetailViewController

-(void) viewDidLoad {
    [super viewDidLoad];
    
    self.flightDetailLabel.text = [NSString stringWithFormat:@"%@ %@", self.flight.airline, self.flight.flightNumber];
    NSString *status = @"Status unknown";
    if ([self.flight.status isEqualToString:@"A"]) {
        status = @"Arrived";
    } else if ([self.flight.status isEqualToString:@"L"]) {
        status = @"Landed";
    } else if ([self.flight.status isEqualToString:@"S"]) {
        status = @"Scheduled";
    }
    self.statusLabel.text = status;
    self.routeLabel.text = [NSString stringWithFormat:@"%@ --> %@", self.flight.origin, self.flight.destination];
    
    NSInteger durationMinutes = [self.flight.flightDuration integerValue];
    NSInteger durHours = durationMinutes / 60;
    NSInteger durMin = durationMinutes - (durHours * 60);
    self.durationLabel.text = [NSString stringWithFormat:@"%d hr %d min", (int)durHours, (int)durMin];
    
    self.departureTimeLabel.text = [NSString stringWithFormat:@"%@", self.flight.departureDate];
    self.arrivalTimeLabel.text = [NSString stringWithFormat:@"%@", self.flight.arrivalDate];
    
    NSMutableString *depTerminalGate = [NSMutableString stringWithString:@""];
    if (self.flight.departureTerminal) {
        NSLog(@"Departure terminal exists");
        [depTerminalGate appendString:[NSString stringWithFormat:@"Terminal %@", self.flight.departureTerminal]];
    }
    if (self.flight.departureGate) {
        NSLog(@"Departure gate exists");
        [depTerminalGate appendString:[NSString stringWithFormat:@" Gate %@", self.flight.departureGate]];
    }
    self.destGateLabel.text = depTerminalGate;
    
    NSMutableString *arrTerminalGate = [NSMutableString stringWithString:@""];
    if (self.flight.arrivalTerminal) {
        NSLog(@"Arrival terminal exists");
        [arrTerminalGate appendString:[NSString stringWithFormat:@"Terminal %@", self.flight.arrivalTerminal]];
    }
    if (self.flight.arrivalGate) {
        NSLog(@"Arrival gate exists");
        [arrTerminalGate appendString:[NSString stringWithFormat:@" Gate %@", self.flight.arrivalGate]];
    }
    self.originGateLabel.text = arrTerminalGate;
    
    if (self.flight.iataCode) {
        self.planeModelLabel.text = [NSString stringWithFormat:@"%@", self.flight.iataCode];
    }
    
    self.delayLabel.text = [NSString stringWithFormat:@"%d minutes", self.flight.delay];
}

@end
