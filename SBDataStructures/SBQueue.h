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
 A generic queue, implemented as a singly linked list. The API is restricted,
 but most operations take place in constant time with respect to the list size.
 */
@interface SBQueue : NSObject

/** @name Properties */
/** The number of objects currently in the queue */
@property (readonly) NSUInteger count;

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
