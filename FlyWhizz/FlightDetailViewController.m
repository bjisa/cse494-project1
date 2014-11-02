//
//  FlightDetailViewController.m
//  FlyWhizz
//
//  Created by Amy Baldwin on 10/29/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import "FlightDetailViewController.h"
#import "MBProgressHUD.h"

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

@property NSMutableArray *flightObjectIDs;

- (IBAction)saveFlightButton:(id)sender;

@end

@implementation FlightDetailViewController

-(void) viewDidLoad {
    [super viewDidLoad];
    
    self.flightObjectIDs = [[NSMutableArray alloc] init];
    
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
        [depTerminalGate appendString:[NSString stringWithFormat:@"Terminal %@", self.flight.departureTerminal]];
    }
    if (self.flight.departureGate) {
        [depTerminalGate appendString:[NSString stringWithFormat:@" Gate %@", self.flight.departureGate]];
    }
    self.destGateLabel.text = depTerminalGate;
    
    NSMutableString *arrTerminalGate = [NSMutableString stringWithString:@""];
    if (self.flight.arrivalTerminal) {
        [arrTerminalGate appendString:[NSString stringWithFormat:@"Terminal %@", self.flight.arrivalTerminal]];
    }
    if (self.flight.arrivalGate) {
        [arrTerminalGate appendString:[NSString stringWithFormat:@" Gate %@", self.flight.arrivalGate]];
    }
    self.originGateLabel.text = arrTerminalGate;
    
    if (self.flight.iataCode) {
        self.planeModelLabel.text = [NSString stringWithFormat:@"%@", self.flight.iataCode];
    }
    
    self.delayLabel.text = [NSString stringWithFormat:@"%d minutes", self.flight.delay];
}

- (void) viewWillDisappear:(BOOL)animated {
    [self saveChecklistItems];
}

- (IBAction)saveFlightButton:(id)sender {
    // Save flight to Parse
    PFObject *flightObject = [PFObject objectWithClassName:@"SavedFlight"];
    flightObject[@"flightID"] = self.flight.flightID;
    flightObject[@"airline"] = self.flight.airline;
    flightObject[@"flightNumber"] = self.flight.flightNumber;
    flightObject[@"status"] = self.flight.status;
    flightObject[@"origin"] = self.flight.origin;
    flightObject[@"destination"] = self.flight.destination;
    flightObject[@"flightDuration"] = self.flight.flightDuration;
    flightObject[@"departureDate"] = self.flight.departureDate;
    flightObject[@"arrivalDate"] = self.flight.arrivalDate;
    if (self.flight.departureGate) {
        flightObject[@"departureGate"] = self.flight.departureGate;
    }
    if (self.flight.arrivalGate) {
        flightObject[@"arrivalGate"] = self.flight.arrivalGate;
    }
    if (self.flight.departureTerminal) {
        flightObject[@"departureTerminal"] = self.flight.departureTerminal;
    }
    if (self.flight.arrivalTerminal) {
        flightObject[@"arrivalTerminal"] = self.flight.arrivalTerminal;
    }
    if (self.flight.iataCode) {
        flightObject[@"iataCode"] = self.flight.iataCode;
    }
    if (self.flight.delay) {
        flightObject[@"delay"] = [NSString stringWithFormat:@"%d", self.flight.delay];
    }

    [flightObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"%@", flightObject.objectId);
        // Save the object ID of this flight object in order to retrieve it from Parse later.
        // Save this information with NSCoding before leaving this view.
        [self.flightObjectIDs addObject:flightObject.objectId];
        NSLog(@"saved ID: %@", self.flightObjectIDs);
    }];
     
     // Show message that flight was saved to favorites.
     MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
     
     // Configure for text only and offset down
     hud.mode = MBProgressHUDModeText;
     hud.labelText = @"Flight saved";
     hud.margin = 10.f;
     hud.yOffset = 150.f;
     hud.removeFromSuperViewOnHide = YES;
     
     [hud hide:YES afterDelay:1];
}

#pragma mark - NSCoding

// Functions for use with NSCoding
- (NSString *)documentsDirectory
{
    return [@"~/Documents" stringByExpandingTildeInPath];
}

- (NSString *)dataFilePath
{
    NSLog(@"%@",[self documentsDirectory]);
    return [[self documentsDirectory] stringByAppendingPathComponent:@"Checklist.plist"];
    
}

// Need to change this to store flight ID in a shared instance of NSMutableArray
- (void)saveChecklistItems
{
    // Save data onto the disk.
    // Archiver uses bucket of bits to dump serialized objects.
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    // What needs to be encoded?
    [archiver encodeObject:self.flightObjectIDs forKey:@"savedFlightIDs"];
    
    // All objects get encoded at the same time here.
    [archiver finishEncoding];
    
    // Write the data to a file.
    [data writeToFile:[self dataFilePath] atomically:YES];
}

@end
