//
//  SBNewPriorityQueue.m
//  SBDataStructures
//
//  Created by Steve Brokaw on 10/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBPriorityQueue.h"

#define MIN_SIZE 4096

#define LEFT(idx) ((idx) * 2)
#define RIGHT(idx) (((idx) * 2) + 1)
#define PARENT(idx) ((idx) / 2)

void swap(__strong id array[], NSUInteger idx1, NSUInteger idx2) {
    id tmp = array[idx1];
    array[idx1] = array[idx2];
    array[idx2] = tmp;
}

__strong id * resized(id const array[], NSUInteger newSize, NSUInteger contentSize) {
    id __strong *newHeap = (id __strong *)calloc(newSize, sizeof(id));
    for (int i = 0; i < contentSize + 1; i++) {
        newHeap[i] = array[i];
    }
    return newHeap;
}

void sink(__strong id array[], NSUInteger idx, NSUInteger size, NSComparator comparator) {
    NSUInteger child;
    while (LEFT(idx) <= (size)) {
        //first choose which child to compare with the parent
        child = LEFT(idx);
        if ((RIGHT(idx) <= size + 1) && //if there is a right child
            (comparator(array[LEFT(idx)], array[RIGHT(idx)]) == NSOrderedDescending)) {
            child = RIGHT(idx); //choose the smaller of the two children.
        }
        //next compare the parent with the smaller of the two children
        if (comparator(array[child], array[idx]) == NSOrderedDescending) { 
            break; //if the parent is smaller, stop descending
        } else {
            swap(array, child, idx); //else swap the parent and child and keep descending
            idx = child;
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
@property NSUInteger contentSize;

@property (readonly, copy) NSComparator comparator;

@end

@implementation SBPriorityQueue
@synthesize arraySize;
@synthesize contentSize;

@synthesize comparator;

- (id)initWithComparator:(NSComparator)cmp {
    if ((self = [super init])) {
        NSAssert(cmp != NULL, @"Comparator must not be NULL");
        _heap = (__strong id *)calloc(MIN_SIZE + 1, sizeof(id));
        _heap[0] = nil;
        arraySize = MIN_SIZE;
        contentSize = 0;
        comparator = cmp;
        heap_q = dispatch_queue_create("com.github.brokaw.priorityqueue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)addObject:(id<NSObject>)obj {
    //[obj retain];
    CFTypeRef cfObj = (__bridge_retained CFTypeRef)obj;
    CFRetain(cfObj);
    if (contentSize > arraySize / 2) {
        __strong id *tmp = resized(_heap, arraySize * 2, contentSize);
        for (int i = 0; i < self.count; i++) {
            _heap[i] = nil;
        }
        free(_heap);
        _heap = tmp;
        arraySize *= 2;
    }
    _heap[++(self.contentSize)] = obj;
    swim(_heap, contentSize, comparator);
}

- (id<NSObject>)popFirstObject {
    NSAssert(contentSize > 0, @"Attempt to pop from an empty queue");
    id head = _heap[1];
//    id<NSObject> head = _heap[1];
//    if ((contentSize < arraySize / 4) && (arraySize > MIN_SIZE)) {
//        id __strong *tmp = resized(_heap, arraySize / 2, contentSize);
//        free(_heap);
//        _heap = tmp;
//        arraySize /= 2;
//    }
//    _heap[1] = _heap[contentSize--];
//    sink(_heap, 1, contentSize, comparator);
    [self removeFirstObject];
    return head;
}

- (id)firstObject {
    return _heap[1];
}

- (void)removeFirstObject
{
    NSAssert(contentSize > 0, @"Attempt to pop from an empty queue");

    if ((contentSize < arraySize / 4) && (arraySize > MIN_SIZE)) {
        __strong id *tmp = resized(_heap, arraySize / 2, contentSize);
        for (int i = 0; i < contentSize; i++) {
            _heap[i] = nil;
        }
        free(_heap);
        _heap = tmp;
        arraySize /= 2;
    }
    _heap[1] = _heap[contentSize];
    _heap[contentSize] = nil;
    contentSize--;
    sink(_heap, 1, contentSize, comparator);
    
}

- (NSUInteger)count { return contentSize; }

- (void)dealloc {
    dispatch_apply(contentSize, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t idx) {
        if (idx > 0) {
            _heap[idx] = nil;
        }
    });
    free(_heap);
}
@end
