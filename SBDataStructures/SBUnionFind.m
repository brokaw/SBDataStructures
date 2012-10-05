//
//  SBUnionFind.m
//  SBDataStructures
//
//  Created by Steve Brokaw on 10/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "SBUnionFind.h"
@interface SBUnionFind() {
    NSUInteger *_sites;
    NSUInteger *_sizes;
    NSUInteger _count;
    NSUInteger _arraySize;
}

@end

@implementation SBUnionFind

- (id)initWithSize:(NSUInteger)size
{
    if ((self = [super init])) {
        _sites = malloc(sizeof(NSUInteger) * size);
        _sizes = malloc(sizeof(NSUInteger) * size);
        for (NSUInteger i = 0; i < size; i++) {
            _sites[i] = i;
            _sizes[i] = 0;
            _count = size;
            _arraySize = size;
        }
    }
    return self;
}

- (NSUInteger)idForSite:(NSUInteger)site
{
    NSUInteger siteId = _sites[site];
    while (site != siteId) {
        site = siteId;
        siteId = _sites[site];
    }
    return siteId;
}

- (void)unionSite:(NSUInteger)site1 withSite:(NSUInteger)site2
{
    NSUInteger id1 = [self idForSite:site1];
    NSUInteger id2 = [self idForSite:site2];
    if (id1 == id2) { return; }
    
    if (_sizes[site1] > _sizes[site2]) { 
        _sites[id2] = id1; 
        _sizes[site1]++;
    } else {
        _sites[id1] = id2; 
        _sizes[site2]++;
    }
    _count--;
}

- (BOOL)site:(NSUInteger)site1 isConnectedWithSite:(NSUInteger)site2
{
    return [self idForSite:site1] == [self idForSite:site2];
}

- (NSUInteger)count { return _count; };

- (NSString *)description {
    NSMutableString *desc = [[super description] mutableCopy];
    [desc appendFormat:@"Site count = %i", _count];
    for (int i = 0; i < _arraySize; i++) {
        [desc appendFormat:@"\n%i: [id: %i, parent: %i, size: %i]", i, [self idForSite:i], _sites[i], _sizes[i]];
    }
    return desc;
}

- (void)dealloc
{
    free(_sites);
    free(_sizes);
}
@end
