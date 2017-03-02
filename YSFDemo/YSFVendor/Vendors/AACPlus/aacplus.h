
#ifndef _AACPLUS_H_
#define _AACPLUS_H_

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

typedef void *aacplusEncHandle;

typedef enum {
	AACPLUS_INPUT_16BIT = 0,
	AACPLUS_INPUT_FLOAT,
} aacplusInFormat;


typedef  struct {
  int   sampleRate;
  int   bitRate;                 ///< bits per second
  int   nChannelsIn;
  int   nChannelsOut;
  int   bandWidth;
  aacplusInFormat   inputFormat;
  int   outputFormat;            ///< 0 - raw, 1 - adts
  int   nSamplesPerFrame;        ///< 1024 by default, (960 - for dab+/drm not working yet)
  int   inputSamples;            ///< number of input samples to use, usable after aacplusEncSetConfiguration() call
} aacplusEncConfiguration;

aacplusEncConfiguration *aacplusEncGetCurrentConfiguration(aacplusEncHandle hEncoder);


int aacplusEncSetConfiguration(aacplusEncHandle hEncoder,
        aacplusEncConfiguration *cfg);


aacplusEncHandle aacplusEncOpen(unsigned long sampleRate,
				  unsigned int numChannels,
				  unsigned long *inputSamples,
				  unsigned long *maxOutputBytes);


int aacplusEncGetDecoderSpecificInfo(aacplusEncHandle hEncoder, unsigned char **ppBuffer,
					  unsigned long *pSizeOfDecoderSpecificInfo);


int aacplusEncEncode(aacplusEncHandle hEncoder, int32_t *inputBuffer, unsigned int samplesInput,
			 unsigned char *outputBuffer,
			 unsigned int bufferSize);


int aacplusEncClose(aacplusEncHandle hEncoder);


#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif /* _AACPLUS_H_ */
