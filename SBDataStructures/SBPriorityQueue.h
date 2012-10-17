/*
 Copyright (c) 2012 Steven Brokaw
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import <Foundation/Foundation.h>

/** SBPriorityQueue is an Objective-C priority queue built using straight
 C arrays and custom functions for heapify-ing the objects in the queue.
 
 The store for the queue is a standard C array which is resized when enough
 objects are added or removed. 
 
 Iterating through an SBPriorityQueue with fast enumeration (`for (id obj in q)` syntax)
 returns the objects in heap order, not in sorted order.
 */
@interface SBPriorityQueue : NSObject <NSFastEnumeration>

/** @name Properties */

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
 give the initializer initWithComparator:.
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

/** Removes the first object in the queue. The queue must not be empty. If the queue is empty,
 and exception is thrown.
*/
- (void)removeFirstObject;

/** Empty the queue */
- (void)removeAllObjects;

@end
