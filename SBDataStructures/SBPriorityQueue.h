//
//  SBNewPriorityQueue.h
//  SBDataStructures
//
//  Created by Steve Brokaw on 10/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
/** SBPriorityQueue is an Objective-C priority queue built using straight
 C arrays and custom heapify-ing code. It appears to be faster than SBBinaryHeapPriorityQueue
 by some small factor.
 */
@interface SBPriorityQueue : NSObject

/** The number of objects in the queue */
@property (readonly) NSUInteger count;

/** @name Initializing a Queue */
/**
 Initialize a new priority queue with a comparator. Depending on the comparator,
 this will be a min priority queue or a max priority queue. All objects added to
 the queue must support any operations you perform in the comparator. No run-time
 checks are done.
 
 For a minimum priority queue, your NSComparator should return NSOrderedAscending if
 obj1 < obj2.
 
 @param comparator An instance of NSComparator.
 */
- (id)initWithComparator:(NSComparator)comparator;
/** @name Accessing Queue Contents */

/*! Add an object to the queue. All objects must support whatever comparision operation you
 give the initializer above.
 @param object The object to add to the queue. Must be supported by the comparator.
 */
- (void)addObject:(id<NSObject>)object;
/** Returns the first object, or nil if the queue is empty.
 The object is removed from the queue.
 */

- (id<NSObject>)popFirstObject;
/** Returns the object at the head of the queue, or nil if the queue is empty.
 The object is left in the queue;
 */

- (id)firstObject;
/*! Removes the first object in the queue. The queue must not be empty.
 */

- (void)removeFirstObject;


@end
