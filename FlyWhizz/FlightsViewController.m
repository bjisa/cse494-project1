//
//  FirstViewController.m
//  FlyWhizz
//
//  Created by Ben Jisa on 10/22/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import "FlightsViewController.h"

@interface FlightsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *carrierInput;
@property (weak, nonatomic) IBOutlet UITextField *flightNumInput;

@end

@implementation FlightsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.carrierInput.placeholder = @"Carrier";
    self.flightNumInput.placeholder = @"Flight Number";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
