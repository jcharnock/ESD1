
#include "io.h"
#include <stdio.h>
#include "system.h"
#include "alt_types.h"
#include "sys/alt_irq.h"

typedef   signed char   sint8;              // signed 8 bit values
typedef unsigned char   uint8;              // unsigned 8 bit values
typedef   signed short  sint16;             // signed 16 bit values
typedef unsigned short  uint16;             // unsigned 16 bit values
typedef   signed long   sint32;             // signed 32 bit values
typedef unsigned long   uint32;             // unsigned 32 bit values
typedef         float   real32;             // 32 bit real values

unsigned char *ledsBase_ptr   = (unsigned char *) LEDS_BASE;
uint32 *ramBase_ptr           = (uint32*) INFERRED_RAM_BASE;

void byteRamTest(uint32 startAddr, uint8 numTestBytes, uint32 testData){
	*ledsBase_ptr = 0x0000;
	int readData[numTestBytes];
	*(uintServoComponentBase_Ptr + i) = testData;
	// write ram data
	for(int i = 0; i < numTestBytes; i++){
		*(uintServoComponentBase_Ptr + i) = testData;
	}

	// read ram data
	for(int j = 0; j < numTestBytes; j++){
		// read ram data to the temp read array
		readData[j] = *(uintServoComponentBase_Ptr + j);
		// if the readData doesnt equal the testData light
		// all leds and break function
		if (readData[j] != testData){
			*ledsBase_ptr = 0x0008;
			return;
		}
	}
	return;
}

void b16RamTest(uint32 startAddr, uint16 numTestBytes, uint32 testData){
	*ledsBase_ptr = 0x0000;
	int readData[numTestBytes];
	*(uintServoComponentBase_Ptr + i) = testData;
	// write ram data
	for(int i = 0; i < numTestBytes; i++){
		*(uintServoComponentBase_Ptr + i) = testData;
	}

	// read ram data
	for(int j = 0; j < numTestBytes; j++){
		// read ram data to the temp read array
		readData[j] = *(uintServoComponentBase_Ptr + j);
		// if the readData doesnt equal the testData light
		// all leds and break function
		if (readData[j] != testData){
			*ledsBase_ptr = 0x0008;
			return;
		}
	}
	return;
}

void b32RamTest(uint32 startAddr, uint32 numTestBytes, uint32 testData){
	*ledsBase_ptr = 0x0000;
	int readData[numTestBytes];
	*(uintServoComponentBase_Ptr + i) = testData;
	// write ram data
	for(int i = 0; i < numTestBytes; i++){
		*(uintServoComponentBase_Ptr + i) = testData;
	}

	// read ram data
	for(int j = 0; j < numTestBytes; j++){
		// read ram data to the temp read array
		readData[j] = *(uintServoComponentBase_Ptr + j);
		// if the readData doesnt equal the testData light
		// all leds and break function
		if (readData[j] != testData){
			*ledsBase_ptr = 0x0008;
			return;
		}
	}
	return;
}


int main(){

	*ledsBase_ptr = 0x0000;
	*(uintPushbuttonBase_Ptr + 2) |= 0x04;
	*(uintPushbuttonBase_Ptr + 3)  = 0x04;

	if ((pushbutton & 0x0004) == 0){
	        	while((pushbutton & 0x0002) == 0){
	        		pushbutton = *pushbuttonsBase_ptr;
	        		if ((pushbutton & 0x0002) != 0) break;
	        	}
	      // ramp test polling shit
	}
}
