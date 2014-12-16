//
//  common.cpp
//  pad-png-exporter
//
//  Created by darklinden on 12/16/14.
//  Copyright (c) 2014 darklinden. All rights reserved.
//

#include "common.h"
#include <stdlib.h>

void abort_(const char * s, ...)
{
    va_list args;
    va_start(args, s);
    vfprintf(stderr, s, args);
    fprintf(stderr, "\n");
    va_end(args);
    abort();
}