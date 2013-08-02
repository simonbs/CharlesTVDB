//
//  CharlesMacros.h
//  
//
//  Created by Simon Støvring on 02/08/13.
//
//

#define CharlesIsOSX defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
#define CharlesIsiOS defined(__IPHONE_OS_VERSION_MIN_REQUIRED)

#if CharlesIsOSX
    #define CharlesImage NSImage
#else
    #define CharlesImage UIImage
#endif