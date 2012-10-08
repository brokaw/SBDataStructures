//
//  SBPriorityQueue.h
//  SBDataStructures
//
//  Created by Steve Brokaw on 9/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBBinaryHeapPriorityQueue : NSObject
/** @name Initializers */
/*! 
 Initialize a new priority queue with a comparator. Depending on the comparator,
 this will be a min priority queue or a max priority queue. All objects added to
 the queue must support any operations you perform in the comparator. No run-time 
 checks are done.
 */

- (id)initWithComparator:(NSComparator)comparator;

/** @name Accessing contents */
/*! Returns the object at the head of the queue, or nil if the queue is empty.
 The object is left in the queue;
 */
- (id)firstObject;

/*! Returns the object at the head of the queue, or nil if the queue is empty.
 The object is removed from the queue.
 */
- (id)popFirstObject;

/*! Removes the first object in the queue. The queue must not be empty.
 */
- (void)removeFirstObject;

/*! Add an object to the queue. All objects must support whatever comparision operation you
 give the initializer above. */
- (void)addObject:(id)obj;

/*! The number of objects in the queue */
- (NSInteger)count;

/*! Empty the queue */
- (void)removeAllObjects;

/*! Return all objects sorted in order.*/
- (NSArray *)allObjects;
@end
