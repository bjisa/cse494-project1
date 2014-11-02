//
//  AirportModel.m
//  FlyWhizz
//
//  Created by Amy Baldwin on 11/2/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import "AirportModel.h"

@implementation AirportModel

-(id) initWithJSONDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.airportName = dict[@"name"];
        self.acronym = dict[@"fs"];
        self.city = dict[@"city"];
        self.state = dict[@"stateCode"];
        self.postalCode = dict[@"postalCode"];
        self.streetAddress = dict[@"street1"];
        self.country = dict[@"countryName"];
        self.elevation = dict[@"elevationFeet"];
        self.localTime = dict[@"localTime"];
        self.weatherURL = dict[@"weatherUrl"];
        self.weatherZone = dict[@"weatherZone"];
    }
    return self;
}

@end
