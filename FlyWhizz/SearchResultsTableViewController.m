//
//  SearchResultsTableViewController.m
//  FlyWhizz
//
//  Created by Ben Jisa on 10/29/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import "AirlineModel.h"
#import "AirportModel.h"
#import "Constants.h"
#import "FlightModel.h"
#import "FlightDetailViewController.h"
#import "SearchResultsTableViewController.h"

#define kBaseURL @"https://api.flightstats.com/flex/flightstatus/rest/v2/json/"
#define kBaseURL @"https://api.flightstats.com/flex/flightstatus/rest/v2/json/"

@implementation SearchResultsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.results = [[NSMutableArray alloc] init];
    
    self.flights2 = [[NSMutableArray alloc] init];
    
    self.airports = [[NSMutableDictionary alloc] init];
    self.airlines = [[NSMutableDictionary alloc] init];
    
   // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getFlightResults];
 //   });
    
    [self addMessageForEmptyTable];
}

-(void) getFlightResults
{
    // Get date for today
    NSDateComponents *theDate = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    if ([self.dateSelection isEqualToString:@"Tomorrow"])
    {
        // Get date for tomorrow
        int incrementBy = 1;
        NSDate * tomorrowDate = [[NSDate alloc] initWithTimeIntervalSinceNow:60 * 60 * 24 * incrementBy];
        theDate = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:tomorrowDate];
    }
    
    int year = (int)theDate.year;
    int month = (int)theDate.month;
    int day = (int)theDate.day;
    
    NSString *queryString;
    
    if ([self.searchType isEqualToString:@"byOriginDestination"])
    {
        queryString = [NSString stringWithFormat:@"%@route/status/%@/%@/arr/%d/%d/%d?appId=%@&appKey=%@&utc=false&maxFlights=15",kBaseURL, self.originCode, self.destinationCode, year, month, day, apiID, apiKey];
    }
    else // Search by Flight Number
    {
        queryString = [NSString stringWithFormat:@"%@flight/status/%@/%@/arr/%d/%d/%d?appId=%@&appKey=%@&utc=false",kBaseURL, self.carrier, self.flightNumber, year, month, day, apiID, apiKey];
    }
    
    NSData *flightsQuery = [NSData dataWithContentsOfURL:[NSURL URLWithString:queryString]];

    NSDictionary *flights = [NSJSONSerialization JSONObjectWithData:flightsQuery options:kNilOptions error:Nil];
    
    NSDictionary *appendix = flights[@"appendix"];
    
    NSDictionary *airportsToSave = appendix[@"airports"];
    for (NSDictionary *airport in airportsToSave) {
        AirportModel *thisAirport = [[AirportModel alloc] initWithJSONDictionary:airport];
        NSString *key = airport[@"fs"];
        [self.airports setObject:thisAirport forKey:key];
    }
    
    NSDictionary *airlinesToSave = appendix[@"airlines"];
    for (NSDictionary *airline in airlinesToSave) {
        AirlineModel *thisAirline = [[AirlineModel alloc] initWithJSONDictionary:airline];
        NSString *key = airline[@"fs"];
        [self.airlines setObject:thisAirline forKey:key];
    }
    
    NSDictionary *flightsToSave = flights[@"flightStatuses"];
    
    for (NSDictionary *flight in flightsToSave) {
        FlightModel * thisFlight = [[FlightModel alloc] initWithJSONDictionary:flight];
        AirlineModel *airline = [self.airlines objectForKey:thisFlight.airline];
        thisFlight.airlineName = airline.name;
        AirportModel *destAirport = [self.airports objectForKey:thisFlight.destination];
        //NSLog(@"dest name: %@", destAirport.airportName);
        thisFlight.destAirportName = destAirport.airportName;
        thisFlight.destinationCity = destAirport.city;
        thisFlight.destinationState = destAirport.state;
        AirportModel *originAirport = [self.airports objectForKey:thisFlight.origin];
        thisFlight.originAirportName = originAirport.airportName;
        thisFlight.originCity = originAirport.city;
        thisFlight.originState = originAirport.state;
        [self.flights2 addObject:thisFlight];
    }
}

// Pass the flight model to the FlightDetailViewController.
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    FlightDetailViewController *destination = segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    destination.flight = self.flights2[indexPath.row];
    destination.airports = self.airports;
}

#pragma mark - TableViewDelegation

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.flights2.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    FlightModel *flight = self.flights2[indexPath.row];
    
    NSString *flightNum = [NSString stringWithFormat:@"%@ %@", flight.airlineName, flight.flightNumber];
    cell.textLabel.text = flightNum;
    
    NSInteger durationMinutes = [flight.flightDuration integerValue];
    NSInteger durHours = durationMinutes / 60;
    NSInteger durMin = durationMinutes - (durHours * 60);
    NSString *times = [NSString stringWithFormat:@"Duration: %d hr %d min", (int)durHours, (int)durMin];
    
    cell.detailTextLabel.text = times;
    [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    
    return cell;
    
}

- (void)addMessageForEmptyTable {
    // http://www.appcoda.com/pull-to-refresh-uitableview-empty/
    if (self.flights2.count == 0) {
        
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No results.";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
}

@end
