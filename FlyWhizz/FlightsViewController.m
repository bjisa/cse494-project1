//
//  FirstViewController.m
//  FlyWhizz
//
//  Created by Ben Jisa on 10/22/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import "FlightModel.h"
#import "FlightDetailViewController.h"
#import "FlightsViewController.h"

@interface FlightsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *savedFlightsTableView;

//@property SavedFlights *savedFlights;
@property NSMutableArray *flightModels;
@property NSMutableArray *flightParseObjects;
@property NSMutableArray *flightIDs;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FlightsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //self.savedFlights = [SavedFlights savedFlights];
    self.flightModels = [[NSMutableArray alloc] init];
    self.flightParseObjects = [[NSMutableArray alloc] init];
    self.flightIDs = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadChecklistItems];
    NSLog(@"Saved Flights ID List in FlightsViewController:%@", self.flightIDs);
    
    // Fill flight list with flights saved in Parse.
    PFQuery *query = [PFQuery queryWithClassName:@"SavedFlight"];
    
    // Get object with all IDs
    for (NSString *savedID in self.flightIDs) {
        NSLog(@"ID outside: %@", savedID);
        // Only try to read from Parse if ID is not null
        if (![savedID isEqualToString:@"(null)"]) {
            NSLog(@"ID inside: %@", savedID);
            PFObject *savedFlight = [query getObjectWithId:savedID];
            NSLog(@"%@", savedFlight);
            [self.flightParseObjects addObject:savedFlight];
        }
    }
    NSLog(@"Flight models retrieved: %@", self.flightParseObjects);
    
    for (PFObject *flight in self.flightParseObjects) {
        // Use flightIDs to get saved flight details from Parse.
        FlightModel *flightModel = [[FlightModel alloc] init];
        flightModel.flightID = flight[@"flightID"];
        flightModel.airline = flight[@"airline"];
        flightModel.airlineName = flight[@"airlineName"];
        flightModel.flightNumber = flight[@"flightNumber"];
        flightModel.status = flight[@"status"];
        flightModel.origin = flight[@"origin"];
        flightModel.destination = flight[@"destination"];
        flightModel.flightDuration = flight[@"flightDuration"];
        flightModel.departureDate = flight[@"departureDate"];
        flightModel.arrivalDate = flight[@"arrivalDate"];
        flightModel.departureGate = flight[@"departureGate"];
        flightModel.arrivalGate = flight[@"arrivalGate"];
        flightModel.departureTerminal = flight[@"departureTerminal"];
        flightModel.arrivalTerminal = flight[@"arrivalTerminal"];
        flightModel.iataCode = flight[@"iataCode"];
        flightModel.delay = [flight[@"delay"] intValue];
        flightModel.destinationCity = flight[@"destinationCity"];
        flightModel.originCity = flight[@"originCity"];;
        flightModel.destinationState = flight[@"destinationState"];
        flightModel.originState = flight[@"originState"];
        flightModel.destAirportName = flight[@"destAirportName"];
        flightModel.originAirportName = flight[@"originAirportName"];
        
        [self.flightModels addObject:flightModel];
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    [self saveChecklistItems];
    [self.flightModels removeAllObjects];
    [self.flightParseObjects removeAllObjects];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Pass the flight model to the FlightDetailViewController.
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SavedFlights"]) {
        FlightDetailViewController *destination = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        destination.flight = self.flightModels[indexPath.row];
    }
}

#pragma mark - TableViewDelegation

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.flightModels.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    FlightModel *flight = self.flightModels[indexPath.row];
    
    if (flight.airlineName) {
        NSString *flightNum = [NSString stringWithFormat:@"%@ %@", flight.airlineName, flight.flightNumber];
        cell.textLabel.text = flightNum;
    } else {
        NSString *flightNum = [NSString stringWithFormat:@"%@ %@", flight.airline, flight.flightNumber];
        cell.textLabel.text = flightNum;
    }
    
    NSInteger durationMinutes = [flight.flightDuration integerValue];
    NSInteger durHours = durationMinutes / 60;
    NSInteger durMin = durationMinutes - (durHours * 60);
    NSString *times = [NSString stringWithFormat:@"Duration: %d hr %d min", (int)durHours, (int)durMin];
    
    cell.detailTextLabel.text = times;
    [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"SavedFlights" sender:self];
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
    return [[self documentsDirectory] stringByAppendingPathComponent:@"Flight.plist"];
    
}

- (void)saveChecklistItems
{
    // Save data onto the disk.
    // Archiver uses bucket of bits to dump serialized objects.
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    // What needs to be encoded?
    [archiver encodeObject:self.flightIDs forKey:@"savedFlights"];
    
    // All objects get encoded at the same time here.
    [archiver finishEncoding];
    
    // Write the data to a file.
    [data writeToFile:[self dataFilePath] atomically:YES];
}

- (void)loadChecklistItems
{
    NSString *path = [self dataFilePath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        
        self.flightIDs = [unarchiver decodeObjectForKey:@"savedFlights"];
        
        // Won't actually decode until here.
        [unarchiver finishDecoding];
    }
}

- (IBAction)searchFlights:(id)sender {
    [self performSegueWithIdentifier:@"Search" sender:self];
}
@end
