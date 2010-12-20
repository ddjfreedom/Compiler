//
//  MipsCodegen.h
//  Compiler
//
//  Created by Duan Dajun on 12/19/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MipsFrame.h"
#import "TmpTemp.h"
#import "Tree.h"

@interface MipsCodegen : NSObject
{
	MipsFrame *frame;
  NSMutableArray *instructions;
}
- (id)initWithFrame:(MipsFrame *)aFrame;
- (TmpTemp *)munchExpr:(TreeExpr *)anExpr;
- (void)munchStmt:(TreeStmt *)aStmt;
- (NSArray *)codegenUsingStmt:(TreeStmt *)aStmt;
+ (id)codegenWithFrame:(MipsFrame *)aFrame;
@end
