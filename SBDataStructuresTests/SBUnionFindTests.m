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
