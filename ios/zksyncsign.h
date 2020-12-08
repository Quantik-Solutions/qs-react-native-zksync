//
//  zksyncsign.h
//  ZkSync
//
//  Created by dev user on 12/7/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

#ifndef zksyncsign_h
#define zksyncsign_h

#include <stdio.h>

#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

char *public_key_hash_from_private_key(const char *private_key);

char *private_key_from_seed(const char *seed);

char *public_key_from_private_key(const char *private_key);

char *sign_musig(const char *private_key, const char *txn_msg);

void string_release(char *s);


#endif /* zksyncsign_h */
