//
//  Sheepdog.h
//  Sheepdog
//
//  Created by Matt Ronge on 2/13/14.
//  Copyright (c) 2014 Astro HQ. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
Sheepdog provides simple higher-order functions
for common Cocoa data structures. BSD licensed and no 
dependencies required.
 
These methods are inspired by Clojure. None of these 
methods mutate the object being called on.
*/

#pragma mark - Array

/**
 Higher-order methods for NSArray.
 
 These methods are inspired by Clojure. None of these
 methods mutate the array being called on.
 */
@interface NSArray (Sheepdog)
/**
 Returns elements from the array which return YES for the `block`
 @param block The predicate used to determine which elements to include
 */
- (NSArray *)filter:(BOOL (^)(id obj))block;

/**
 Reduces the array to a single value using the `block`
 @param val Is the initial value used to seed the reduce
 @param block The block which describes how to combine elements
 */
- (id)reduce:(id)val block:(id (^)(id left, id right))block;

/**
 Applies `block` to every element in the array and returns the collected results
 @param block The block used to transform array elements
 @warning If `block` returns nil for an element it will be omitted from the results
 */
- (NSArray *)map:(id (^)(id obj))block;

/**
 Returns a sorted array using `compare:`
 */
- (NSArray *)sort;

/**
 Returns a reversed version of the array
 */
- (NSArray *)reverse;

/**
 Returns only unique values from the array
 */
- (NSArray *)distinct;

/**
 Divides up the array into smaller arrays of size `N`. The
 final partition may be smaller than N if there aren't enough elements
 @param n The partition size, must be greater than 0
 */
- (NSArray *)partition:(NSInteger)n;

/**
 Applies `block` to each element in the array, each time the return value
 of `block` changes a new partition of elements is started.
 @param block The block whose return value determines the partition
*/
- (NSArray *)partitionBy:(id (^)(id obj))block;

/**
 Applies `block` to each element and uses the return value to determine
 what group the element should be added to
 @param block The block whose return value determines how to group
*/
- (NSDictionary *)groupBy:(id (^)(id obj))block;

/**
 Returns `YES` if `block` returns `YES` for atleast one element in the array
 @param block The predicate that determines the test atleast one element must pass
 */
- (BOOL)any:(BOOL (^)(id obj))block;

/**
 Returns YES if `block` returns YES for every element in the array
 @param block The predicate that determines the test every element must pass
 */
- (BOOL)every:(BOOL (^)(id obj))block;

/**
 Uses `compare:` to find the max value in the array
 @warning Returns nil if the array is empty
 */
- (id)max;

/**
 Uses `compare:` to find the min value in the array
 @warning Returns nil if the array is empty
 */
- (id)min;
@end

#pragma mark - Set


/**
 Higher-order methods for NSSet.
 
 These methods are inspired by Clojure. None of these
 methods mutate the set being called on.
 */
@interface NSSet (Sheepdog)
/**
 Returns elements from the set which return YES for the `block`
 @param block The predicate used to determine which elements to include
 */
- (NSSet *)filter:(BOOL (^)(id obj))block;

/**
 Reduces the set to a single value using the `block`
 @param val Is the initial value used to seed the reduce
 @param block The block which describes how to combine elements
 */
- (id)reduce:(id)val block:(id (^)(id left, id right))block;

/**
 Applies `block` to every element in the set and returns the collected results
 @param block The block used to transform array elements
 @warning If `block` returns nil for an element it will be omitted from the results
 */
- (NSSet *)map:(id (^)(id obj))block;

/**
 Returns YES if `block` returns YES for atleast one element in the set
 @param block The predicate that determines the test atleast one element must pass
 */
- (BOOL)any:(BOOL (^)(id obj))block;

/**
 Returns YES if `block` returns YES for every element in the set
 @param block The predicate that determines the test every element must pass
 */
- (BOOL)every:(BOOL (^)(id obj))block;

/**
 Uses `compare:` to find the max value in the set
 @warning Returns nil if the set is empty
 */
- (id)max;

/**
 Uses `compare:` to find the min value in the set
 @warning Returns nil if the set is empty
 */
- (id)min;
@end
