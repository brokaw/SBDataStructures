//
//  SBPriorityQueue.h
//  SBDataStructures
//
//  Created by Steve Brokaw on 9/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 This class provides an Objective-C wrapper around CFBinaryHeap. The main benefit over using
 CFBinaryHeap directly is that you don't have to write C functions to retain, release, and 
 compare objects. Because you can define the comparator at initialization time, it is easy
 to create mutiple queues with different comparators.
 
 Depending on how you have defined your comparator, the firstObject will
 be either the minimum or maximum.
 
 Method naming is designed to be congruent with methods in NSMutableArray and CFBinaryHeap.
 */

@interface SBBinaryHeapPriorityQueue : NSObject

/** @name Initializing a Queue */

/*! 
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

/*! Returns the object at the head of the queue, or nil if the queue is empty.
 The object is left in the queue;
 */
- (id)firstObject;

/*! Returns the first object, or nil if the queue is empty.
 The object is removed from the queue.
 */
- (id)popFirstObject;

/*! Removes the first object in the queue. The queue must not be empty.
 */
- (void)removeFirstObject;

/*! Add an object to the queue. All objects must support whatever comparision operation you
 give the initializer above. 
 @param object The object to add to the queue. Must be supported by the comparator.
 */
- (void)addObject:(id)object;

/*! Empty the queue */
- (void)removeAllObjects;

/*! Return all objects sorted in order.
 @returns A sorted NSArray of the queue contents.
 */
- (NSArray *)allObjects;

/*! The number of objects in the queue 
 @returns The number of objects currently in the queue.
 */
- (NSInteger)count;


@end
