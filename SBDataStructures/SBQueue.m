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


#import "SBQueue.h"

@interface SBSingleNode : NSObject
@property (readwrite, strong) id content;
@property (readwrite, strong) SBSingleNode *next;
@end

@implementation SBSingleNode
@synthesize next;
@synthesize content;
@end

@interface SBQueue()
@property (readwrite, strong) SBSingleNode *first;
@property (readwrite, weak) SBSingleNode *last;
@property (readwrite, assign) NSUInteger count;
@end

@implementation SBQueue
@synthesize count = _count;
@synthesize first = _first;
@synthesize last = _last;

- (id)init {
    self = [self initWithObjects:nil];
    return self;
}

- (id)initWithObjects:(NSArray *)objects
{
    if ((self = [super init])) {
        _count = 0;
        for (id obj in objects) {
            [self addObject:obj];
        }
    }
    return self;
}

- (void)addObject:(id)object
{
    if (self.count == 0) {
        self.first = [SBSingleNode new];
        self.first.content = object;
        self.last = self.first;
    } else {
        SBSingleNode *newNode = [SBSingleNode new];
        newNode.content = object;
        self.last.next = newNode;
        self.last = newNode;
    }
    self.count++;
}

- (id)firstObject
{
    return self.first.content;
}

- (id)popFirstObject
{
    id obj = self.first.content;
    [self removeFirstObject];
    self.count--;
    return obj;
}

- (void)removeFirstObject
{
    self.first = self.first.next;
}

@end
