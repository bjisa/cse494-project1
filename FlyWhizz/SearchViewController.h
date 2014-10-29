//
//  SearchViewController.h
//  FlyWhizz
//
//  Created by Ben Jisa on 10/27/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *carrierInput;
@property (weak, nonatomic) IBOutlet UITextField *flightNumInput;
@property (weak, nonatomic) IBOutlet UISegmentedControl *searchTypeSelector;

@end
