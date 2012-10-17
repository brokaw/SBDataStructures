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


#import "SBPriorityQueue.h"

#define MIN_SIZE 16

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
    NSUInteger arraySize;
    NSUInteger contentSize;
}


@property (readonly, copy) NSComparator comparator;

@end

@implementation SBPriorityQueue
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
    dispatch_async(heap_q, ^{
        if (contentSize == arraySize - 1) { //-1 because content size isn't a true array index because I ignore _heap[0]
            __strong id *tmp = resized(_heap, arraySize * 2, contentSize);
            for (int i = 0; i < contentSize; i++) {
                _heap[i] = nil;
            }
            free(_heap);
            _heap = tmp;
            arraySize *= 2;
        }
        _heap[++contentSize] = object;
        swim(_heap, contentSize, _comparator);
    });
}

- (id<NSObject>)popFirstObject {
    if (self.count == 0) return nil;
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
    dispatch_async(heap_q, ^{
        if (contentSize == 0) {
            @throw [NSException exceptionWithName:@"Index Out of Bounds Exception" reason:@"Tried to remove an object from an empty queue." userInfo:nil];
        }

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
    dispatch_async(heap_q, ^{

        __strong id *newHeap = (__strong id *)calloc(MIN_SIZE, sizeof(id));
        for (int i = 0; i < contentSize; i++) {
            _heap[i] = nil;
        }
        free(_heap);
        contentSize = 0;
        arraySize = MIN_SIZE;
        _heap = newHeap;
    });
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained *)stackbuf count:(NSUInteger)len {
    if (state->state == 0) {
        __block NSUInteger count;
        dispatch_sync(heap_q, ^{
            state->mutationsPtr = &contentSize;
            count = contentSize;
            state->itemsPtr = (__unsafe_unretained id *)(void *)&_heap[1]; //ignore first item
            state->state = 1;
        });
        return count;
    } else {
        return 0;
    }
}


- (void)dealloc {
    dispatch_apply(self.count, heap_q, ^(size_t idx) {
            _heap[idx] = nil;
    });
    free(_heap);
    dispatch_release(heap_q);
}

@end
