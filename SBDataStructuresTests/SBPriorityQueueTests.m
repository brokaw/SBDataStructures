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

#import "SBPriorityQueueTests.h"
#import "SBDataStructures.h"

@implementation SBPriorityQueueTests

- (void)setUp
{
    [super setUp];
    if (!randomNumbers) {
        randomNumbers = [NSMutableArray new];
        for (int i = 0; i < 64000; i++) {
            [randomNumbers addObject:[NSNumber numberWithUnsignedInt:arc4random_uniform(UINT32_MAX)]];
        }

    }
    // Set-up code here.
    numberComparator = ^NSComparisonResult(id obj1, id obj2) {
        if ([(NSNumber *)obj1 intValue] < [(NSNumber *)obj2 intValue]) {
            return NSOrderedAscending;
        } else if ([(NSNumber *)obj1 intValue] > [(NSNumber *)obj2 intValue]) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    };

}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testQueue
{
    SBQueue *q = [SBQueue new];
    for (int i = 0; i < 1000; i++) {
        [q addObject:[randomNumbers objectAtIndex:i]];
    }
    for (int i = 0; i < 1000; i++) {
        id num = [q firstObject];
        STAssertEquals([randomNumbers objectAtIndex:i], num, @"Object in queue should equal object %i from array (%@)", i, [randomNumbers objectAtIndex:i]);
        id popped = [q popFirstObject];
        STAssertEquals(num, popped, @"Peeked object %@ doesn't match popped object %@.", num, popped);
    }
}


#pragma mark Order Tests
- (void)testBinaryHeapPriorityQueueOrder
{
    [self queueOrderTestsForQueueType:@"SBBinaryHeapPriorityQueue"];
}

- (void)testPriorityQueueOrder
{
    [self queueOrderTestsForQueueType:@"SBPriorityQueue"];
}

- (void)queueOrderTestsForQueueType:(NSString *)queueType
{
    
    id q = [[NSClassFromString(queueType) alloc] initWithComparator:numberComparator];
    
    for (NSUInteger i = 0; i < 100; i++) {
        NSNumber *n = [NSNumber numberWithUnsignedInteger:i];
        STAssertEquals(i, [q count], @"Queue count is off");
        [q addObject:n];
    }
    
    NSNumber *previous = (NSNumber *)[q popFirstObject];
    for (NSUInteger i = 99; i > 0; i--) {
        STAssertEquals(i, [q count], @"Queue count is off. Subsequent tests may be invalid");
        NSNumber *current = (NSNumber *)[q popFirstObject];
        STAssertNotNil(current, @"Queue popped nil object");
        STAssertTrue([current intValue] > [previous intValue], @"Heap item out of order.");
        STAssertTrue([current intValue] == [previous intValue] + 1, @"Heap item out of order.");
        previous = current;
        NSUInteger count = [q count];
        STAssertEquals([q firstObject], [q firstObject], @"Adjacent peekHead calls return different objects");
        STAssertEquals(count, [q count], @"peekHead changes queue size");
    }

    
}

#pragma mark Run Time Tests
- (void)testPriorityQueueRunTime {
    [self runTimeForQueueType:@"SBPriorityQueue"];
}
- (void)testBinaryHeapPriorityQueueRunTime {
    [self runTimeForQueueType:@"SBBinaryHeapPriorityQueue"];
}


- (void)runTimeForQueueType:(NSString *)queueType
{
    
    id q = [[NSClassFromString(queueType) alloc] initWithComparator:numberComparator];
    
    int samples[] = { 4000, 8000, 16000, 32000, 64000 };
    NSTimeInterval previousBuild = 0;
    NSTimeInterval previousPop = 0;
    NSTimeInterval time;
    
    printf("=====================\n%s Timing\n=====================\n", [queueType UTF8String]);
    previousBuild = 0;
    previousPop = 0;
    for (int i = 0; i < 5; i++) {
        //SBPriorityQueue *q = [[SBPriorityQueue alloc] initWithComparator:numberComparator];
        
        //printf("N = %i\n", samples[i]);
        NSDate *date = [NSDate date];
        for (int j = 0; j < samples[i]; j++) {
            [q addObject:[randomNumbers objectAtIndex:j]];
        }
        for (int j =0; j < samples[i]; j++) {
            [q popFirstObject];
        }
        time = -[date timeIntervalSinceNow];
        
        printf("T(%i) = %f\tdT = %f\tratio = %f\n", samples[i], time, time - previousPop, (previousPop == 0 ? 0 : (time  / previousPop)));
        previousPop = time;
        [q removeAllObjects];       
    }
    
}

- (void)priorityQueuePushPopTimeWithQueueType:(NSString *)queueType
{
    
    id q = [[NSClassFromString(queueType) alloc] initWithComparator:numberComparator];
    
    //Fill the queue with 1000 items
    for (int i = 0; i < 1000; i++) {
        [q addObject:[randomNumbers objectAtIndex:i]];
    }
    NSDate *date = [NSDate date];
    for (int i = 1; i < 21; i++) {        
        int start = 1000 * i;
        for (int j = 0; j < 1000; j++) {
            [q addObject:[randomNumbers objectAtIndex:start + j]];
        }
        for (int j = 0; j < 1000; j++) {
            [q popFirstObject];
        }
    }
    NSTimeInterval time = -[date timeIntervalSinceNow];
    printf("%s Alternating add/remove: %f\n", [queueType UTF8String], time);
    


}
- (void)testPriorityQueuePushPopRunTime
{
    [self priorityQueuePushPopTimeWithQueueType:@"SBPriorityQueue"];
}

- (void)testBinaryHeapPriorityQueuePushPopRunTime
{
    [self priorityQueuePushPopTimeWithQueueType:@"SBBinaryHeapPriorityQueue"];
}
- (void)testAllObjects
{
    SBBinaryHeapPriorityQueue *hq = [[SBBinaryHeapPriorityQueue alloc] initWithComparator:numberComparator];
    
    for (int i = 0; i < 1000; i++) {
        [hq addObject:[randomNumbers objectAtIndex:i]];
    }
    NSArray *objects = [hq allObjects];
    NSNumber *previous = nil;
    for (NSNumber *n in objects) {
        if (previous) {
            STAssertTrue([previous intValue] < [n intValue], @"");
        }
    }
}

- (void)testRemoveAllObjects
{

    SBPriorityQueue *q = [[SBPriorityQueue alloc] initWithComparator:numberComparator];
    for (NSUInteger i = 0; i < 128; i++) {
        [q addObject:[randomNumbers objectAtIndex:i]];
    }
    [q removeAllObjects];
    STAssertEquals([q count], (NSUInteger)0, @"Count should equal 0 after removing all objects");
    //STAssertThrows([q removeFirstObject], @"Should throw exception on removing object from empty queue");
    for (NSUInteger i = 0; i < 128; i++) {
        [q addObject:[randomNumbers objectAtIndex:i]];
    }
    [q removeAllObjects];
    STAssertEquals(q.count, (NSUInteger)0, @"Count should equal 0 after removing all objects");
    
}

- (void)testEnumeration {

    SBPriorityQueue *pq = [[SBPriorityQueue alloc] initWithComparator:numberComparator];
    int testCount = 100;
    for (int i = 0; i < testCount; i++) {
        [pq addObject:[randomNumbers objectAtIndex:i]];
    }
    int count = 0;
    for (NSNumber *n in pq) {
        count++;
    }
    STAssertEquals(testCount, count, @"Enumeration did not return right number of objects from queue");
}
@end
