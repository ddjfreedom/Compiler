//
//  AbstractSyntax.h
//  Compiler
//
//  Created by Duan Dajun on 11/29/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "Syntax.h"

//  Var
#import "Var.h"
#import "SimpleVar.h"
#import "FieldVar.h"
#import "SubscriptVar.h"

//  Expression
#import "Expression.h"
#import "IntExpression.h"
#import "StringExpression.h"
#import "NilExpression.h"
#import "OperationExpression.h"
#import "VarExpression.h"
#import "AssignExpression.h"
#import "IfExpression.h"
#import "WhileExpression.h"
#import "BreakExpression.h"
#import "CallExpression.h"
#import "RecordExpression.h"
#import "SequenceExpression.h"
#import "ForExpression.h"
#import "LetExpression.h"
#import "ArrayExpression.h"

//  Declaration
#import "Decl.h"
#import "VarDecl.h"
#import "TypeDecl.h"
#import "FunctionDecl.h"

//  Type
#import "Type.h"
#import "NameType.h"
#import "RecordType.h"
#import "ArrayType.h"

//  Miscellaneous Class
#import "SyntaxList.h"
#import "FieldExpression.h"
#import "SingleTypeField.h"
