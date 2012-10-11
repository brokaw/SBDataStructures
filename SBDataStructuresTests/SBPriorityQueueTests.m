//
//  SBDataStructuresTests.m
//  SBDataStructuresTests
//
//  Created by Steve Brokaw on 9/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBPriorityQueueTests.h"
#import "SBDataStructures.h"
#import "SBQueue.h"

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
}

+ (void)setUp
{

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
    NSComparator numberComparator = ^NSComparisonResult(id obj1, id obj2) {
        STAssertNotNil(obj1, @"Nil object in comparator");
        STAssertNotNil(obj2, @"Nil object in comparator");
        if ([(NSNumber *)obj1 intValue] < [(NSNumber *)obj2 intValue]) {
            return NSOrderedAscending;
        } else if ([(NSNumber *)obj1 intValue] > [(NSNumber *)obj2 intValue]) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
        
    };
    
    id q;
    if ([queueType isEqualToString:@"SBPriorityQueue"]) {
        q = [[SBPriorityQueue alloc] initWithComparator:numberComparator];
    } else if ([queueType isEqualToString:@"SBBinaryHeapPriorityQueue"]) {
        q = [[SBBinaryHeapPriorityQueue alloc] initWithComparator:numberComparator];
    } else {
        STAssertFalse(YES,@"Attempt timing for unknown queue type: %@", queueType);
    }
    
    for (NSUInteger i = 0; i < 100; i++) {
        NSNumber *n = [NSNumber numberWithInt:i];
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
    //SBPriorityQueue *q = [[SBPriorityQueue alloc]initWithComparator:kNumberComparator];
    [self runTimeForQueueType:@"SBPriorityQueue"];
}
- (void)testBinaryHeapPriorityQueueRunTime {
    [self runTimeForQueueType:@"SBBinaryHeapPriorityQueue"];
}


- (void)runTimeForQueueType:(NSString *)queueType
{
    NSComparator numberComparator = ^NSComparisonResult(id obj1, id obj2) {
        STAssertNotNil(obj1, @"Nil object in comparator");
        STAssertNotNil(obj2, @"Nil object in comparator");
        if ([(NSNumber *)obj1 intValue] < [(NSNumber *)obj2 intValue]) {
            return NSOrderedAscending;
        } else if ([(NSNumber *)obj1 intValue] > [(NSNumber *)obj2 intValue]) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
        
    };
    
    id q = [[NSClassFromString(queueType) alloc] initWithComparator:numberComparator];
//    if ([queueType isEqualToString:@"SBPriorityQueue"]) {
//        q = [[SBPriorityQueue alloc] initWithComparator:numberComparator];
//    } else if ([queueType isEqualToString:@"SBBinaryHeapPriorityQueue"]) {
//        q = [[SBBinaryHeapPriorityQueue alloc] initWithComparator:numberComparator];
//    } else {
//        STAssertFalse(YES,@"Attempt timing for unknown queue type: %@", queueType);
//    }
    
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
    NSComparator numberComparator = ^NSComparisonResult(id obj1, id obj2) {
        STAssertNotNil(obj1, @"Nil object in comparator");
        STAssertNotNil(obj2, @"Nil object in comparator");
        if ([(NSNumber *)obj1 intValue] < [(NSNumber *)obj2 intValue]) {
            return NSOrderedAscending;
        } else if ([(NSNumber *)obj1 intValue] > [(NSNumber *)obj2 intValue]) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
        
    };
    
    id q = [[NSClassFromString(queueType) alloc] initWithComparator:numberComparator];
//
//    if ([queueType isEqualToString:@"SBPriorityQueue"]) {
//        q = [[SBPriorityQueue alloc] initWithComparator:numberComparator];
//    } else if ([queueType isEqualToString:@"SBBinaryHeapPriorityQueue"]) {
//        q = [[SBBinaryHeapPriorityQueue alloc] initWithComparator:numberComparator];
//    } else {
//        STAssertFalse(YES,@"Attempt timing for unknown queue type: %@", queueType);
//    }
    
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
    NSComparator numberComparator = ^NSComparisonResult(id obj1, id obj2) {
        if ([(NSNumber *)obj1 intValue] < [(NSNumber *)obj2 intValue]) {
            return NSOrderedAscending;
        } else if ([(NSNumber *)obj1 intValue] > [(NSNumber *)obj2 intValue]) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    };
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

@end
