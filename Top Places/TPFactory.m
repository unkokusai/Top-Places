//
//  TPFactory.m
//  Top Places
//
//  Created by Yasuyuki Pham on 5/15/14.
//  Copyright (c) 2014 Code Coalition. All rights reserved.
//

#import "TPFactory.h"
#import "FlickrFetcher.h"

@implementation TPFactory

+(NSDictionary *)topPlacesURLRequest
{
    NSData *data = [NSData dataWithContentsOfURL:[FlickrFetcher URLforTopPlaces]];
    NSDictionary *topPlaces;
    NSError *error = nil;
    if (data) {
        topPlaces = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    } else {
        NSLog(@"Top Places Error:\n");
        NSLog(@"%@", error);
    }
    return topPlaces;
}

@end
