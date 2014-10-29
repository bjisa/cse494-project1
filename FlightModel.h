//
//  FlightModel.h
//  FlyWhizz
//
//  Created by Amy Baldwin on 10/29/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlightModel : NSObject

@property NSString *flightID;
@property NSString *airline;
@property NSString *flightNumber;
@property NSString *status;
@property NSString *origin;
@property NSString *destination;
@property NSString *flightDuration;
@property NSString *departureDate;
@property NSString *arrivalDate;
@property NSString *departureGate;
@property NSString *arrivalGate;
@property NSString *departureTerminal;
@property NSString *arrivalTerminal;
@property NSString *iataCode;
@property int delay;

-(id) initWithJSONDictionary:(NSDictionary *)dict;

@end
