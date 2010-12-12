#ifndef STRIP_COMMENTS_H
#define STRIP_COMMENTS_H
#import "TRExpr.h"
// Print Abstract Syntax Tree with root: syntax
void prettyprint(NSMutableArray *indent, id syntax);
// Print Intermediate Tree
void treeprint(id expr);

void printIndent(NSMutableArray *indent);
void replaceLast(NSMutableArray *indent, int newIndent);
#endif
