//
//  MipsInReg.h
//  Compiler
//
//  Created by Duan Dajun on 12/7/10.
//  Copyright 2010 SJTU. All rights reserved.
//

#import "TmpTemp.h"
#import "Access.h"

@interface MipsInReg : Access
{
	TmpTemp *temp;
}
@property (retain) TmpTemp *temp;
- (id)initWithTemp:(TmpTemp *)aTemp;
+ (id)inRegWithTemp:(TmpTemp *)aTemp;
@end
