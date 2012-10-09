//
//  SBUnionFindTests.m
//  SBDataStructures
//
//  Created by Steve Brokaw on 10/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBUnionFindTests.h"
#import "SBUnionFind.h"

@implementation SBUnionFindTests

- (void)testUnionFind
{
    
    SBUnionFind *uf = [[SBUnionFind alloc] initWithSize:10];
    STAssertEquals([uf idForSite:1], (NSUInteger)1, @"");
    STAssertFalse([uf site:0 isConnectedWithSite:9], @"");
    [uf unionSite:0 withSite:9];
    STAssertTrue([uf site:0 isConnectedWithSite:9], @"");
    [uf unionSite:0 withSite:8];
    STAssertTrue([uf site:8 isConnectedWithSite:9], @"");
    [uf unionSite:1 withSite:9];
    STAssertTrue([uf site:1 isConnectedWithSite:8], @"");
    //NSLog(@"%@", uf);
}

#define TEST_SIZE 100
- (void)testWorstCaseInput
{
    SBUnionFind *uf = [[SBUnionFind alloc] initWithSize:TEST_SIZE];
    for (int i = 0; i < TEST_SIZE - 1; i++) {
        [uf unionSite:i withSite:i+1];
    }
    //NSLog(@"%@", uf);
    STAssertTrue([uf site:0 isConnectedWithSite:TEST_SIZE - 1], @"");
    //NSLog(@"Id for 0: %i", [uf idForSite:0]);
}
@end
