//
//  SBQueue.h
//  SBDataStructures
//
//  Created by Steve Brokaw on 10/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 A generic queue, implemented as a singly linked list. The API is restricted,
 but most operations take place in constant time with respect to the list size.
 */

@interface SBQueue : NSObject

/** The number of objects currently in the queue */
@property (readonly, assign) NSUInteger count;

/** @name Initializing a Queue */
/**
 Create a queue with the objects in the array. After initialization, the object at
 index 0 will be the firstObject.
 
 Initializion time is O(_n_) with respect to the size of the array.
 */
- (id)initWithObjects:(NSArray *)objects;

/** @name Accessing Queue Contents */
/*! Add an object to the end of the queue.
 
 Adding objects is done in O(1) time.
 
 @param objects The object to add to the queue.
 */
- (void)addObject:(id)object;

/*! Returns, but does not remove, the object at the front of the queue.
 
 Returning objects is done in O(1) time.
 
 @param objects The object to add to the queue.
 */
- (id)firstObject;

/** Removes the object at the front of the queue.
 
 Order of growth is O(1).
 */
- (void)removeFirstObject;

/*! Returns the object at the front of the queue, and removes it
 from the front of the queue. This is a convenience method
 composed of addObject: and removeFirstObject.
 
 Order of growth is O(1).
 
 @param objects The object to add to the queue.
 
 @returns The object, or nil if the queue is empty.
 */
- (id)popFirstObject;


@end
