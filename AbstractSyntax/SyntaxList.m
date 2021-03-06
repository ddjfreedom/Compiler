//
//  SyntaxList.m
//  Compiler
//
//  Created by Duan Dajun on 11/29/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "SyntaxList.h"
#import "Expression.h"
#import "Decl.h"
#import "FieldExpression.h"
#import "SingleTypeField.h"

@implementation SyntaxList
- (id)initWithObject:(id)anObject
{
  if (self = [super init]) {
    list = [[NSMutableArray arrayWithObject:anObject] retain];
    lineNumber = 0;
  }
  return self;
}
- (NSUInteger)count
{
  return list.count;
}
- (void)addObject:(id)anObject
{
  [list addObject:anObject];
}
- (id)objectAtIndex:(NSUInteger)index
{
  return [list objectAtIndex:index];
}
- (id)lastObject
{
  return [list lastObject];
}
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state 
                                  objects:(id *)stackbuf 
                                    count:(NSUInteger)len
{
  return [list countByEnumeratingWithState:state objects:stackbuf count:len];
}
- (SyntaxListType)type
{
  if ([[list lastObject] isKindOfClass:[Expression class]])
    return ExpressionSequence;
  else if ([[list lastObject] isKindOfClass:[FieldExpression class]])
    return FieldList;
  else if ([[list lastObject] isKindOfClass:[SingleTypeField class]])
    return TypeFields;
  else
    return DeclarationList;
}
- (void)dealloc
{
  [list release];
  [super dealloc];
}
+ (id)syntaxListWithObject:(id)anObject
{
  return [[[SyntaxList alloc] initWithObject:anObject] autorelease];
}
@end
