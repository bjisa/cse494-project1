//
//  AircraftDetailsViewController.m
//  PlaneDetails
//
//  Created by Joshua Baldwin on 11/2/14.
//  Copyright (c) 2014 Joshua Baldwin. All rights reserved.
//

#import "AircraftDetailsViewController.h"

@interface AircraftDetailsViewController ()

//@property NSXMLParser *parser;
@property AircraftModel *aircraftModel;
@property NSString *aircraft4DigitID;

@end


@implementation AircraftDetailsViewController


- (void) viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"Inside ViewDidLoad");
    
    // Get the aircraft name
    NSUserDefaults *prefs = [[NSUserDefaults alloc] init];
    self.aircraftName = [prefs objectForKey:@"AIRCRAFT_NAME_KEY"];

    self.aircraftName = [self aircraftIATAtoFullName];
    
    NSLog(@"Aircraft name = '%@'", self.aircraftName);

    // Set the 4 Digit ID Values
    [self set4DigitIDValues];
    
    // Get the JSON data into the model for parsing
    if (![self loadAircraftDataFromRemoteSource])
    {
        // If loading data from the external resource fails, attempt to load data from the internal resource
        if (![self loadAircraftDataFromLocalSource])
        {
            // If the internal resource is not found, show error message
            [[[UIAlertView alloc] initWithTitle:@"Data Not Found"
                                        message:[NSString stringWithFormat:@"%@ could not be found in the aircraft details database", self.aircraftName]
                                       delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"Ok", nil] show];
        }
        else
        {
            NSLog(@"Using data from local resource");
            
            // Copy data to the user's view
            [self copyDataToView];
        }
    }
    else
    {
        NSLog(@"Using data from global resource");
        
        // Copy data to the user's view
        [self copyDataToView];
    }
}

// Copy data to the user's view
- (void) copyDataToView
{
    // Check for null data
    if (self.aircraftModel == nil)
    {
        NSLog(@"AircraftModel nil.");
    }
    else
    {
        NSLog(@"AircraftModel successfully parsed data.");
    }
    
    // Display Primary Aircraft Data
    self.aircraftNameLabel.text = [NSString stringWithFormat:@"%@ %@", self.aircraftModel.Manufacturer, self.aircraftModel.Name];
    self.aircraftCategoryLabel.text = [NSString stringWithFormat:@"%@", self.aircraftModel.Type];
    self.emergencyExitsLabel.text = [NSString stringWithFormat:@"%@", self.aircraftModel.NumEmergencyExits];
    
    // Load Aircraft logo
    [self loadAircraftLogo];
    
    // Load Stars
    [self loadRatingStars];
    
    // Load Performance Data
    [self loadPerformanceData];
    
    // Load Certification Data
    [self loadCertificationData];
    
    // Load Aircraft speed data
    [self loadAircraftSpeedData];
    
    // Load Aircraft Dimensions data
    [self loadAircraftDimensions];
}


- (void) loadAircraftDimensions
{
    // Fuselage Dimensions
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.fuselageLengthLabel.text = [NSString stringWithFormat:@"%.1f m", self.aircraftModel.FuselageLength];
        self.fuselageWidthLabel.text = [NSString stringWithFormat:@"%.1f m", self.aircraftModel.FuselageWidth];
        self.fuselageHeightLabel.text = [NSString stringWithFormat:@"%.1f m", self.aircraftModel.FuselageHeight];
    });
    
    // Cabin Dimensions
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.cabinLengthLabel.text = [NSString stringWithFormat:@"%.1f m", self.aircraftModel.CabinLength];
        self.cabinWidthLabel.text = [NSString stringWithFormat:@"%.1f m", self.aircraftModel.CabinWidth];
        self.cabinHeightLabel.text = [NSString stringWithFormat:@"%.1f m", self.aircraftModel.CabinHeight];
    });
    
    // Wing Dimensions
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.wingspanLabel.text = [NSString stringWithFormat:@"%.1f m", self.aircraftModel.WingSpan];
        self.wingareaLabel.text = [NSString stringWithFormat:@"%.1f m2", self.aircraftModel.WingArea];
    });
    
}


- (void) loadCertificationData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.easaCertificationTrueFalseIcon.image = self.aircraftModel.EASA ? [UIImage imageNamed:@"GreenCheckMark"] : [UIImage imageNamed:@"RedXMark"];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.faaCertificationTrueFalseIcon.image = self.aircraftModel.FAA ? [UIImage imageNamed:@"GreenCheckMark"] : [UIImage imageNamed:@"RedXMark"];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.etopsCertificationTrueFalseIcon.image = self.aircraftModel.ETOPS ? [UIImage imageNamed:@"GreenCheckMark"] : [UIImage imageNamed:@"RedXMark"];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.shortFieldCertificationTrueFalseIcon.image = self.aircraftModel.ShortFieldPerformance ? [UIImage imageNamed:@"GreenCheckMark"]:[UIImage imageNamed:@"RedXMark"];
    });
}


- (void) loadPerformanceData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.oewLabel.text = [NSString stringWithFormat:@"%.1f mt", self.aircraftModel.OEW];
        self.mzfwLabel.text = [NSString stringWithFormat:@"%.1f mt", self.aircraftModel.MZFW];
        self.mtowLabel.text = [NSString stringWithFormat:@"%.1f mt", self.aircraftModel.MTOW];
        self.mlwLabel.text = [NSString stringWithFormat:@"%.1f mt", self.aircraftModel.MLW];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.takeoffDistanceLabel.text = [NSString stringWithFormat:@"%.0f m", self.aircraftModel.MaxTakeoffDistance];
        self.rangeDistanceLabel.text = [NSString stringWithFormat:@"%.0f nm", self.aircraftModel.MaxRange];
        self.maxFuelLabel.text = [NSString stringWithFormat:@"%.0f l", self.aircraftModel.MaxFuel];
        self.ceilingLabel.text = [NSString stringWithFormat:@"%.0f m", self.aircraftModel.Ceiling];
    });
}

- (void) loadAircraftSpeedData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.maxSpeedLabel.text = [NSString stringWithFormat:@"%.2f", self.aircraftModel.MaxSpeed];
        self.cruisingSpeedLabel.text = [NSString stringWithFormat:@"%.2f", self.aircraftModel.CruisingSpeed];
    });
}

- (void) loadAircraftLogo
{
    // Airbus
    if ([self.aircraftModel.Manufacturer rangeOfString:@"Airbus" options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        self.manufacturerLogo.image = [UIImage imageNamed:@"AirbusLogo"];
    }
    
    // Boeing
    else if ([self.aircraftModel.Manufacturer rangeOfString:@"Boeing" options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        self.manufacturerLogo.image = [UIImage imageNamed:@"BoeingLogo"];
    }
    
    // Bombardier
    else if ([self.aircraftModel.Manufacturer rangeOfString:@"Bombardier" options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        self.manufacturerLogo.image = [UIImage imageNamed:@"BombardierLogo"];
    }
    
    // Embraer
    else if ([self.aircraftModel.Manufacturer rangeOfString:@"Embraer" options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        self.manufacturerLogo.image = [UIImage imageNamed:@"EmbraerLogo"];
    }
    
    // We do not know the manufacturer of the aircraft
    else
    {
        self.manufacturerLogo.image = [UIImage imageNamed:@"DefaultLogo"];
    }
}

- (void) loadRatingStars
{
    // Star 5
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.star5Icon.image = (self.aircraftModel.SafetyRating >= 5)? [UIImage imageNamed:@"GoldStar"] : [UIImage imageNamed:@"GrayStar"];
    });
    
    // Star 4
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.star4Icon.image = (self.aircraftModel.SafetyRating >= 4)? [UIImage imageNamed:@"GoldStar"] : [UIImage imageNamed:@"GrayStar"];
    });
    
    // Star 3
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.star3Icon.image = (self.aircraftModel.SafetyRating >= 3)? [UIImage imageNamed:@"GoldStar"] : [UIImage imageNamed:@"GrayStar"];
    });
    
    // Star 2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.star2Icon.image = (self.aircraftModel.SafetyRating >= 2)? [UIImage imageNamed:@"GoldStar"] : [UIImage imageNamed:@"GrayStar"];
    });
    
    // Star 1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.star1Icon.image = (self.aircraftModel.SafetyRating >= 1)? [UIImage imageNamed:@"GoldStar"] : [UIImage imageNamed:@"GrayStar"];
    });
}

// Load the JSON file from http://www.public.asu.edu/~jbaldwi6/flywhizz/commercialaircraft.txt
- (Boolean) loadAircraftDataFromRemoteSource
{
    // Attempting to read data from URL    
    NSError *error;
    NSData *data;
    NSURL *URL = [[NSURL alloc] initWithString:@"http://www.public.asu.edu/~jbaldwi6/flywhizz/commercialaircraft.json"];
    
    data = [NSData dataWithContentsOfURL:URL];
    if (data == nil)
    {
        return false;
    }
    //NSLog(@"Successfully read data from URL");
    NSDictionary *dictionary = [[NSDictionary alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error]];
    self.aircraftModel = [[AircraftModel alloc] initWithJSONDictionary:dictionary[@"CommercialAircraft"][self.aircraft4DigitID]];
    return true;
}

// Load the local JSON file
- (Boolean) loadAircraftDataFromLocalSource
{
    NSLog(@"URL data read failed, reading from local filepath instead");
    NSError *error = nil;
    NSData *data;
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"CommercialAircraft" ofType:@"json"];
    data = [NSData dataWithContentsOfFile:filepath options:kNilOptions error:&error];
    if (data == nil)
    {
        return false;
    }
    NSDictionary *dictionary = [[NSDictionary alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error]];
    self.aircraftModel = [[AircraftModel alloc] initWithJSONDictionary:dictionary[@"CommercialAircraft"][self.aircraft4DigitID]];
    return true;
}

// Wrapper code that converts IATA values to aircraft names
- (NSString *) aircraftIATAtoFullName
{
    // Store the aircraft name in a new string
    NSString *name = [self.aircraft4DigitID stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (name.length <= 4)
    {
        // A330
        if (([name rangeOfString:@"A33" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
            ([name rangeOfString:@"A330" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
            ([name rangeOfString:@"330" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
            ([name rangeOfString:@"A332" options:NSCaseInsensitiveSearch].location != NSNotFound)) {
            return @"Airbus A330-200";
        }
        else if ([name rangeOfString:@"A333" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            return @"Airbus A330-300";
        }
        // A340
        else if (([name rangeOfString:@"A34" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"A340" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"340" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"A342" options:NSCaseInsensitiveSearch].location != NSNotFound)) {
            return @"Airbus A340-200";
        }
        else if ([name rangeOfString:@"A343" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            return @"Airbus A340-300";
        }
        else if ([name rangeOfString:@"A345" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            return @"Airbus A340-500";
        }
        else if ([name rangeOfString:@"A346" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            return @"Airbus A340-600";
        }
        // A350
        else if ([name rangeOfString:@"A358" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            return @"Airbus A350-800";
        }
        else if ([name rangeOfString:@"A351" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            return @"Airbus A350-1000";
        }
        else if (([name rangeOfString:@"A35" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"A350" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"350" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"A359" options:NSCaseInsensitiveSearch].location != NSNotFound)) {
            return @"Airbus A350-900";
        }
        // A380
        else if (([name rangeOfString:@"A38" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"A380" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"380" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"A381" options:NSCaseInsensitiveSearch].location != NSNotFound)) {
            return @"Airbus A380";
        }
        
        // A320
        else if (([name rangeOfString:@"A318" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"318" options:NSCaseInsensitiveSearch].location != NSNotFound)) {
            return @"Airbus A318";
        }
        else if (([name rangeOfString:@"A319" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"319" options:NSCaseInsensitiveSearch].location != NSNotFound)) {
            return @"Airbus A319";
        }
        else if (([name rangeOfString:@"A321" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"321" options:NSCaseInsensitiveSearch].location != NSNotFound)) {
            return @"Airbus A321";
        }
        else if (([name rangeOfString:@"A" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"A3" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"A32" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"A320" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"320" options:NSCaseInsensitiveSearch].location != NSNotFound)) {
            return @"Airbus A320";
        }
        // Boeing 717
        else if (([name rangeOfString:@"B71" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"B17" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"B717" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"717" options:NSCaseInsensitiveSearch].location != NSNotFound)) {
            return @"Boeing 717";
        }
        // Boeing 737
        else if (([name rangeOfString:@"B371" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"B731" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"371" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"731" options:NSCaseInsensitiveSearch].location != NSNotFound)) {
            return @"Boeing 737-300 Original";
        }
        else if (([name rangeOfString:@"B372" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"B732" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"372" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"732" options:NSCaseInsensitiveSearch].location != NSNotFound)) {
            return @"Boeing 737-400 Original";
        }
        else if (([name rangeOfString:@"B373" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"B733" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"373" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"733" options:NSCaseInsensitiveSearch].location != NSNotFound)) {
            return @"Boeing 737-300 Classic";
        }
        else if (([name rangeOfString:@"B374" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"B734" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"374" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"734" options:NSCaseInsensitiveSearch].location != NSNotFound)) {
            return @"Boeing 737-400 Classic";
        }
        else if (([name rangeOfString:@"B375" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"B735" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"375" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"735" options:NSCaseInsensitiveSearch].location != NSNotFound)) {
            return @"Boeing 737-500 Classic";
        }
        else if (([name rangeOfString:@"B376" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"B736" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"376" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"736" options:NSCaseInsensitiveSearch].location != NSNotFound)) {
            return @"Boeing 737-600 NextGen";
        }
        else if (([name rangeOfString:@"B378" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"B738" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"378" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"738" options:NSCaseInsensitiveSearch].location != NSNotFound)) {
            return @"Boeing 737-800 NextGen";
        }
        else if (([name rangeOfString:@"B379" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"B739" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"379" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"739" options:NSCaseInsensitiveSearch].location != NSNotFound)) {
            return @"Boeing 737-900 ER";
        }
        else if (([name rangeOfString:@"B3" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"B37" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"B73" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"B377" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"B737" options:NSCaseInsensitiveSearch].location != NSNotFound)  ||
                 ([name rangeOfString:@"377" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"737" options:NSCaseInsensitiveSearch].location != NSNotFound)) {
            return @"Boeing 737-700 NextGen";
        }
        
        // Boeing 747
        else if (([name rangeOfString:@"B471" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"B741" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"471" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"741" options:NSCaseInsensitiveSearch].location != NSNotFound)) {
            return @"Boeing 747-100";
        }
        else if (([name rangeOfString:@"B472" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"B742" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"472" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"742" options:NSCaseInsensitiveSearch].location != NSNotFound)) {
            return @"Boeing 747-200";
        }
        else if (([name rangeOfString:@"B473" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"B743" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"473" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"743" options:NSCaseInsensitiveSearch].location != NSNotFound)) {
            return @"Boeing 747-300";
        }
        else if (([name rangeOfString:@"B474" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"B744" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"474" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"744" options:NSCaseInsensitiveSearch].location != NSNotFound)) {
            return @"Boeing 747-400";
        }
        else if (([name rangeOfString:@"B4" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"B47" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"B74" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"B478" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"B748" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"478" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"748" options:NSCaseInsensitiveSearch].location != NSNotFound)) {
            return @"Boeing 747-800";
        }
        
        // Boeing 757
        else if (([name rangeOfString:@"573" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"753" options:NSCaseInsensitiveSearch].location != NSNotFound)) {
            return @"Boeing 757-300";
        }
        else if(([name rangeOfString:@"B5" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                ([name rangeOfString:@"B57" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                ([name rangeOfString:@"757" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                ([name rangeOfString:@"572" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                ([name rangeOfString:@"752" options:NSCaseInsensitiveSearch].location != NSNotFound)) {
            return @"Boeing 757-200";
        }
        
        // Boeing 767
        else if (([name rangeOfString:@"674" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"764" options:NSCaseInsensitiveSearch].location != NSNotFound)) {
            return @"Boeing 767-400";
        }
        else if (([name rangeOfString:@"673" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"763" options:NSCaseInsensitiveSearch].location != NSNotFound)) {
            return @"Boeing 767-300";
        }
        else if(([name rangeOfString:@"B6" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                ([name rangeOfString:@"B67" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                ([name rangeOfString:@"672" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                ([name rangeOfString:@"762" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                ([name rangeOfString:@"767" options:NSCaseInsensitiveSearch].location != NSNotFound)) {
            return @"Boeing 767-200";
        }
        
        // Boeing 777
        else if (([name rangeOfString:@"377" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"773" options:NSCaseInsensitiveSearch].location != NSNotFound)) {
            return @"Boeing 777-300";
        }
        else if(([name rangeOfString:@"77" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                ([name rangeOfString:@"277" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                ([name rangeOfString:@"772" options:NSCaseInsensitiveSearch].location != NSNotFound)) {
            return @"Boeing 777-200";
        }
        
        // Boeing 787
        else if (([name rangeOfString:@"878" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"787" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"788" options:NSCaseInsensitiveSearch].location != NSNotFound)) {
            return @"Boeing 787-800";
        }
        else if (([name rangeOfString:@"879" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                 ([name rangeOfString:@"789" options:NSCaseInsensitiveSearch].location != NSNotFound)) {
            return @"Boeing 787-900";
        }
        else if(([name rangeOfString:@"B8" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                ([name rangeOfString:@"B87" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                ([name rangeOfString:@"871" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                ([name rangeOfString:@"781" options:NSCaseInsensitiveSearch].location != NSNotFound)) {
            return @"Boeing 787-1000";
        }
        
        // MD 90
        else if([name rangeOfString:@"MD9" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            return @"Boeing MD-90";
        }
        
        // MD 80
        else if(([name rangeOfString:@"MD" options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                ([name rangeOfString:@"MD8" options:NSCaseInsensitiveSearch].location != NSNotFound)) {
            return @"Boeing MD-80";
        }
        
        // Bombardier C-Series:     http://en.wikipedia.org/wiki/Bombardier_CSeries
        else if ([name rangeOfString:@"C1" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            return @"Bombardier C-100";
        }
        else if ([name rangeOfString:@"C3" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            return @"Bombardier C-300";
        }
        
        // Assume that any jet not already found is some type of regional jet (Q-Series, CRJ, ERJ, E-Jet, etc)
        // At this point, we ran out of time to support jets that are Bombardier and Embraer makes.
        // Most (but not all) of these jets are regional jets.
        // Bombardier Q-Series:     http://en.wikipedia.org/wiki/Bombardier_Dash_8
        // Bombardier CRJ-Series:   http://en.wikipedia.org/wiki/Bombardier_CRJ700_series
        // Embraer ERJ-Series:      http://en.wikipedia.org/wiki/Embraer_ERJ_145_family
        // Embraer E-Jets:          http://en.wikipedia.org/wiki/Embraer_E-Jet_family
        else
            return @"Regional";
        
        
    }
    return @"INVALID ENTRY";     // to keep compiler happy for now
}

- (void) set4DigitIDValues
{
    NSLog(@"Setting the 4 Digit Aircraft Name for %@", self.aircraftName);
    
    // Airbus
    if ([self.aircraftName rangeOfString:@"Airbus" options:NSCaseInsensitiveSearch].location != NSNotFound) {
        // A318
        if ([self.aircraftName rangeOfString:@"318" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            self.aircraft4DigitID = @"A318";
        }
        // A319
        else if ([self.aircraftName rangeOfString:@"319" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            self.aircraft4DigitID = @"A319";
        }
        // A320
        else if ([self.aircraftName rangeOfString:@"320" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            self.aircraft4DigitID = @"A320";
        }
        // A321
        else if ([self.aircraftName rangeOfString:@"321" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            self.aircraft4DigitID = @"A321";
        }
        
        // A330 Series not implemented, use default widebody jet case
        else if ([self.aircraftName rangeOfString:@"330" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            self.aircraftName = @"Widebody";
        }
        
        // A340 Series not implemented, use default widebody jet case
        else if ([self.aircraftName rangeOfString:@"340" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            self.aircraftName = @"Widebody";
        }
        
        // A350 Series not implemented, use default widebody jet case
        else if ([self.aircraftName rangeOfString:@"350" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            self.aircraftName = @"Widebody";
        }
        
        // A380 not implemented, use default widebody jet case
        else if ([self.aircraftName rangeOfString:@"380" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            self.aircraftName = @"Widebody";
        }
    }
    
    // Boeing
    else if ([self.aircraftName rangeOfString:@"Boeing" options:NSCaseInsensitiveSearch].location != NSNotFound) {
        // 717
        if ([self.aircraftName rangeOfString:@"717" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            self.aircraft4DigitID = @"B717";
        }
        
        // 737
        else if ([self.aircraftName rangeOfString:@"737" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            if ([self.aircraftName rangeOfString:@"300" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                self.aircraft4DigitID = @"B733";
            }
            else if ([self.aircraftName rangeOfString:@"400" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                self.aircraft4DigitID = @"B734";
            }
            else if ([self.aircraftName rangeOfString:@"500" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                self.aircraft4DigitID = @"B735";
            }
            else if ([self.aircraftName rangeOfString:@"600" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                self.aircraft4DigitID = @"B736";
            }
            else if ([self.aircraftName rangeOfString:@"700" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                self.aircraft4DigitID = @"B737";
            }
            else if ([self.aircraftName rangeOfString:@"800" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                self.aircraft4DigitID = @"B738";
            }
            else if ([self.aircraftName rangeOfString:@"900" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                self.aircraft4DigitID = @"B739";
            }
        }
        
        // 747 not implemented, use default widebody jet case
        else if ([self.aircraftName rangeOfString:@"747" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            self.aircraftName = @"Widebody";
        }
        
        // 757
        else if ([self.aircraftName rangeOfString:@"757" options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            if ([self.aircraftName rangeOfString:@"200" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                self.aircraft4DigitID = @"B752";
            }
            else if ([self.aircraftName rangeOfString:@"300" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                self.aircraft4DigitID = @"B753";
            }
        }
        
        // 767 not implemented, use default widebody jet case
        else if ([self.aircraftName rangeOfString:@"767" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            self.aircraftName = @"Widebody";
        }
        
        // 777 not implemented, use default widebody jet case
        else if ([self.aircraftName rangeOfString:@"777" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            self.aircraftName = @"Widebody";
        }
        
        // 787 not implemented, use default widebody jet case
        else if ([self.aircraftName rangeOfString:@"787" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            self.aircraftName = @"Widebody";
        }
        
        // MD80 Series not implemented, use default narrowbody jet case
        else if ([self.aircraftName rangeOfString:@"80" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            self.aircraftName = @"Narrowbody";
        }
        
        // MD90 Series not implemented, use default narrowbody jet case
        else if ([self.aircraftName rangeOfString:@"90" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            self.aircraftName = @"Narrowbody";
        }
        
    }
    
    // Bombardier C-Series not implemented, use default narrowbody jet case
    else if ([self.aircraftName rangeOfString:@"Bombardier" options:NSCaseInsensitiveSearch].location != NSNotFound) {
        if ([self.aircraftName rangeOfString:@"C-1" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            self.aircraftName = @"Narrowbody";
        }
        else if ([self.aircraftName rangeOfString:@"C-3" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            self.aircraftName = @"Narrowbody";
        }
        else self.aircraftName = @"Regional";
    }
    
    // Embraer ERJ's and E-Jets not implemented, use default regional case
    else if ([self.aircraftName rangeOfString:@"Embraer" options:NSCaseInsensitiveSearch].location != NSNotFound) {
        self.aircraftName = @"Regional";
    }

    
    // CRJs not implemented, use default regional jet case
    // ERJs not implemented, use default regional jet case
    // Q-Series not implemented, use default regional jet case
    // E-Jets not implemented, use default regional jet case
    
    // Default Cases
    if ([self.aircraftName rangeOfString:@"Regional" options:NSCaseInsensitiveSearch].location != NSNotFound) {
        self.aircraft4DigitID = @"Regional";
    }
    if ([self.aircraftName rangeOfString:@"Narrowbody" options:NSCaseInsensitiveSearch].location != NSNotFound) {
        self.aircraft4DigitID = @"Narrowbody";
    }
    if ([self.aircraftName rangeOfString:@"Widebody" options:NSCaseInsensitiveSearch].location != NSNotFound) {
        self.aircraft4DigitID = @"Widebody";
    }
    
    // Bombardier not implemented
    // CRJ Series
    // Q-Series
    // CSeries
    
    // Embraer not implemented
    // ERJ
    // E-Jets
    
    
    // Store the aircraft 4 Digit ID
    NSUserDefaults *prefs = [[NSUserDefaults alloc] init];
    [prefs setObject:self.aircraft4DigitID forKey:@"AIRCRAFT_4_DIGIT_ID_KEY"];
    NSLog(@"4 digit aircraft ID = '%@'", self.aircraft4DigitID);
}


- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
