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

/**
 This class provides an Objective-C wrapper around CFBinaryHeap. The main benefit over using
 CFBinaryHeap directly is that you don't have to write C functions to retain, release, and 
 compare objects. Because you can define the comparator at initialization time, it is easy
 to create mutiple queue instances with different comparators.
 
 Depending on how you have defined your comparator, the firstObject will
 be either the minimum or maximum.
 
 Method naming is designed to be similar to methods in other Cocoa classes such as
 NSMutableArray and CFBinaryHeap.
 */

@interface SBBinaryHeapPriorityQueue : NSObject

/** @name Properties */
/** The number of objects in the queue. */
@property (readonly) NSUInteger count;

/** @name Initializing a Queue */

/*! 
 Initialize a new priority queue with a comparator. Depending on the comparator,
 this will be a min priority queue or a max priority queue. All objects added to
 the queue must support any operations you perform in the comparator. No run-time 
 checks are done.
 
 For a minimum priority queue, your NSComparator should return NSOrderedAscending if
 obj1 < obj2.
 
 @param comparator An instance of NSComparator used to order the objects in the queue.
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



@end
