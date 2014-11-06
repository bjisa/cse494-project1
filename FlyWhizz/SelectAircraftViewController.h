//
//  SelectAircraftViewController.h
//  PlaneDetails
//
//  Created by Joshua Baldwin on 11/1/14.
//  Copyright (c) 2014 Joshua Baldwin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"


@interface SelectAircraftViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *aircraftNameEntryBox;

@end
