//
//  SBPriorityQueue.h
//  SBDataStructures
//
//  Created by Steve Brokaw on 9/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBBinaryHeapPriorityQueue : NSObject

/*! 
 Initialize a new priority queue with a comparator. Depending on the comparator,
 this will be a min priority queue or a max priority queue. All objects added to
 the queue must support any operations you perform in the comparator. No run-time 
 checks are done.
 */

- (id)initWithComparator:(NSComparator)comparator;

/*! Returns the object at the head of the queue, or nil if the queue is empty.
 The object is left in the queue;
 */
- (id)objectAtHead;

/*! Returns the object at the head of the queue, or nil if the queue is empty.
 The object is removed from the queue.
 */
- (id)removeHead;

/*! Add an object to the queue. All objects must support whatever comparision operation you
 give the initializer above. */
- (void)addObject:(id)obj;

/*! The number of objects in the queue */
- (NSInteger)count;

/*! Empty the queue */
- (void)removeAllObjects;

/*! */
- (NSArray *)allObjects;
@end
