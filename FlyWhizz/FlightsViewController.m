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
@property NSInteger selectedIndexPathRow;

@property NSMutableArray *flightModels;
@property NSMutableArray *flightParseObjects;
@property NSMutableArray *flightIDs;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FlightsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.flightModels = [[NSMutableArray alloc] init];
    self.flightParseObjects = [[NSMutableArray alloc] init];
    self.flightIDs = [[NSMutableArray alloc] init];
    self.selectedIndexPathRow = 0;
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadTableViewData];
    [self.tableView reloadData];
    [self addMessageForEmptyTable];

}

- (void)addMessageForEmptyTable {
    // http://www.appcoda.com/pull-to-refresh-uitableview-empty/
    if (self.flightModels.count == 0) {
        
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"You have no saved flights.";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    else {
        self.tableView.backgroundView.hidden = YES;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
}

- (void)loadTableViewData {
    [self.flightModels removeAllObjects];
    [self.flightParseObjects removeAllObjects];
    
    [self loadChecklistItems];
    NSLog(@"Saved Flights ID List in FlightsViewController:%@", self.flightIDs);
    
    PFQuery *query = [PFQuery queryWithClassName:@"SavedFlight"];
    
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
    
    for (PFObject *flight in self.flightParseObjects) {
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
        flightModel.depDate = flight[@"depDate"];
        flightModel.arrDate = flight[@"arrDate"];
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
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"SavedFlights"]) {
        
        FlightDetailViewController *destination = segue.destinationViewController;
        
        destination.flight = self.flightModels[self.selectedIndexPathRow];
        
    }
    
}

- (void)deleteSavedFlight:(NSInteger)index {
    
    [self.flightIDs removeObjectAtIndex:index];
    [self saveChecklistItems];
    [self loadTableViewData];
    [self.tableView reloadData];
    [self addMessageForEmptyTable];
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
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm"];
     
     cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ Departure: %@ Arrival: %@",[dateFormat stringFromDate:flight.depDate], [timeFormat stringFromDate:flight.depDate], [timeFormat stringFromDate:flight.arrDate]];
    
    [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedIndexPathRow = indexPath.row;
    
    [self performSegueWithIdentifier:@"SavedFlights" sender:self];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Override to support swipe to delete.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteSavedFlight:indexPath.row];
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

- (IBAction)searchFlights:(id)sender {
    [self performSegueWithIdentifier:@"Search" sender:self];
}
@end
