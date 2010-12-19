//
//  AssemOper.h
//  Compiler
//
//  Created by Duan Dajun on 12/19/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AssemInstr.h"
#import "TmpTempList.h"
#import "TmpLabelList.h"

@interface AssemOper : AssemInstr
{
	TmpTempList *dst;
  TmpTempList *src;
	TmpLabelList *targets;
}
- (id)initWithString:(NSString *)aString
 destinationTempList:(TmpTempList *)d
      sourceTempList:(TmpTempList *)s
           labelList:(TmpLabelList *)j;
- (id)initWithString:(NSString *)aString
 destinationTempList:(TmpTempList *)d
      sourceTempList:(TmpTempList *)s;
+ (id)operWithString:(NSString *)aString
 destinationTempList:(TmpTempList *)d
      sourceTempList:(TmpTempList *)s
           labelList:(TmpLabelList *)j;
+ (id)operWithString:(NSString *)aString
 destinationTempList:(TmpTempList *)d
      sourceTempList:(TmpTempList *)s;
@end
