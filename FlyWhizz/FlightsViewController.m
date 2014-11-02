//
//  FirstViewController.m
//  FlyWhizz
//
//  Created by Ben Jisa on 10/22/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import "FlightsViewController.h"

@interface FlightsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *savedFlightsTableView;

@property SavedFlights *savedFlights;

@end

@implementation FlightsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.savedFlights = [SavedFlights savedFlights];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewDelegation

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.savedFlights.flightsList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Use shared instance of objectIDs to get saved flight details from Parse.
    
    cell.textLabel.text = self.savedFlights.flightsList[indexPath.row];
    
    return cell;
}

@end
