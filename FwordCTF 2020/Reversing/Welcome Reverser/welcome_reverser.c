#include <stdlib.h>
typedef unsigned long ulong;

ulong hash1(char *param_1)
{
  size_t sVar1;
  uint local_20;
  int local_1c;
  
  local_20 = 0;
  local_1c = 1;
  while( 1 ) {
    sVar1 = strlen(param_1);
    if (sVar1 <= (ulong)(long)local_1c) break;
    local_20 = ((int)param_1[local_1c] - 0x30U | ~local_20) * 2 +
               ((int)param_1[local_1c] - 0x30U ^ local_20) + ~local_20 * -2;
    local_1c = local_1c + 2;
  }
  return (ulong)local_20;
}

ulong hash2(char *param_1)
{
  size_t sVar1;
  uint local_2c;
  uint local_28;
  uint local_24;
  
  local_2c = 0;
  local_24 = 0;
  while( 1 ) {
    sVar1 = strlen(param_1);
    if (sVar1 <= (ulong)(long)(int)local_24) break;
    local_28 = ((int)param_1[(int)local_24] + -0x30) * 2;
    if (0 < (int)(~(local_28 ^ 0xfffffff7) * 2 + (~local_28 & 0xfffffff7) * 3 + (local_28 & 8) * 3 +
                 ~(local_28 & 0xfffffff7) * -2)) {
      local_28 = ((int)local_28 / 10 & (int)local_28 % 10) * 2 +
                 ((int)local_28 / 10 ^ (int)local_28 % 10);
    }
    local_2c = local_2c + local_28;
    local_24 = (local_24 & 0xfffffffd) * 2 + (4 - (local_24 ^ 2));
  }
  return (ulong)local_2c;
}

int main(int argc, char **argv)
{
    char *input = "1111111111111117";
    printf("%lu", hash1(input)+hash2(input));
    return 0;
}