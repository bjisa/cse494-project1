//
//  AircraftObject.m
//  FlyWhizz
//
//  Created by Ben Jisa on 11/2/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import "AircraftModel.h"

@implementation AircraftModel

-(id) initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init])
    {
        self.Name = dict[@"TypeName"];
        self.Type = dict[@"Type"];
        self.Website = dict[@"Website"];
        self.Manufacturer = dict[@"Manufacturer"];
        self.Category = dict[@"Category"];
        
        NSDictionary *speed = dict[@"Speed"];
        if (speed)
        {
            self.CruisingSpeed = [speed[@"Cruising"] doubleValue];
            self.MaxSpeed = [speed[@"Max"] doubleValue];
        }
        
        NSDictionary *safety = dict[@"Safety"];
        if (safety)
        {
            self.SafetyRating = [safety[@"Rating"] intValue];
            self.NumEmergencyExits = safety[@"NumEmergencyExits"];
        }
        
        NSDictionary *dimensions = dict[@"Dimensions"];
        if (dimensions)
        {
            NSDictionary *wings = dimensions[@"Wings"];
            if (wings)
            {
                self.WingSpan = [wings[@"Span"] doubleValue];
                self.WingArea = [wings[@"Area"] doubleValue];
            }
            
            NSDictionary *cabin = dimensions[@"Cabin"];
            if (cabin)
            {
                self.CabinLength = [cabin[@"Length"] doubleValue];
                self.CabinWidth = [cabin[@"Width"] doubleValue];
                self.CabinHeight = [cabin[@"Height"] doubleValue];
            }
            
            NSDictionary *fuselage = dimensions[@"Fuselage"];
            if (fuselage)
            {
                self.FuselageLength = [fuselage[@"Length"] doubleValue];
                self.FuselageWidth = [fuselage[@"Width"] doubleValue];
                self.FuselageHeight = [fuselage[@"Height"] doubleValue];
            }
        }
        
        NSDictionary *certification = dict[@"Certification"];
        if (certification)
        {
            // Certification
            self.FAA = [certification[@"FAA"] boolValue];
            self.EASA = [certification[@"EASA"] boolValue];
            self.ETOPS = [certification[@"ETOPS"] boolValue];
            self.ShortFieldPerformance = [certification[@"ShortFieldPerformance"] boolValue];
            
            // Weight Limits
            self.OEW = [certification[@"OEW"] doubleValue];
            self.MZFW = [certification[@"MZFW"] doubleValue];
            self.MLW = [certification[@"MLW"] doubleValue];
            self.MTOW = [certification[@"MTOW"] doubleValue];
            
            // Other Data
            self.MaxTakeoffDistance = [certification[@"MaxTakeoffDistanceMTOW"] doubleValue];
            self.MaxRange = [certification[@"MaxRange"] doubleValue];
            self.MaxFuel = [certification[@"MaxFuel"] doubleValue];
            self.Ceiling = [certification[@"Ceiling"] doubleValue];
        }
        
        self.Actuation = dict[@"Actuation"];
        
    }
    return self;
}

@end
