#undef __STDC__
#include <stdio.h>

void *malloc(int size)
{
  void *ans;
  return ans;
}

int *initArray(int *base, int size, int init)
{
	int i;
	for(i = 0; i < size; i++)
		base[i] = init;
	return base;
}

char *chars[128];
int main()
{
	int i;
	for (i = 0; i < 128; ++i) {
		chars[i] = malloc(2);
    chars[i][0] = i;
    chars[i][1] = '\0';
  }
	return tigermain(0 /* static link!? */);
}

void exit(int *sl, int i)
{
}

void print(int *sl, char *s)
{
}

void printi(int *sl, int i)
{
}

void flush()
{
}

char *tigergetchar()
{
	int i = getc(stdin);
	if (i == EOF)
		return "";
	else
		return chars + i;
}

int ord(int *sl, char *s)
{
	if (!s[0])
		return -1;
	else
		return s[0];
}

char *chr(int *sl, int i)
{
	if (i < 0 || i > 127) 
	{
		exit(sl, 1);
	}
	return chars + i;
}

int size(int *sl, char *s)
{ 
  int len = 0;
  for (; *s; s++)
    len++;
	return len;
}

char *substring(int *sl, char *s, int first, int n)
{
	int length = size(sl, s);
	if (first < 0 || first + n > length)
	{
    exit(sl, 1);
	}
	if (n == 1)
		return chars + s[first];
	else {
		char *t = malloc((n + 1) * sizeof(char));
    int i = 0;
    while (n > 0) {
    	t[i] = s[first + i];
      i++;
      n--;
    }
		t[i] = '\0';
		return t;
	}
}

char *concat(int *sl, char *a, char *b)
{
	int lengtha = size(sl, a);
	int lengthb = size(sl, b);
	if (lengtha == 0)
		return b;
	else if (lengthb == 0)
		return a;
	else {
		int i, n = lengtha + lengthb;
		char *t = malloc((n + 1) * sizeof(char));
    char *tmp = t;
    while (*(t++) = *(a++));
    t--;
    while (*(t++) = *(b++));
		return tmp;
	}
}

int tigernot(int *sl, int i)
{ 
	return !i;
}
