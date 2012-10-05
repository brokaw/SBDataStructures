//
//  SBUnionFind.h
//  SBDataStructures
//
//  Created by Steve Brokaw on 10/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBUnionFind : NSObject
@property (readonly) NSUInteger count;

- (id)initWithSize:(NSUInteger)size;
- (void)unionSite:(NSUInteger)site1 withSite:(NSUInteger)site2;
- (NSUInteger)idForSite:(NSUInteger)site;
- (BOOL)site:(NSUInteger)site1 isConnectedWithSite:(NSUInteger)site2;

@end
