//
//  AircraftDetailsViewController.h
//  PlaneDetails
//
//  Created by Joshua Baldwin on 11/2/14.
//  Copyright (c) 2014 Joshua Baldwin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "AircraftModel.h"


@interface AircraftDetailsViewController : UIViewController

// Stores the name of the string that describes the aircraft
@property NSString *aircraftName;

// Aircraft Name and Category Labels
@property (strong, nonatomic) IBOutlet UILabel *aircraftNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *aircraftCategoryLabel;
@property (strong, nonatomic) IBOutlet UILabel *emergencyExitsLabel;


// Speed Labels
@property (strong, nonatomic) IBOutlet UILabel *cruisingSpeedLabel;
@property (strong, nonatomic) IBOutlet UILabel *maxSpeedLabel;


// Manufacturer Logo
@property (strong, nonatomic) IBOutlet UIImageView *manufacturerLogo;


// Safety Rating
@property (strong, nonatomic) IBOutlet UIImageView *star1Icon;
@property (strong, nonatomic) IBOutlet UIImageView *star2Icon;
@property (strong, nonatomic) IBOutlet UIImageView *star3Icon;
@property (strong, nonatomic) IBOutlet UIImageView *star4Icon;
@property (strong, nonatomic) IBOutlet UIImageView *star5Icon;


// Fuselage Dimensions Labels
@property (strong, nonatomic) IBOutlet UILabel *fuselageLengthLabel;
@property (strong, nonatomic) IBOutlet UILabel *fuselageWidthLabel;
@property (strong, nonatomic) IBOutlet UILabel *fuselageHeightLabel;


// Cabin Dimensions Labels
@property (strong, nonatomic) IBOutlet UILabel *cabinLengthLabel;
@property (strong, nonatomic) IBOutlet UILabel *cabinWidthLabel;
@property (strong, nonatomic) IBOutlet UILabel *cabinHeightLabel;


// Wing Dimensions Labels
@property (strong, nonatomic) IBOutlet UILabel *wingspanLabel;
@property (strong, nonatomic) IBOutlet UILabel *wingareaLabel;


// Certification Labels
@property (strong, nonatomic) IBOutlet UIImageView *faaCertificationTrueFalseIcon;
@property (strong, nonatomic) IBOutlet UIImageView *easaCertificationTrueFalseIcon;
@property (strong, nonatomic) IBOutlet UIImageView *etopsCertificationTrueFalseIcon;
@property (strong, nonatomic) IBOutlet UIImageView *shortFieldCertificationTrueFalseIcon;


// Aircraft Performance Labels
@property (strong, nonatomic) IBOutlet UILabel *oewLabel;
@property (strong, nonatomic) IBOutlet UILabel *mzfwLabel;
@property (strong, nonatomic) IBOutlet UILabel *mlwLabel;
@property (strong, nonatomic) IBOutlet UILabel *mtowLabel;
@property (strong, nonatomic) IBOutlet UILabel *takeoffDistanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *rangeDistanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *maxFuelLabel;
@property (strong, nonatomic) IBOutlet UILabel *ceilingLabel;



@end
