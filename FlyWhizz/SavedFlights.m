//
//  SavedFlights.m
//  FlyWhizz
//
//  Created by Ben Jisa on 11/2/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import "SavedFlights.h"

@implementation SavedFlights

static SavedFlights *theFlights = nil;

+(SavedFlights *) savedFlights {
    
    if (theFlights == nil) {
        theFlights = [[SavedFlights alloc] init];
    }
    
    return theFlights;
}

- (id) init {
    
    self = [super init];
    
    self.flightsList = [[NSMutableArray alloc] init];
    
    return self;
}

@end
