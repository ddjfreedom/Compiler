//
//  RecordType.h
//  Compiler
//
//  Created by Duan Dajun on 11/28/10.
//  Copyright 2010 SJTU. All rights reserved.
//
//  type: { type-fields }

#import "Type.h"
#import "SyntaxList.h"
@interface RecordType : Type 
{
	SyntaxList *typefields;
}
@property (readonly) SyntaxList *typefields;
- (id)initWithTypeFields:(SyntaxList *)fields andLineNumber:(int)lineno;
@end
