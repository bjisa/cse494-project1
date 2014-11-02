//
//  SavedFlights.h
//  FlyWhizz
//
//  Created by Ben Jisa on 11/2/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SavedFlights : NSObject
@property (nonatomic, strong) NSMutableArray *flightsList;

+(SavedFlights *)savedFlights;

@end