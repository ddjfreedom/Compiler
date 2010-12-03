//
//  TypeChecker.h
//  Compiler
//
//  Created by Duan Dajun on 12/2/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Expression.h"
#import "IntermediateExpression.h"

@interface TypeChecker : NSObject
{
  NSMutableArray *envs;
}
//  Initialize the environment
//  Add predefined types and functions to the environment
- (IntermediateExpression *)typeCheckProgram:(Expression *)expr;
- (void)symbolInitialization;
+ (IntermediateExpression *)typeCheckProgram:(Expression *)expr;
@end
