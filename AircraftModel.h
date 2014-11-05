//
//  AircraftObject.h
//  FlyWhizz
//
//  Created by Ben Jisa on 11/2/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AircraftModel : NSObject

@property NSString *Name;
@property NSString *Type;
@property NSString *Website;
@property NSString *Manufacturer;
@property NSString *Category;

// Speed
@property double CruisingSpeed;
@property double MaxSpeed;

// Safety
@property int SafetyRating;
@property NSString *NumEmergencyExits;

// Dimensions
@property double WingSpan;
@property double WingArea;
@property double CabinLength;
@property double CabinWidth;
@property double CabinHeight;
@property double FuselageLength;
@property double FuselageWidth;
@property double FuselageHeight;

// Certification
@property BOOL EASA;
@property BOOL FAA;
@property BOOL ETOPS;
@property BOOL ShortFieldPerformance;
@property double MaxTakeoffDistance;
@property double OEW;
@property double MZFW;
@property double MLW;
@property double MTOW;
@property double MaxRange;
@property double MaxFuel;
@property double Ceiling;

@property NSString *Actuation;

-(id) initWithJSONDictionary:(NSDictionary *)dict;

@end
