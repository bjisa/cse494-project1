//
//  AirlineModel.m
//  FlyWhizz
//
//  Created by Amy Baldwin on 11/2/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import "AirlineModel.h"

@implementation AirlineModel

-(id) initWithJSONDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.name = dict[@"name"];
        self.acronym = dict[@"fs"];
        self.phoneNumber = dict[@"phoneNumber"];
    }
    return self;
}

@end
