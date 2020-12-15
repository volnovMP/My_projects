#ifndef __APPLIBS__
#define __APPLIBS__


#ifdef APPLIBS_EXPORTS
#define APPLIBS_API __declspec(dllexport)
#else
#define APPLIBS_API __declspec(dllimport)
#endif

#ifdef __cplusplus
extern "C" {
#endif 
__declspec(dllimport) bool AppLibsInit(void);
APPLIBS_API void AppLibsDeInit(void);
APPLIBS_API bool SetDigitalOutput(int DoNumber, int Level);
APPLIBS_API bool GetDigitalOutput(int DoNumber, int *level);
APPLIBS_API bool GetDigitalInput(int DiNumber, int *level);
APPLIBS_API bool GetAnalogInput(int channel, int *AiData);
APPLIBS_API bool LcmClear(void);
APPLIBS_API bool LcmDisplay(char* LcmString, int dwLen);
APPLIBS_API bool WDTGetRange(int *max, int *min);
APPLIBS_API bool WDTStart(int timeout) ;
APPLIBS_API bool WDTStop(void);
#ifdef __cplusplus
}

#endif // __cplusplus

#endif // __APPLIBS__