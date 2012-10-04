//
//  SBDataStructuresTests.m
//  SBDataStructuresTests
//
//  Created by Steve Brokaw on 9/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBDataStructuresTests.h"
#import "SBDataStructures.h"

@implementation SBDataStructuresTests

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

- (void)testBinaryHeapPriorityQueue
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
    SBBinaryHeapPriorityQueue *q1 = [[SBBinaryHeapPriorityQueue alloc] initWithComparator:numberComparator];
    for (int i = 0; i < 100; i++) {
        NSNumber *n = [NSNumber numberWithInt:i];
        [q1 addObject:n];
    }
    
    NSNumber *previous = [q1 removeHead];
    for (int i = 99; i > 0; i--) {
        STAssertEquals(i, [q1 count], @"Queue count is off. Subsequent tests may be invalid");
        NSNumber *current = [q1 removeHead];
        STAssertTrue([current intValue] > [previous intValue], @"Heap item out of order.");
        NSInteger count = [q1 count];
        STAssertEquals([q1 objectAtHead], [q1 objectAtHead], @"Adjacent peekHead calls return different objects");
        STAssertEquals(count, [q1 count], @"peekHead changes queue size");
        previous = current;
    }
    SBBinaryHeapPriorityQueue *q2 = [[SBBinaryHeapPriorityQueue alloc] initWithComparator:NULL];
    STAssertThrows([q2 addObject:nil], @"Added object with no comparator should throw exception." );
    q2 = [[SBBinaryHeapPriorityQueue alloc] initWithComparator:numberComparator];
    NSMutableArray *random = [NSMutableArray new];
    for (int i = 0; i < 1000; i++) {
        [random addObject:[NSNumber numberWithUnsignedInt:arc4random_uniform(UINT32_MAX)]];
    }
    
    for (NSNumber *num in random) {
        [q1 addObject:num];
        [q2 addObject:num];
    }
    while ([q1 count] > 0) {
        STAssertEquals([q1 removeHead], [q2 removeHead], @"");
    }
}

- (void)testPriorityQueue
{
    SBPriorityQueue *q = [[SBPriorityQueue alloc] initWithComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 intValue] < [obj2 intValue]) {
            return NSOrderedAscending;
        } else if ([obj1 intValue] > [obj2 intValue]) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    
    for (uint i = 0; i < 100; i++) {
        NSNumber *n = [NSNumber numberWithInt:i];
        STAssertEquals(i, [q count], @"Queue count is off");
        [q addObject:n];
    }
    
    NSNumber *previous = (NSNumber *)[q removeHead];
    for (uint i = 99; i > 0; i--) {
        STAssertEquals(i, [q count], @"Queue count is off. Subsequent tests may be invalid");
        
        NSNumber *current = (NSNumber *)[q removeHead];
        STAssertTrue([current intValue] > [previous intValue], @"Heap item out of order.");
        previous = current;
        
        NSUInteger count = [q count];
        STAssertEquals([q objectAtHead], [q objectAtHead], @"Adjacent peekHead calls return different objects");
        STAssertEquals(count, [q count], @"peekHead changes queue size");
    }
}

- (void)testPriorityQueueRunTime {
    NSComparator numberComparator = ^NSComparisonResult(id obj1, id obj2) {
        if ([(NSNumber *)obj1 intValue] < [(NSNumber *)obj2 intValue]) {
            return NSOrderedAscending;
        } else if ([(NSNumber *)obj1 intValue] > [(NSNumber *)obj2 intValue]) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
        
    };
    //SBPriorityQueue *q = [[SBPriorityQueue alloc] initWithComparator:numberComparator];
    int samples[] = { 4000, 8000, 16000, 32000, 64000 };
    NSTimeInterval previousBuild = 0;
    NSTimeInterval previousPop = 0;
    NSTimeInterval time;
    
    printf("=====================\nSBPriortyQueue Timing\n=====================\n");
    previousBuild = 0;
    previousPop = 0;
    for (int i = 0; i < 5; i++) {
        SBPriorityQueue *q = [[SBPriorityQueue alloc] initWithComparator:numberComparator];
        
        //printf("N = %i\n", samples[i]);
        NSDate *date = [NSDate date];
        for (int j = 0; j < samples[i]; j++) {
            [q addObject:[randomNumbers objectAtIndex:j]];
        }
        for (int j =0; j < samples[i]; j++) {
            [q removeHead];
        }
        time = -[date timeIntervalSinceNow];
        
        printf("T(%i) = %f\tdT = %f\tratio = %f\n", samples[i], time, time - previousPop, (previousPop == 0 ? 0 : (time  / previousPop)));
        previousPop = time;
        //printf("-----------\n");
        q = nil;        
    }
    SBPriorityQueue *q = [[SBPriorityQueue alloc] initWithComparator:numberComparator];
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
            [q removeHead];
        }
    }
    time = -[date timeIntervalSinceNow];
    printf("Alternating add/remove: %f\n", time);
}

- (void)testBinaryHeapPriorityQueueRunTime {
    NSComparator numberComparator = ^NSComparisonResult(id obj1, id obj2) {
        if ([(NSNumber *)obj1 intValue] < [(NSNumber *)obj2 intValue]) {
            return NSOrderedAscending;
        } else if ([(NSNumber *)obj1 intValue] > [(NSNumber *)obj2 intValue]) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
        
    };
    int samples[] = { 4000, 8000, 16000, 32000, 64000 };
    printf("================================\nSBBinaryHeapPriorityQueue Timing\n================================\n");
    NSTimeInterval previous = 0;
    NSTimeInterval time;
    
    for (int i = 0; i < 5; i++) {
        SBBinaryHeapPriorityQueue *q = [[SBBinaryHeapPriorityQueue alloc] initWithComparator:numberComparator];
        NSDate *date = [NSDate date];
        for (int j =0; j < samples[i]; j++) {
            [q addObject:[randomNumbers objectAtIndex:j]];
        }
        
        for (int j =0; j < samples[i]; j++) {
            [q removeHead];
        }
        time = -[date timeIntervalSinceNow];
        
        printf("T(%i) = %f\tdT = %f\tratio = %f\n", samples[i], time, time - previous, (previous == 0 ? 0 : (time / previous)));
        previous = time;
        q = nil;
        //printf("-----------\n");
    }
    SBPriorityQueue *q = [[SBPriorityQueue alloc] initWithComparator:numberComparator];
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
            [q removeHead];
        }
    }
    time = -[date timeIntervalSinceNow];
    printf("Alternating add/remove: %f\n", time);

    
}

@end
