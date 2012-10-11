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



#import "SBUnionFind.h"
@interface SBUnionFind() {
    NSUInteger *_sites;
    NSUInteger *_sizes;
    NSUInteger _count;
    NSUInteger _arraySize;
}

@end

@implementation SBUnionFind

- (id)initWithSize:(NSUInteger)size
{
    if ((self = [super init])) {
        _sites = malloc(sizeof(NSUInteger) * size);
        _sizes = malloc(sizeof(NSUInteger) * size);
        for (NSUInteger i = 0; i < size; i++) {
            _sites[i] = i;
            _sizes[i] = 0;
            _count = size;
            _arraySize = size;
        }
    }
    return self;
}

- (NSUInteger)idForSite:(NSUInteger)site
{
    NSUInteger siteId = _sites[site];
    while (site != siteId) {
        site = siteId;
        siteId = _sites[site];
    }
    return siteId;
}

- (void)unionSite:(NSUInteger)site1 withSite:(NSUInteger)site2
{
    NSUInteger id1 = [self idForSite:site1];
    NSUInteger id2 = [self idForSite:site2];
    if (id1 == id2) { return; }
    
    if (_sizes[site1] > _sizes[site2]) { 
        _sites[id2] = id1; 
        _sizes[site1]++;
    } else {
        _sites[id1] = id2; 
        _sizes[site2]++;
    }
    _count--;
}

- (BOOL)site:(NSUInteger)site1 isConnectedWithSite:(NSUInteger)site2
{
    return [self idForSite:site1] == [self idForSite:site2];
}

- (NSUInteger)count { return _count; };

- (NSString *)description {
    NSMutableString *desc = [[super description] mutableCopy];
    [desc appendFormat:@"Site count = %lu", _count];
    for (int i = 0; i < _arraySize; i++) {
        [desc appendFormat:@"\n%i: [id: %lu, parent: %lu, size: %lu]", i, [self idForSite:i], _sites[i], _sizes[i]];
    }
    return desc;
}

- (void)dealloc
{
    free(_sites);
    free(_sizes);
}
@end
