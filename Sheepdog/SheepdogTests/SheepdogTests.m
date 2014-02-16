//
//  SheepdogTests.m
//  Sheepdog
//
//  Created by Matt Ronge on 2/13/14.
//  Copyright (c) 2014 Astro HQ. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Sheepdog.h"

@interface SheepdogTests : XCTestCase

@end

@implementation SheepdogTests

- (void)testFilter {
    NSArray *array;
    NSArray *end;
    
    array = @[@(1), @(-1), @(-3), @(4)];
    end = @[@(1), @(4)];
    
    NSArray *results = [array filter:^BOOL(id obj) {
        return [obj integerValue] > 0;
    }];
    XCTAssertEqualObjects(results, end, @"");
}

- (void)testReduce {
    NSArray *array;

    array = @[@(1), @(-1), @(-3), @(4)];
    
    id results = [array reduce:@(1) block:^id(id left, id right) {
        return @([left integerValue] + [right integerValue]);
    }];
    XCTAssertEqualObjects(results, @(2), @"");
    
    results = [@[] reduce:@(1) block:^id(id left, id right) {
        return @([left integerValue] + [right integerValue]);
    }];
    XCTAssertEqualObjects(results, @(1), @"");
}

- (void)testMap {
    NSArray *array;
    NSArray *end;
    
    array = @[@(1), @(-1), @(-3), @(4)];
    end = @[@(2), @(0), @(-2), @(5)];
    
    NSArray *results = [array map:^id(id obj) {
        return @([obj integerValue] + 1);
    }];
    XCTAssertEqualObjects(results, end, @"");
}

- (void)testReverse {
    NSArray *array;
    NSArray *end;
    
    array = @[@(1), @(2), @(3), @(4)];
    end = @[@(4), @(3), @(2), @(1)];
    XCTAssertEqualObjects([array reverse], end, @"");
    
    array = @[@(1), @(2), @(3)];
    end = @[@(3), @(2), @(1)];
    XCTAssertEqualObjects([array reverse], end, @"");
    
    array = @[@(1)];
    end = @[@(1)];
    XCTAssertEqualObjects([array reverse], end, @"");
    
    array = @[];
    end = @[];
    XCTAssertEqualObjects([array reverse], end, @"");
    
    array = nil;
    end = nil;
    XCTAssertEqualObjects([array reverse], end, @"");
}

- (void)testSort {
    NSArray *array;
    NSArray *end;
    
    array = @[@(3), @(1), @(2)];
    end = @[@(1), @(2), @(3)];
    XCTAssertEqualObjects([array sort], end, @"");
    
    array = @[@(1)];
    end = @[@(1)];
    XCTAssertEqualObjects([array reverse], end, @"");
    
    array = @[];
    end = @[];
    XCTAssertEqualObjects([array reverse], end, @"");
    
    array = nil;
    end = nil;
    XCTAssertEqualObjects([array reverse], end, @"");
}

- (void)testDistinct {
    NSArray *array;
    NSArray *end;
    
    array = @[@(3), @(1), @(2), @(3), @(1)];
    end = @[@(1), @(2), @(3)];
    XCTAssertEqualObjects([[array distinct] sort], end, @"");
}

- (void)testPartitionBy {
    NSArray *array;
    NSArray *end;
    NSArray *result;
    
    array = @[@(3), @(3), @(3), @(2), @(2), @(5), @(1), @(1)];
    end = @[@[@(3), @(3), @(3)],
            @[@(2), @(2)],
            @[@(5)],
            @[@(1), @(1)]];
    result = [array partitionBy:^id(id obj){return obj;}];
    XCTAssertEqualObjects(result, end, @"");
    
    array = @[@(3), @(3)];
    end = @[@[@(3), @(3)]];
    result = [array partitionBy:^id(id obj){return obj;}];
    XCTAssertEqualObjects(result, end, @"");
    
    array = @[@(1)];
    end = @[@[@(1)]];
    result = [array partitionBy:^id(id obj){return obj;}];
    XCTAssertEqualObjects(result, end, @"");
    
    array = @[];
    end = @[];
    result = [array partitionBy:^id(id obj){return obj;}];
    XCTAssertEqualObjects(result, end, @"");
    
    array = @[@"bob", @"cat", @"mat", @"sing", @"song"];
    end = @[@[@"bob", @"cat", @"mat"],
            @[@"sing", @"song"]];
    result = [array partitionBy:^id(id obj){return @([obj length]);}];
    XCTAssertEqualObjects(result, end, @"");
}

- (void)testPartition {
    NSArray *array;
    NSArray *end;
    NSArray *result;
    
    array = @[@(1), @(2), @(3), @(4), @(5)];
    end = @[@[@(1), @(2)],
            @[@(3), @(4)],
            @[@(5)]];
    result = [array partition:2];
    XCTAssertEqualObjects(result, end, @"");
    
    array = @[@(1), @(2), @(3), @(4), @(5)];
    end = @[@[@(1), @(2), @(3)],
            @[@(4), @(5)]];
    result = [array partition:3];
    XCTAssertEqualObjects(result, end, @"");
            
    array = @[@(1), @(2), @(3), @(4)];
    end = @[@[@(1), @(2)],
            @[@(3), @(4)]];
    result = [array partition:2];
    XCTAssertEqualObjects(result, end, @"");
    
    array = @[@(1)];
    end = @[@[@(1)]];
    result = [array partition:2];
    XCTAssertEqualObjects(result, end, @"");
}

- (void)testGroupBy {
    NSArray *array;
    NSDictionary *end;
    NSDictionary *result;
    
    array = @[@"bob", @"at", @"mat", @"sing", @"song"];
    end = @{
            @(3): @[@"bob", @"mat"],
            @(2): @[@"at"],
            @(4): @[@"sing", @"song"]
    };
    result = [array groupBy:^id(id obj){return @([obj length]);}];
    XCTAssertEqualObjects(result, end, @"");
}

- (void)testAny {
    NSArray *array;
    
    array = @[@(1), @(-1), @(2), @(4)];
    BOOL results = [array any:^BOOL(id obj) {
        return [obj integerValue] < 0;
    }];
    XCTAssert(results == YES, @"");
    
    array = @[@(1), @(1), @(2), @(4)];
    results = [array any:^BOOL(id obj) {
        return [obj integerValue] < 0;
    }];
    XCTAssert(results == NO, @"");
}

- (void)testEvery {
    NSArray *array;
    
    array = @[@(1), @(-1), @(2), @(4)];
    BOOL results = [array every:^BOOL(id obj) {
        return [obj integerValue] > 0;
    }];
    XCTAssert(results == NO, @"");
    
    array = @[@(1), @(1), @(2), @(4)];
    results = [array every:^BOOL(id obj) {
        return [obj integerValue] > 0;
    }];
    XCTAssert(results == YES, @"");
}

- (void)testMin {
    NSArray *array;
    
    array = @[@(3), @(1), @(2)];
    XCTAssertEqualObjects([array min], @(1), @"");
    
    XCTAssert([@[] min] == nil, @"");
}

- (void)testMax {
    NSArray *array;
    
    array = @[@(3), @(1), @(2)];
    XCTAssertEqualObjects([array max], @(3), @"");
    
    XCTAssert([@[] min] == nil, @"");
}

- (void)testSetMax {
    NSSet *set = [NSSet setWithObjects:@(1), @(3), nil];
    XCTAssertEqualObjects([set max], @(3), @"");
}

- (void)testSetMin {
    NSSet *set = [NSSet setWithObjects:@(1), @(3), nil];
    XCTAssertEqualObjects([set min], @(1), @"");
}

@end
