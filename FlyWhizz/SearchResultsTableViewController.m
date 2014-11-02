//
//  SearchResultsTableViewController.m
//  FlyWhizz
//
//  Created by Ben Jisa on 10/29/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

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
    
   // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getFlightResults];
 //   });
}

-(void) getFlightResults
{
    // Get date for today
    NSDateComponents *theDate = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    if ([self.dateSelection isEqualToString:@"Tomorrow"])
    {
        // Get date for tomorrow
        //int incrementBy = 1;
        //NSDate * theDate = [[NSDate alloc] initWithTimeIntervalSinceNow:60 * 60 * 24 * incrementBy];
    }
    
    int year = (int)theDate.year;
    int month = (int)theDate.month;
    int day = (int)theDate.day;
    
    NSString * queryString;
    
    if ([self.searchType isEqualToString:@"byOriginDestination"])
    {
        queryString = [NSString stringWithFormat:@"%@route/status/%@/%@/arr/%d/%d/%d?appId=%@&appKey=%@&utc=false&maxFlights=5",kBaseURL, self.originCode, self.destinationCode, year, month, day, apiID, apiKey];
    }
    else // Search by Flight Number
    {
        queryString = [NSString stringWithFormat:@"%@flight/status/%@/%@/arr/%d/%d/%d?appId=%@&appKey=%@&utc=false",kBaseURL, self.carrier, self.flightNumber, year, month, day, apiID, apiKey];
    }
    
    NSData *flightsQuery = [NSData dataWithContentsOfURL:[NSURL URLWithString:queryString]];

    NSDictionary *flights = [NSJSONSerialization JSONObjectWithData:flightsQuery options:kNilOptions error:Nil];
    
    NSDictionary * flightsToSave = flights[@"flightStatuses"];
    
    for (NSDictionary * flight in flightsToSave) {
        FlightModel * thisFlight = [[FlightModel alloc] initWithJSONDictionary:flight];
        [self.flights2 addObject:thisFlight];
    }
    
}

// Pass the flight model to the FlightDetailViewController.
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    FlightDetailViewController *destination = segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    destination.flight = self.flights2[indexPath.row];
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
    
    NSString * flightNum = flight.flightNumber;
    NSString * times = [NSString stringWithFormat:@"Arr: %@ Dep: %@", flight.arrivalDate, flight.departureDate];
    
    cell.textLabel.text = flightNum;
    cell.detailTextLabel.text = times;
    [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    
    return cell;
    
}

@end
