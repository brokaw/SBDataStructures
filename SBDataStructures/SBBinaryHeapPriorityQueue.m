//
//  SBPriorityQueue.m
//  SBDataStructures
//
//  Created by Steve Brokaw on 9/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "SBBinaryHeapPriorityQueue.h"

@interface SBNode : NSObject

- (id)initWithContent:(id)content comparator:(NSComparator)comparator;

@property (readonly, retain) id content;
@property (readwrite, assign) NSComparator comparator;
@end

const void *fretain(CFAllocatorRef allocator, const void *ptr) {
    return (void *)[(id<NSObject>)ptr retain];
}

void frelease(CFAllocatorRef allocator, const void *ptr) {
    [(id<NSObject>)ptr release];
}

CFComparisonResult fcompare(const void *ptr1, const void *ptr2, void *info) {
    SBNode *node1 = (SBNode *)ptr1;
    SBNode *node2 = (SBNode *)ptr2;
    NSComparator comparator = [node1 comparator];
    return comparator(node1.content, node2.content);
}

CFBinaryHeapCallBacks callbacks = { 0, fretain, frelease, NULL, fcompare };

@implementation SBNode

@synthesize content = _content;
@synthesize comparator = _comparator;

- (id)initWithContent:(id)content comparator:(NSComparator)comparator {
    if ((self = [super init])) {
        _content = [content retain];
        _comparator = comparator;
    }
    return self;

}

- (void)dealloc {
    [_content release];
    [super dealloc];
}

@end

@interface SBBinaryHeapPriorityQueue() {
    CFBinaryHeapRef _heap;
}

@property (readonly, copy) NSComparator comparator;

@end

@implementation SBBinaryHeapPriorityQueue
@synthesize comparator = _comparator;

- (id)initWithComparator:(NSComparator)comparator {
    if ((self = [super init])){
        _heap = CFBinaryHeapCreate(kCFAllocatorDefault, 0, &callbacks, NULL);
        _comparator = comparator;
    }
    return self;
}

- (NSInteger)count {
    return CFBinaryHeapGetCount(_heap);
}

- (void)addObject:(id)obj {
    NSAssert(obj != nil, @"Attept to insert nil object into priority queue.");
    NSAssert(self.comparator != NULL, @"Null comparator in priority queue.");
    SBNode *node = [[SBNode alloc] initWithContent:obj comparator:self.comparator];
    node.comparator = self.comparator;
    CFBinaryHeapAddValue(_heap, (void *)node);
    [node release];
}

- (id)removeHead {
    SBNode *node = nil;
    Boolean res = CFBinaryHeapGetMinimumIfPresent(_heap, (const void **)&node);
    if (res) {
        id content = [node.content retain];
        CFBinaryHeapRemoveMinimumValue(_heap);
        return [content autorelease];
    } else {
        return nil;
    }
}

- (id)objectAtHead {
    SBNode *node;
    Boolean res = CFBinaryHeapGetMinimumIfPresent(_heap, (const void **)&node);
    if (res) {
        return node.content;
    } else {
        return nil;
    }    
}

- (NSArray *)allObjects {
    id *values;
    CFIndex size = CFBinaryHeapGetCount(_heap);
    values = (id *)malloc(sizeof(id) * size);
    CFBinaryHeapGetValues(_heap, (const void **)values);
    NSArray *objects = [[NSArray alloc] initWithObjects:values count:size];
    return [objects autorelease];
}


- (void)removeAllObjects {
    CFBinaryHeapRemoveAllValues(_heap);
}

- (void)dealloc {
    CFRelease(_heap);
    [super dealloc];
}

@end
