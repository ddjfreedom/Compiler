//
//  TypeChecker.h
//  Compiler
//
//  Created by Duan Dajun on 12/2/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TR.h"
#import "TRExpr.h"
#import "Expression.h"
#import "Frame.h"

@interface TypeChecker : NSObject
{
  NSMutableArray *levels;
  // envs is a stack holding mutiple environments 
  // the topmost (last in envs) is the current scope
  NSMutableArray *envs;
  NSMutableArray *loopVars;
  NSMutableArray *doneLabels;
  BOOL hasError;
  TR *trans;
}
- (NSArray *)typeCheckProgram:(Expression *)expr withTranslator:(TR *)tr inFrame:(Frame *)frame;
+ (NSArray *)typeCheckProgram:(Expression *)expr withTranslator:(TR *)tr inFrame:(Frame *)frame;
@end
