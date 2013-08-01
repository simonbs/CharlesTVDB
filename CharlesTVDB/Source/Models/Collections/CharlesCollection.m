//
//  CharlesCollection.m
//  CharlesTVDB
//
//  Created by Simon Støvring on 28/07/13.
//  Copyright (c) 2013 intuitaps. All rights reserved.
//

#import "CharlesCollection.h"

@interface CharlesCollection ()
@property (nonatomic, strong) NSMutableArray *array;
@end

@implementation CharlesCollection

#pragma mark -
#pragma mark Lifecycle

- (id)init
{
    if (self = [super init])
    {
        _array = [NSMutableArray array];
    }
    
    return self;
}

- (void)dealloc
{
    _array = nil;
}

#pragma mark -
#pragma mark Public Methods

- (NSUInteger)count
{
    return [self.array count];
}

- (NSArray *)allObjects
{
    return [NSArray arrayWithArray:self.array];
}

#pragma mark -
#pragma mark In Private Interface

- (void)addObject:(id)obj
{
    [self.array addObject:obj];
}

- (void)removeObject:(id)obj
{
    if ([self.array containsObject:obj])
    {
        [self.array removeObject:obj];
    }
}

- (id)objectAtIndex:(NSUInteger)index
{
    NSParameterAssert(index <= [self.array count] - 1);
    
    return [self.array objectAtIndex:index];
}

- (NSInteger)indexOfObject:(id)obj
{
    return [self.array indexOfObject:obj];
}

#pragma mark -
#pragma mark Enumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained *)stackbuf count:(NSUInteger)len
{
    // Using Apples implementation
    // http://developer.apple.com/library/ios/#DOCUMENTATION/Cocoa/Conceptual/Collections/Articles/Enumerators.html
    
    NSUInteger count = 0;
    // This is the initialization condition, so we'll do one-time setup here.
    // Ensure that you never set state->state back to 0, or use another method to detect initialization
    // (such as using one of the values of state->extra).
    if(state->state == 0)
    {
        // We are not tracking mutations, so we'll set state->mutationsPtr to point into one of our extra values,
        // since these values are not otherwise used by the protocol.
        // If your class was mutable, you may choose to use an internal variable that is updated when the class is mutated.
        // state->mutationsPtr MUST NOT be NULL.
        state->mutationsPtr = &state->extra[0];
    }
    // Now we provide items, which we track with state->state, and determine if we have finished iterating.
    if(state->state < [self.array count])
    {
        // Set state->itemsPtr to the provided buffer.
        // Alternate implementations may set state->itemsPtr to an internal C array of objects.
        // state->itemsPtr MUST NOT be NULL.
        state->itemsPtr = stackbuf;
        // Fill in the stack array, either until we've provided all items from the list
        // or until we've provided as many items as the stack based buffer will hold.
        while((state->state < [self.array count]) && (count < len))
        {
            // For this sample, we generate the contents on the fly.
            // A real implementation would likely just be copying objects from internal storage.
            stackbuf[count] = self.array[state->state];
            state->state++;
            count++;
        }
    }
    else
    {
        // We've already provided all our items, so we signal we are done by returning 0.
        count = 0;
    }
    
    return count;
}

@end
