#undef __STDC__
#include <stdio.h>
#include <stdlib.h>
#import <string.h>

int *initArray(int *base, int size, int init)
{
	int i;
	for(i = 0; i < size; i++)
		base[i] = init;
	return base;
}

void print(char *s)
{
	printf("%s", s);
}

void printi(int i)
{
	printf("%d", i);
}

void flush()
{
	fflush(stdout);
}

char chars[128];
int main()
{
	int i;
	for (i = 0; i < 128; ++i)
		chars[i] = i;
	return tigermain(0 /* static link!? */);
}

int ord(char *s)
{
	if (!s[0])
		return -1;
	else
		return s[0];
}

char *chr(int i)
{
	if (i < 0 || i > 127) 
	{
		printf("chr(%d) out of range\n", i);
		exit(1);
	}
	return chars + i;
}

int size(char *s)
{ 
	return strlen(s);
}

char *substring(char *s, int first, int n)
{
	int length = strlen(s);
	if (first < 0 || first + n > length)
	{
		printf("substring([%d], %d, %d) out of range\n", length, first, n);
    exit(1);
	}
	if (n == 1)
		return chars + s[first];
	else {
		char *t = malloc((n + 1) * sizeof(char));
		strncpy(t, s + first, n);
		t[n] = '\0';
		return t;
	}
}

char *concat(char *a, char *b)
{
	int lengtha = strlen(a);
	int lengthb = strlen(b);
	if (lengtha == 0)
		return b;
	else if (lengthb == 0)
		return a;
	else {
		int i, n = lengtha + lengthb;
		char *t = malloc((n + 1) * sizeof(char));
		strcpy(t, a);
		strcat(t, b);
		return t;
	}
}

int not(int i)
{ 
	return !i;
}

#undef getchar

char *getchar()
{
	int i = getc(stdin);
	if (i == EOF)
		return "";
	else
		return chars + i;
}
