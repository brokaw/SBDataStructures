//
//  SBQueue.h
//  SBDataStructures
//
//  Created by Steve Brokaw on 10/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBQueue : NSObject <NSFastEnumeration>

@property (readonly, assign) NSUInteger count;

- (id)initWithObjects:(NSArray *)objects;

- (void)addObject:(id)object;
- (id)firstObject;
- (id)popFirstObject;
- (void)removeFirstObject;

@end
