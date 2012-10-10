//
//  SBNewPriorityQueue.m
//  SBDataStructures
//
//  Created by Steve Brokaw on 10/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBPriorityQueue.h"

#define MIN_SIZE 1024

#define LEFT(idx) ((idx) * 2)
#define RIGHT(idx) (((idx) * 2) + 1)
#define PARENT(idx) ((idx) / 2)

void swap(__strong id array[], NSUInteger idx1, NSUInteger idx2) {
    __strong id tmp = array[idx1];
    array[idx1] = array[idx2];
    array[idx2] = tmp;
}

__strong id * resized(id const array[], NSUInteger newSize, NSUInteger contentSize) {
    __strong id *newHeap = (__strong id *)calloc(newSize, sizeof(id));
    for (int i = 0; i < contentSize + 1; i++) {
        newHeap[i] = array[i];
    }
    return newHeap;
}

void sink(__strong id array[], NSUInteger idx, NSUInteger size, NSComparator comparator) {
    NSUInteger child;
    while (LEFT(idx) <= (size)) {
        //First choose which child to compare with the parent
        child = LEFT(idx);
        if ((RIGHT(idx) <= size) && //if there is a right child...
            (comparator(array[LEFT(idx)], array[RIGHT(idx)]) == NSOrderedDescending)) {
            child = RIGHT(idx); //...choose the smaller of the two children.
        }
        //Next compare the parent with the smaller of the two children.
        if (comparator(array[child], array[idx]) == NSOrderedDescending) { 
            break; //If the parent is smaller, stop descending...
        } else {
            swap(array, child, idx); //...else swap the parent and child...
            idx = child; //...and keep descending from the point of the child
        }
    }
}

void swim(__strong id heap[], NSUInteger idx, NSComparator comparator) {
    while (PARENT(idx) >= 1) {
        NSComparisonResult res = comparator(heap[idx], heap[PARENT(idx)]);
        if (res != NSOrderedAscending) { break; }
        swap(heap, idx, PARENT(idx));
        idx = PARENT(idx);
    }

}

@interface SBPriorityQueue() {
    __strong id *_heap;
    dispatch_queue_t heap_q;
}
@property NSUInteger arraySize;
@property NSUInteger contentSize; //should be guarded by the serial dispatch queue
@property (readonly, copy) NSComparator comparator;

@end

@implementation SBPriorityQueue
@synthesize arraySize;
@synthesize contentSize;

@synthesize comparator = _comparator;

- (id)initWithComparator:(NSComparator)comparator {
    if ((self = [super init])) {
        NSAssert(comparator != NULL, @"Comparator must not be NULL");
        _heap = (__strong id *)calloc(MIN_SIZE + 1, sizeof(id));
        _heap[0] = nil;
        arraySize = MIN_SIZE;
        contentSize = 0;
        _comparator = comparator;
        heap_q = dispatch_queue_create("com.github.brokaw.priorityqueue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)addObject:(id<NSObject>)object {
    if (self.count == arraySize - 1) {
        dispatch_async(heap_q, ^{
            //NSLog(@"Count: %i Arraysize: %i", contentSize, arraySize);
            __strong id *tmp = resized(_heap, arraySize * 2, contentSize);
            for (int i = 0; i < contentSize; i++) {
                _heap[i] = nil;
            }
            free(_heap);
            _heap = tmp;
            arraySize *= 2;
        });
    }
    dispatch_async(heap_q, ^{
        _heap[++contentSize] = object;
        swim(_heap, contentSize, _comparator);
    });
}

- (id<NSObject>)popFirstObject {
    NSAssert(contentSize > 0, @"Attempt to pop from an empty queue");
    id head = [self firstObject];
    [self removeFirstObject];
    return head;
}

- (id)firstObject {
    __block id obj;
    dispatch_sync(heap_q, ^{
        obj = _heap[1];
    });
    return obj;
}

- (void)removeFirstObject
{
    NSAssert(contentSize > 0, @"Attempt to pop from an empty queue");

    if ((self.count < arraySize / 4) && (arraySize > MIN_SIZE)) {
        dispatch_async(heap_q, ^{
            __strong id *tmp = resized(_heap, arraySize / 2, contentSize);
            for (int i = 0; i < contentSize; i++) {
                _heap[i] = nil;
            }
            free(_heap);
            _heap = tmp;
            arraySize /= 2;
        });
    }
    dispatch_async(heap_q, ^{
        _heap[1] = _heap[contentSize];
        _heap[contentSize] = nil;
        contentSize--;
        sink(_heap, 1, contentSize, _comparator);
    });
    
}

- (NSUInteger)count { 
    __block NSUInteger c;
    dispatch_sync(heap_q, ^{
        c = contentSize;
    });
    return c;
}

- (void)removeAllObjects
{
    dispatch_apply(self.count, heap_q, ^(size_t idx) {
        _heap[idx] = nil;
        contentSize = 0;
    });
}

- (void)dealloc {
    dispatch_apply(self.count, heap_q, ^(size_t idx) {
            _heap[idx] = nil;
    });
    free(_heap);
    dispatch_release(heap_q);
}

@end
