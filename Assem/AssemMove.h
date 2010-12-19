//
//  AssemMove.h
//  Compiler
//
//  Created by Duan Dajun on 12/19/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "AssemInstr.h"
#import "TmpTemp.h"

@interface AssemMove : AssemInstr
{
	TmpTemp *dst;
  TmpTemp *src;
}
@property (readonly) TmpTemp *dst, *src;
- (id)initWithString:(NSString *)aString
     destinationTemp:(TmpTemp *)d
          sourceTemp:(TmpTemp *)s;
+ (id)assemMoveWithString:(NSString *)aString
          destinationTemp:(TmpTemp *)d
               sourceTemp:(TmpTemp *)s;
@end
