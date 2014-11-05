//
//  FlightDetailViewController.m
//  FlyWhizz
//
//  Created by Amy Baldwin on 10/29/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import "AirportModel.h"
#import "FlightDetailViewController.h"
#import "MBProgressHUD.h"
#import "PlanesDetailViewController.h"
#import "TrackViewController.h"

@interface FlightDetailViewController()
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *flightDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
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

//@property SavedFlights *savedFlights;
@property NSMutableArray *flightIDs;

- (IBAction)saveFlightButton:(id)sender;

@end

@implementation FlightDetailViewController

-(void) viewDidLoad {
    [super viewDidLoad];
    
    //self.savedFlights = [SavedFlights savedFlights];
    self.flightIDs = [[NSMutableArray alloc] init];
    [self loadChecklistItems];
    
    self.flightDetailLabel.text = [NSString stringWithFormat:@"%@ %@", self.flight.airlineName, self.flight.flightNumber];
    
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
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm"];
    
    self.departureTimeLabel.text = [dateFormat stringFromDate:self.flight.depDate];
    self.arrivalTimeLabel.text = [dateFormat stringFromDate:self.flight.arrDate];
    
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
    
    self.delayLabel.text = [NSString stringWithFormat:@"%d minutes", self.flight.delay];

    self.originAirportLabel.text = self.flight.originAirportName;
    self.originLocationLabel.text = [NSString stringWithFormat:@"%@, %@", self.flight.originCity, self.flight.originState];
    
    self.destAirportLabel.text = self.flight.destAirportName;
    self.destLocationLabel.text = [NSString stringWithFormat:@"%@, %@", self.flight.destinationCity, self.flight.destinationState];
    
    NSString *imageName = [NSString stringWithFormat:@"%@.png", self.flight.airlineName];
    self.logoImageView.image = [UIImage imageNamed:imageName];
}

- (void) viewWillDisappear:(BOOL)animated {
    [self saveChecklistItems];
}

- (IBAction)saveFlightButton:(id)sender {
    PFObject *flightObject = [PFObject objectWithClassName:@"SavedFlight"];
    flightObject[@"flightID"] = self.flight.flightID;
    flightObject[@"airline"] = self.flight.airline;
    flightObject[@"airlineName"] = self.flight.airlineName;
    flightObject[@"flightNumber"] = self.flight.flightNumber;
    flightObject[@"status"] = self.flight.status;
    flightObject[@"origin"] = self.flight.origin;
    flightObject[@"destination"] = self.flight.destination;
    if (self.flight.flightDuration) {
        flightObject[@"flightDuration"] = self.flight.flightDuration;
    }
    flightObject[@"departureDate"] = self.flight.departureDate;
    flightObject[@"arrivalDate"] = self.flight.arrivalDate;
    flightObject[@"depDate"] = self.flight.depDate;
    flightObject[@"arrDate"] = self.flight.arrDate;
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
    flightObject[@"destinationCity"] = self.flight.destinationCity;
    flightObject[@"originCity"] = self.flight.originCity;
    flightObject[@"destinationState"] = self.flight.destinationState;
    flightObject[@"originState"] = self.flight.originState;
    flightObject[@"destAirportName"] = self.flight.destAirportName;
    flightObject[@"originAirportName"] = self.flight.originAirportName;

    [flightObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"%@", flightObject.objectId);
        // Save the object ID of this flight object in order to retrieve it from Parse later.
        [self.flightIDs addObject:flightObject.objectId];
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

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PlaneInfo"]) {
        PlanesDetailViewController *destination = segue.destinationViewController;
        destination.iataCode = self.flight.iataCode;
    }
    if ([segue.identifier isEqualToString:@"Track"]) {
        TrackViewController *destination = segue.destinationViewController;
        destination.flightID = self.flight.flightID;
        destination.flightStatus = self.flight.status;
        
    }
}

#pragma mark - NSCoding

- (NSString *)documentsDirectory
{
    return [@"~/Documents" stringByExpandingTildeInPath];
}

- (NSString *)dataFilePath
{
    NSLog(@"%@",[self documentsDirectory]);
    return [[self documentsDirectory] stringByAppendingPathComponent:@"Flight.plist"];
    
}

- (void)saveChecklistItems
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:self.flightIDs forKey:@"savedFlights"];
    
    [archiver finishEncoding];
    
    [data writeToFile:[self dataFilePath] atomically:YES];
}

- (void)loadChecklistItems
{
    NSString *path = [self dataFilePath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        
        self.flightIDs = [unarchiver decodeObjectForKey:@"savedFlights"];
        
        [unarchiver finishDecoding];
    }
}

@end
