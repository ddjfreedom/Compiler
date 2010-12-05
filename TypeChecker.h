//
//  TypeChecker.h
//  Compiler
//
//  Created by Duan Dajun on 12/2/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Expression.h"
#import "IMExpression.h"

@interface TypeChecker : NSObject
{
  // envs is a stack holding mutiple environments 
  // the topmost (last in envs) is the current scope
  NSMutableArray *envs;
}
- (IMExpression *)typeCheckProgram:(Expression *)expr;
+ (IMExpression *)typeCheckProgram:(Expression *)expr;
@end
