//
//  Codegen.h
//  Compiler
//
//  Created by Duan Dajun on 12/19/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TreeStmt.h"

@interface Codegen : NSObject
{

}
- (NSArray *)codegenUsingStmt:(TreeStmt *)aStmt;
@end
