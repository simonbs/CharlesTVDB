//
//  CharlesTVDB.h
//  CharlesTVDB
//
//  Created by Simon Støvring on 27/07/13.
//  Copyright (c) 2013 intuitaps. All rights reserved.
//

#import "CharlesMacros.h"

#ifndef _SYSTEMCONFIGURATION_H
    #import <SystemConfiguration/SystemConfiguration.h>
#endif
#if CharlesIsiOS
    #ifndef __UTTYPE__
        #import <MobileCoreServices/MobileCoreServices.h>
    #endif
#else

#endif
#import "CharlesClient.h"
#import "CharlesModels.h"