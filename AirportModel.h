//
//  AirportModel.h
//  FlyWhizz
//
//  Created by Amy Baldwin on 11/2/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AirportModel : NSObject

@property NSString *airportName;
@property NSString *acronym;
@property NSString *city;
@property NSString *state;
@property NSString *postalCode;
@property NSString *streetAddress;
@property NSString *country;
@property NSString *elevation;
@property NSString *localTime;
@property NSString *weatherURL;
@property NSString *weatherZone;

-(id) initWithJSONDictionary:(NSDictionary *)dict;

@end
