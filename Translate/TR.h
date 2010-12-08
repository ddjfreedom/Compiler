//
//  TR.h
//  Compiler
//
//  Created by Duan Dajun on 12/8/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "SemanticRecordType.h"
#import "Symbol.h"
#import "TRExpr.h"
#import "TRAccess.h"
#import "TRLevel.h"

@interface TR : NSObject 
{

}
+ (void)setWordSize:(int)size;
+ (TRExpr *)simpleVarWithAccess:(TRAccess *)anAcc level:(TRLevel *)aLevel;
+ (TRExpr *)arrayVarWithBase:(TRExpr *)base subscript:(TRExpr *)sub level:(TRLevel *)aLevel;
+ (TRExpr *)fieldVarWithVar:(TRExpr *)var 
                       type:(SemanticRecordType *)type 
                      field:(Symbol *)field 
                      level:(TRLevel *)aLevel;
@end
