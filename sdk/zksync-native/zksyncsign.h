#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

char *public_key_hash_from_private_key(const char *private_key);

char *private_key_from_seed(const char *seed);

char *public_key_from_private_key(const char *private_key);

char *sign_musig(const char *private_key, const char *txn_msg);

void string_release(char *s);
