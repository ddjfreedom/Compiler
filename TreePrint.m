//
//  TreePrint.m
//  Compiler
//
//  Created by Duan Dajun on 12/12/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tree.h"
#import "TmpLabel.h"
#import "TmpLabelList.h"
#import "TRProcFrag.h"
#import "TRDataFrag.h"
#include "helper.h"

static NSMutableArray *indent = nil;
void dispatch(id expr);
void printTreeExpr(TreeExpr *expr);
void printTreeStmt(TreeStmt *stmt);
void printBinop(TreeBinop *expr);
void printCJump(TreeCJump *stmt);

void treeprint(id expr)
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  indent = [NSMutableArray array];
  if ([expr isKindOfClass:[TreeStmt class]])
    dispatch(expr);
  else if ([expr isKindOfClass:[TRExpr class]])
    dispatch([expr unNx]);
  else if ([expr isMemberOfClass:[TRProcFrag class]]) {
    printf("ProcFrag\n");
    dispatch(((TRProcFrag *)expr).stmt);
  } else if ([expr isMemberOfClass:[TRDataFrag class]])
    printf("DataFrag: %s Label: %s\n",
           [((TRDataFrag *)expr).string cStringUsingEncoding:NSASCIIStringEncoding],
           ((TRDataFrag *)expr).label.cString);
  [pool drain];
}
void dispatch(id expr)
{
  printIndent(indent);
  if ([expr isKindOfClass:[TreeExpr class]])
    printTreeExpr(expr);
  else if ([expr isKindOfClass:[TreeStmt class]])
    printTreeStmt(expr);
  else if ([expr isKindOfClass:[TreeExprList class]]) {
    printf("ExprList\n");
    [indent addObject:[NSNumber numberWithInt:8]];
    TreeExprList *list;
    for (list = (TreeExprList *)expr; list; list = list.tail) {
      if (!list.tail) replaceLast(indent, -8);
      dispatch(list.head);
    }
    [indent removeLastObject];
  }
}
void printTreeExpr(TreeExpr *expr)
{
  if ([expr isMemberOfClass:[TreeConst class]])
    printf("Const: %d\n", ((TreeConst *)expr).value);
  else if ([expr isMemberOfClass:[TreeName class]])
    printf("Name: %s\n", ((TreeName *)expr).label.cString);
  else if ([expr isMemberOfClass:[TreeBinop class]])
    printBinop((TreeBinop *)expr);
  else if ([expr isMemberOfClass:[TreeCall class]]) {
    printf("Call\n");
    [indent addObject:[NSNumber numberWithInt:4]];
    dispatch(((TreeCall *)expr).func);
    replaceLast(indent, -4);
    dispatch(((TreeCall *)expr).args);
    [indent removeLastObject];
  } else if ([expr isMemberOfClass:[TreeMem class]]) {
    printf("Mem\n");
    [indent addObject:[NSNumber numberWithInt:-3]];
    dispatch(((TreeMem *)expr).expr);
    [indent removeLastObject];
  } else if ([expr isMemberOfClass:[TreeESeq class]]) {
    printf("ESeq\n");
    [indent addObject:[NSNumber numberWithInt:4]];
    dispatch(((TreeESeq *)expr).stmt);
    replaceLast(indent, -4);
    dispatch(((TreeESeq *)expr).expr);
    [indent removeLastObject];
  } else if ([expr isMemberOfClass:[TreeTemp class]])
    printf("Temp: %s\n", ((TreeTemp *)expr).temp.cString);
  else
    printf("Unknown TreeExpr\n");
}
void printBinop(TreeBinop *expr)
{
  printf("Binop\n");
  [indent addObject:[NSNumber numberWithInt:5]];
  printIndent(indent);
  switch (expr.op) {
    case TreePlus: printf("+\n"); break;
    case TreeMinus: printf("-\n"); break;
    case TreeMultiply: printf("*\n"); break;
    case TreeDivide: printf("/\n"); break;
    case TreeAnd: printf("&\n"); break;
    case TreeOr: printf("|\n"); break;
    case TreeLShift: printf("<<\n"); break;
    case TreeRShift: printf(">>\n"); break;
    case TreeARShift: printf("Arith>>\n"); break;
    case TreeXor: printf("^\n"); break;
		default: printf("Unknown Operator\n");
  }
  dispatch(expr.left);
  replaceLast(indent, -5);
  dispatch(expr.right);
  [indent removeLastObject];
}
void printTreeStmt(TreeStmt *stmt)
{
  if ([stmt isMemberOfClass:[TreeLabel class]])
    printf("Label: %s\n", ((TreeLabel *)stmt).label.cString);
  else if ([stmt isMemberOfClass:[TreeExprStmt class]]) {
  	printf("ExprStmt\n");
    [indent addObject:[NSNumber numberWithInt:-8]];
    dispatch(((TreeExprStmt *)stmt).expr);
    [indent removeLastObject];
  } else if ([stmt isMemberOfClass:[TreeJump class]]) {
    TmpLabelList *list = ((TreeJump *)stmt).list;
    int count = 0;
    printf("Jump\n");
    [indent addObject:[NSNumber numberWithInt:4]];
    dispatch(((TreeJump *)stmt).expr);
    replaceLast(indent, -4);
    printIndent(indent);
    for (TmpLabel *label in list)
      printf("%s%s", label.cString, count++ ? " " : "");
    putchar('\n');
    [indent removeLastObject];
  } else if ([stmt isMemberOfClass:[TreeCJump class]])
    printCJump((TreeCJump *)stmt);
  else if ([stmt isMemberOfClass:[TreeSeq class]]) {
    printf("Seq\n");
    [indent addObject:[NSNumber numberWithInt:3]];
    dispatch(((TreeSeq *)stmt).first);
    replaceLast(indent, -3);
    dispatch(((TreeSeq *)stmt).second);
    [indent removeLastObject];
  } else if ([stmt isMemberOfClass:[TreeMove class]]) {
  	printf("Move\n");
    [indent addObject:[NSNumber numberWithInt:4]];
    dispatch(((TreeMove *)stmt).dst);
    replaceLast(indent, -4);
    dispatch(((TreeMove *)stmt).src);
    [indent removeLastObject];
  } else
    printf("Unknown Stmt\n");
}
void printCJump(TreeCJump *stmt)
{
  printf("CJump\n");
  [indent addObject:[NSNumber numberWithInt:5]];
  printIndent(indent);
  switch (stmt.relationOp) {
  	case TreeEQ: printf("=\n"); break;
    case TreeNE: printf("<>\n"); break;
  	case TreeLT: printf("<\n"); break;
  	case TreeGT: printf(">\n"); break;
  	case TreeLE: printf("<=\n"); break;
  	case TreeGE: printf(">=\n"); break;
  	case TreeULT: printf("U<\n"); break;
  	case TreeUGT: printf("U>\n"); break;
  	case TreeULE: printf("U<=\n"); break;
  	case TreeUGE: printf("U>=\n"); break;
		default: printf("Unknown Rel Op\n");
  }
  dispatch(stmt.left);
  dispatch(stmt.right);
  printIndent(indent);
  printf("True Label: %s\n", stmt.iftrue.cString);
  printIndent(indent);
  printf("False Label: %s\n", stmt.iffalse.cString);
  [indent removeLastObject];
}