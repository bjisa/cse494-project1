//
//  FlightModel.m
//  FlyWhizz
//
//  Created by Amy Baldwin on 10/29/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import "FlightModel.h"

@implementation FlightModel

-(id) initWithJSONDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.flightID = dict[@"flightId"];
        self.airline = dict[@"carrierFsCode"];
        self.airlineName = [NSString stringWithString:dict[@"carrierFsCode"]];
        self.flightNumber = dict[@"flightNumber"];
        self.status = dict[@"status"];
        self.origin = dict[@"departureAirportFsCode"];
        self.destination = dict[@"arrivalAirportFsCode"];
        
        NSDictionary *depDate = dict[@"departureDate"];
        if (depDate) {
            self.departureDate = depDate[@"dateLocal"];
        }
        
        NSDictionary *arrDate = dict[@"arrivalDate"];
        if (arrDate) {
            self.arrivalDate = arrDate[@"dateLocal"];
        }
        
        NSDictionary *flightDurations = dict[@"flightDurations"];
        if (flightDurations) {
            self.flightDuration = flightDurations[@"scheduledBlockMinutes"];
        }
        
        NSDictionary *airportResources = dict[@"airportResources"];
        if (airportResources) {
            self.departureGate = airportResources[@"departureGate"];
            self.arrivalGate = airportResources[@"arrivalGate"];
            self.departureTerminal = airportResources[@"departureTerminal"];
            self.arrivalTerminal = airportResources[@"arrivalTerminal"];
        }
        
        NSDictionary *flightEquipment = dict[@"flightEquipment"];
        if (flightEquipment) {
            self.iataCode = flightEquipment[@"scheduledEquipmentIataCode"];
        }
        
        NSDictionary *delays = dict[@"delays"];
        if (delays) {
            int totalDelay = 0;
            for (NSString *delay in delays) {
                int intDelay = [delay intValue];
                totalDelay += intDelay;
            }
            self.delay = totalDelay;
        }
        
        self.destinationCity = @"Unknown City";
        self.originCity = @"Unknown City";
        self.destinationState = @"Unknown State";
        self.originState = @"Unknown State";
        self.destAirportName = @"Unknown Airport Name";
        self.originAirportName = @"Unknown Airtport Name";
    }
    return self;
}

@end
