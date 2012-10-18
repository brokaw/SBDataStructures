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

#import "SBDeque.h"

@interface SBDoubleNode : NSObject
@property id content;
@property (strong) SBDoubleNode *next;
@property (weak) SBDoubleNode *prev;

+ (id)nodeWithContent:(id)content;

@end

@implementation SBDoubleNode
@synthesize content = _content;
@synthesize next;
@synthesize prev;

+ (id)nodeWithContent:(id)content
{
    SBDoubleNode *node = [[[self class] alloc] init];
    if (node) {
        node.content = content;
    }
    return node;
}

@end
@interface SBDeque()

@property (strong) SBDoubleNode *head;
@property (weak) SBDoubleNode *tail;
@property (readwrite, assign) NSUInteger count;

- (void)addFirstNode:(SBDoubleNode *)node;

@end

@implementation SBDeque
@synthesize head = _head;
@synthesize tail = _tail;
@synthesize count = _count;
- (id)init
{
    if ((self = [super init])) {
        _count = 0;
    }
    return self;
}

- (void)addFirstNode:(SBDoubleNode *)node
{
    self.head = node;
    self.tail = self.head;
    self.count++;
    return;
}

- (void)addObjectAtFront:(id)obj
{
    SBDoubleNode *newNode = [SBDoubleNode nodeWithContent:obj];
    if (self.count == 0) {
        [self addFirstNode:newNode];
        return;
    }
    newNode.next = self.head;
    self.head.prev = newNode;
    self.head = newNode;
    self.count++;
}

- (void)addObjectAtEnd:(id)obj
{
    SBDoubleNode *newNode = [SBDoubleNode nodeWithContent:obj];
    if (self.count == 0) {
        [self addFirstNode:newNode];
        return;
    }
    self.tail.next = newNode;
    newNode.prev = self.tail;
    self.tail = newNode;
    self.count++;
}

- (void)removeFirstObject
{
    SBDoubleNode *oldHead = self.head;
    self.head = self.head.next;
    self.head.prev = nil;
    oldHead.next = nil;
    self.count--;
}

- (id)firstObject
{
    return self.head.content;
}

- (void)removeLastObject
{
    SBDoubleNode *oldTail = self.tail;
    self.tail = self.tail.prev;
    oldTail.prev = nil;
    self.tail.next = nil;
    self.count--;
}

- (id)lastObject
{
    return self.tail.content;
}

@end
