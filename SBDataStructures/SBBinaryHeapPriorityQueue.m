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



#import "SBBinaryHeapPriorityQueue.h"

@interface SBNode : NSObject

- (id)initWithContent:(id)content comparator:(NSComparator)comparator;

@property (readonly, strong) id content;
@property (readwrite, weak) NSComparator comparator;
@end

@implementation SBNode

@synthesize content = _content;
@synthesize comparator = _comparator;

- (id)initWithContent:(id)content comparator:(NSComparator)comparator {
    if ((self = [super init])) {
        _content = content;
        _comparator = comparator;
    }
    return self;
    
}

@end

const void *fretain(CFAllocatorRef allocator, const void *ptr) {
    return CFRetain(ptr);
}

void frelease(CFAllocatorRef allocator, const void *ptr) {
    CFRelease(ptr);
}

CFComparisonResult fcompare(const void *ptr1, const void *ptr2, void *info) {
    SBNode *node1 = (__bridge SBNode *)ptr1;
    SBNode *node2 = (__bridge SBNode *)ptr2;
    NSComparator comparator = [node1 comparator];
    return (CFComparisonResult) comparator(node1.content, node2.content);
}

CFBinaryHeapCallBacks callbacks = { 0, fretain, frelease, NULL, fcompare };


@interface SBBinaryHeapPriorityQueue() {
    CFBinaryHeapRef _heap;
}

@property (readonly, copy) NSComparator comparator;

@end

@implementation SBBinaryHeapPriorityQueue
@synthesize comparator = _comparator;

- (id)initWithComparator:(NSComparator)comparator {
    if ((self = [super init])){
        _heap = CFBinaryHeapCreate(kCFAllocatorDefault, 0, &callbacks, NULL);
        _comparator = comparator;
    }
    return self;
}

- (NSUInteger)count {
    CFIndex c = CFBinaryHeapGetCount(_heap);
    NSAssert(c >= 0, @"Invalid heap count: %ld", c);
    return (NSUInteger)c;
}

- (void)addObject:(id)obj {
    NSAssert(obj != nil, @"Attept to insert nil object into priority queue.");
    NSAssert(self.comparator != NULL, @"Null comparator in priority queue.");
    SBNode *node = [[SBNode alloc] initWithContent:obj comparator:self.comparator];
    node.comparator = self.comparator;
    CFBinaryHeapAddValue(_heap, (__bridge_retained void *)node);
}

- (id)popFirstObject {
    CFTypeRef cfNode = NULL;
    Boolean success = CFBinaryHeapGetMinimumIfPresent(_heap, (const void **)&cfNode);
    if (success) {
        SBNode *node = (__bridge SBNode*)cfNode;
        CFTypeRef content = (__bridge CFTypeRef)(node.content);
        [self removeFirstObject];
        return (__bridge_transfer id) content;
    } else {
        return nil;
    }
}

- (void)removeFirstObject
{
    CFIndex count = CFBinaryHeapGetCount(_heap);
    NSAssert(count > 0, @"Attemt to remove from empty queue");
    CFBinaryHeapRemoveMinimumValue(_heap);
}

- (id)firstObject {
    //SBNode *node;
    CFTypeRef cfNode = NULL;
    Boolean res = CFBinaryHeapGetMinimumIfPresent(_heap, (const void **)&cfNode);
    if (res) {
        SBNode *node = (__bridge SBNode *) cfNode;
        return node.content;
    } else {
        return nil;
    }
}

- (NSArray *)allObjects {

    CFIndex size = CFBinaryHeapGetCount(_heap);
    CFTypeRef *cfValues = malloc(size * sizeof(CFTypeRef));
    CFBinaryHeapGetValues(_heap, (const void **)cfValues);
    CFArrayRef nodes = CFArrayCreate(kCFAllocatorDefault, cfValues, size, &kCFTypeArrayCallBacks);
    CFIndex count = CFArrayGetCount(nodes);
    CFMutableArrayRef objects = CFArrayCreateMutable(kCFAllocatorDefault, count, &kCFTypeArrayCallBacks);
    for (CFIndex i = 0; i < count; i++) {
        SBNode *node = (__bridge_transfer SBNode *)CFArrayGetValueAtIndex(nodes, i);
        id object = node.content;
        CFArrayAppendValue(objects, (__bridge_retained CFTypeRef) object);
    }
    free(cfValues); 
    return (__bridge_transfer NSMutableArray *) objects;
}


- (void)removeAllObjects {
    CFBinaryHeapRemoveAllValues(_heap);
}

- (void)dealloc {
    CFRelease(_heap);
}

@end
