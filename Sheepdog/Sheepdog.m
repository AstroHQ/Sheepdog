//
//  Sheepdog.m
//  Sheepdog
//
//  Created by Matt Ronge on 2/13/14.
//  Copyright (c) 2014 Astro HQ. All rights reserved.
//

#import "Sheepdog.h"

#pragma mark - Shared

static id __filter(id collection, Class type, BOOL (^block)(id obj)) {
    id results = [[type alloc] init];
    for (id obj in collection) {
        BOOL result = block(obj);
        if (result) {
            [results addObject:obj];
        }
    }
    return results;
}

static id __map(id collection, Class type, id (^block)(id obj)) {
    id results = [[type alloc] init];
    for (id obj in collection) {
        id result = block(obj);
        if (result) {
            [results addObject:result];
        }
    }
    return results;
}

static id __reduce(id collection, Class type, id initial, id (^block)(id left, id right)) {
    id last = initial;
    for (id obj in collection) {
        last = block(last, obj);
    }
    return last;
}

static BOOL __any(id collection, Class type, BOOL (^block)(id obj)) {
    id results = __filter(collection, type, block);
    return [results count] > 0;
}

static BOOL __every(id collection, Class type, BOOL (^block)(id obj)) {
    id results = __filter(collection, type, block);
    return [results count] == [collection count];
}

#pragma mark - Array

@implementation NSArray (Sheepdog)

- (NSArray *)filter:(BOOL (^)(id obj))block {
    return __filter(self, [NSMutableArray class], block);
}

- (id)reduce:(id)val block:(id (^)(id left, id right))block {
    return __reduce(self, [NSMutableArray class], val, block);
}

- (NSArray *)map:(id (^)(id obj))block {
    return __map(self, [NSMutableArray class], block);
}

- (NSArray *)sort {
    return [self sortedArrayUsingSelector:@selector(compare:)];
}

- (NSArray *)reverse {
    NSMutableArray *array = [self mutableCopy];
    int count = array.count;
    for (int i = 0; i < floor(count/2); i++) {
        id temp = array[i];
        array[i] = array[count - i - 1];
        array[count - i - 1] = temp;
    }
    return array;
}

- (BOOL)any:(BOOL (^)(id obj))block {
    return __any(self, [NSMutableArray class], block);
}

- (BOOL)every:(BOOL (^)(id obj))block {
    return __every(self, [NSMutableArray class], block);
}

- (id)max {
    if (self.count == 0) {
        return nil;
    }
    
    id result = [self reduce:[self firstObject]
                       block:^id (id left, id right) {
                           NSComparisonResult result = [left compare:right];
                           if (result == NSOrderedDescending) {
                               return left;
                           } else {
                               return right;
                           }
                       }];
    
    return result;
}

- (NSInteger)imax {
    return [[self max] integerValue];
}

- (float)fmax {
    return [[self max] floatValue];
}

- (id)min {
    if (self.count == 0) {
        return nil;
    }
    
    id result = [self reduce:[self firstObject]
                       block:^id (id left, id right) {
                           NSComparisonResult result = [left compare:right];
                           if (result == NSOrderedDescending) {
                               return right;
                           } else {
                               return left;
                           }
                       }];
    
    return result;
}

- (NSInteger)imin {
    return [[self min] integerValue];
}

- (float)fmin {
    return [[self min] floatValue];
}

@end

#pragma mark - Set

@implementation NSSet (Sheepdog)

- (NSSet *)filter:(BOOL (^)(id obj))block {
    return __filter(self, [NSMutableSet class], block);
}

- (id)reduce:(id)val block:(id (^)(id left, id right))block {
    return __reduce(self, [NSMutableSet class], val, block);
}

- (NSSet *)map:(id (^)(id obj))block {
    return __map(self, [NSMutableSet class], block);
}


- (BOOL)any:(BOOL (^)(id obj))block {
    return __any(self, [NSMutableSet class], block);
}

- (BOOL)every:(BOOL (^)(id obj))block {
    return __every(self, [NSMutableSet class], block);
}

- (id)max {
    if (self.count == 0) {
        return nil;
    }
    
    NSMutableSet *set = [self mutableCopy];
    id obj = [set anyObject];
    [set removeObject:obj];
    
    id result = [self reduce:obj
                       block:^id (id left, id right) {
                           NSComparisonResult result = [left compare:right];
                           if (result == NSOrderedDescending) {
                               return left;
                           } else {
                               return right;
                           }
                       }];
    
    return result;
}

- (NSInteger)imax {
    return [[self max] integerValue];
}

- (float)fmax {
    return [[self max] floatValue];
}

- (id)min {
    if (self.count == 0) {
        return nil;
    }
    
    NSMutableSet *set = [self mutableCopy];
    id obj = [set anyObject];
    [set removeObject:obj];
    
    id result = [self reduce:obj
                       block:^id (id left, id right) {
                           NSComparisonResult result = [left compare:right];
                           if (result == NSOrderedDescending) {
                               return right;
                           } else {
                               return left;
                           }
                       }];
    
    return result;
}

- (NSInteger)imin {
    return [[self min] integerValue];
}

- (float)fmin {
    return [[self min] floatValue];
}

@end