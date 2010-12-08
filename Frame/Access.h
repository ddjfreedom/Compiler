//
//  Access.h
//  Compiler
//
//  Created by Duan Dajun on 12/7/10.
//  Copyright 2010 SJTU. All rights reserved.
//
//  Abstract class. Should be subclassed

#import "TreeExpr.h"

@interface Access : NSObject 
{

}
// subclass should override this method
- (TreeExpr *)exprWithFramePointer:(TreeExpr *)framePtr;
@end
