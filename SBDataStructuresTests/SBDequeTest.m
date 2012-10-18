//
//  SBDequeTest.m
//  SBDataStructures
//
//  Created by Steve Brokaw on 10/17/12.
//
//

#import "SBDequeTest.h"
#import "SBDataStructures.h"
#import "SBDeque.h"

@implementation SBDequeTest
@synthesize numbers;
@synthesize deque;

- (void)setUp
{
    NSMutableArray *nums = [NSMutableArray new];
    for (int i = 0; i < 100; i++) {
        NSNumber *num = [NSNumber numberWithInt:i];
        [nums addObject:num];
    }
    self.numbers = nums;
    self.deque = [SBDeque new];
}

- (void)testFromFrontToFront
{
    NSUInteger max = [self.numbers count];
    for (int i = 0; i < max; i++) {
        [self.deque addObjectAtFront:[self.numbers objectAtIndex:i]];
    }
    for (NSUInteger i = 0; i < max; i++) {
        id obj = [self.deque firstObject];
        STAssertEquals(max - i - 1, [obj unsignedIntegerValue], @"Error: Queue returned %ud, expected %ud", [obj unsignedIntegerValue], max - i - 1);
        STAssertEquals(self.deque.count, (max - i), @"Error in queue count");
        [self.deque removeFirstObject];
    }

}
- (void)testToEndFromEnd
{
    NSUInteger max = [self.numbers count];
    for (int i = 0; i < max; i++) {
        [self.deque addObjectAtEnd:[self.numbers objectAtIndex:i]];
    }
    for (NSUInteger i = 0; i < max; i++) {
        id obj = [self.deque lastObject];
        STAssertEquals(max - i - 1, [obj unsignedIntegerValue], @"Error: Queue returned %ud, expected %ud", [obj unsignedIntegerValue], max - i - 1);
        STAssertEquals(self.deque.count, (max - i), @"Error in queue count");
        [self.deque removeLastObject];
    }

}
- (void)testToEndFromFront
{
    NSUInteger max = [self.numbers count];
    for (int i = 0; i < max; i++) {
        [self.deque addObjectAtEnd:[self.numbers objectAtIndex:i]];
    }
    for (int i = 0; i < max; i++) {
        id obj = [self.deque firstObject];
        STAssertEquals(i, [obj intValue], @"Error: Queue returned %i, expected %i", [obj intValue], i);
        STAssertEquals(self.deque.count, (NSUInteger)(max - i), @"Error in queue count");
        [self.deque removeFirstObject];
    }

}
- (void)testToFrontFromEnd
{
    NSUInteger max = [self.numbers count];
    for (int i = 0; i < max; i++) {
        [self.deque addObjectAtFront:[self.numbers objectAtIndex:i]];
    }
    for (int i = 0; i < max; i++) {
        id obj = [self.deque lastObject];
        STAssertEquals(i, [obj intValue], @"Error: Queue returned %i, expected %i", [obj intValue], i);
        STAssertEquals(self.deque.count, (NSUInteger)(max - i), @"Error in queue count");
        [self.deque removeLastObject];
    }
}

@end
