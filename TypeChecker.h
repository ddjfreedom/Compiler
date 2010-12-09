//
//  TypeChecker.h
//  Compiler
//
//  Created by Duan Dajun on 12/2/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Expression.h"
#import "SemanticExpr.h"

@interface TypeChecker : NSObject
{
  NSMutableArray *levels;
  // envs is a stack holding mutiple environments 
  // the topmost (last in envs) is the current scope
  NSMutableArray *envs;
  NSMutableArray *loopVars;
  NSMutableArray *doneLabels;
}
- (SemanticExpr *)typeCheckProgram:(Expression *)expr;
+ (SemanticExpr *)typeCheckProgram:(Expression *)expr;
@end
