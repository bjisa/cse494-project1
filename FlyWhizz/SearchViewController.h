//
//  SearchViewController.h
//  FlyWhizz
//
//  Created by Ben Jisa on 10/27/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SearchViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *input1;
@property (weak, nonatomic) IBOutlet UITextField *input2;
@property (weak, nonatomic) IBOutlet UISegmentedControl *searchTypeSelector;
@property NSString *searchType;
@property NSString *dateSelection;

@end
