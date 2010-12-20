//
//  Frame.h
//  Compiler
//
//  Created by Duan Dajun on 12/6/10.
//  Copyright 2010 SJTU. All rights reserved.
//
//  Abstract class. Should be subclassed

#import <Foundation/Foundation.h>
#import "TmpLabel.h"
#import "TmpTemp.h"
#import "TmpTempMap.h"
#import "Access.h"
#import "BoolList.h"
#import "Tree.h"
#import "Proc.h"

@interface Frame : NSObject <TmpTempMap>
{
	TmpLabel *name;
  NSMutableArray *formals;
  int wordSize;
}
@property (readonly) TmpLabel *name;
@property (readonly) NSArray *formals;
@property (readonly) int wordSize;
@property (readonly) TmpTemp *fp;
@property (readonly) TmpTemp *rv;
- (Frame *)newFrameWith:(TmpLabel *)aLabel boolList:(BoolList *)aBoolList;
- (Access *)generateLocal:(BOOL)isEscaped;
- (TreeExpr *)externalCallWithName:(NSString *)aName arguments:(TreeExprList *)args;
- (TreeStmt *)procEntryExit1WithStmt:(TreeStmt *)body;
- (NSMutableArray *)procEntryExit2WithInstructions:(NSMutableArray *)body;
- (Proc *)procEntryExit3WithInstructions:(NSMutableArray *)body;
- (NSArray *)codegenUsingStmts:(TreeStmtList *)aStmtList;
@end
