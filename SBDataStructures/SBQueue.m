//
//  SBQueue.m
//  SBDataStructures
//
//  Created by Steve Brokaw on 10/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBQueue.h"

@interface SBSingleNode : NSObject
@property (readwrite, strong) id content;
@property (readwrite, strong) SBSingleNode *next;
@end

@implementation SBSingleNode
@synthesize next;
@synthesize content;
@end

@interface SBQueue()
@property (readwrite, strong) SBSingleNode *first;
@property (readwrite, weak) SBSingleNode *last;
@property (readwrite, assign) NSUInteger count;
@end

@implementation SBQueue
@synthesize count = _count;
@synthesize first = _first;
@synthesize last = _last;

- (id)init {
    self = [self initWithObjects:nil];
    return self;
}

- (id)initWithObjects:(NSArray *)objects
{
    if ((self = [super init])) {
        _count = 0;
        for (id obj in objects) {
            [self addObject:obj];
        }
    }
    return self;
}

- (void)addObject:(id)object
{
    if (self.count == 0) {
        self.first = [SBSingleNode new];
        self.first.content = object;
        self.last = self.first;
    } else {
        SBSingleNode *newNode = [SBSingleNode new];
        newNode.content = object;
        self.last.next = newNode;
        self.last = newNode;
    }
    self.count++;
}

- (id)firstObject
{
    return self.first.content;
}

- (id)popFirstObject
{
    id obj = self.first.content;
    [self removeFirstObject];
    self.count--;
    return obj;
}

- (void)removeFirstObject
{
    self.first = self.first.next;
}

@end
