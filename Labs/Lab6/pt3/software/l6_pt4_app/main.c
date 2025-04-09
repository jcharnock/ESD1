
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

unsigned char *ledsBase_ptr        = (unsigned char *) LEDS_BASE;
uint32 *uintPushbuttonBase_Ptr     = (uint32*) KEY1_BASE;
uint8 *ramBase8_ptr                = (uint8*) RAMINFR_BE_0_BASE;
uint16 *ramBase16_ptr                = (uint16*) RAMINFR_BE_0_BASE;
uint32 *ramBase32_ptr                = (uint32*) RAMINFR_BE_0_BASE;

int checkFlag = 1;

uint32 Ram8bTest(uint32 address, uint32 ramSize, uint8 testData){
	*ledsBase_ptr = 0x0000;
	// write ram data
	for(int i = 0; i < ramSize; i++){
		*(ramBase8_ptr + i) = testData;
		// *(ramBase8_ptr + 2) = 0xFF; // intentional fail

		if (*(ramBase8_ptr + i) != testData){
			*ledsBase_ptr = 0xFFFF;
			printf("Data does not match: (Address: 0x%08x, Read: 0x%08x, Expected: 0x%08x) \n", address, *(ramBase8_ptr + i), testData);
			return 1;
		}
	}
	return 0;
}

uint32 Ram16bTest(uint32 address, uint32 ramSize, uint16 testData){
	*ledsBase_ptr = 0x0000;
	// write ram data
	for(int i = 0; i < ramSize; i++){
		*(ramBase16_ptr + i) = testData;
		// *(ramBase16_ptr + 2) = 0xFFFF; // intentional fail

		if (*(ramBase16_ptr + i) != testData){
			*ledsBase_ptr = 0xFFFF;
			printf("Data does not match: (Address: 0x%08x, Read: 0x%08x, Expected: 0x%08x) \n", address, *(ramBase16_ptr + i), testData);
			return 1;
		}
	}
	return 0;
}

uint32 Ram32bTest(uint32 address, uint32 ramSize, uint32 testData){
	*ledsBase_ptr = 0x0000;
	// write ram data
	for(int i = 0; i < ramSize; i++){
		*(ramBase32_ptr + i) = testData;
		// *(ramBase32_ptr + 2) = 0xFFFFFFFF; // intentional fail

		if (*(ramBase32_ptr + i) != testData){
			*ledsBase_ptr = 0xFFFF;
			printf("Data does not match: (Address: 0x%08x, Read: 0x%08x, Expected: 0x%08x) \n", address, *(ramBase32_ptr + i), testData);
			return 1;
		}
	}
	return 0;
}

void pushbutton_isr (void *context){
	*ledsBase_ptr = 0x2222;
	checkFlag = 0;
	printf("RAM TEST DONE \n");
	*(uintPushbuttonBase_Ptr + 3) &= ~0x02;
}


int main(){

	*ledsBase_ptr = 0x0000;
	unsigned char pushbutton;

	// enable irq for key 1
	*(uintPushbuttonBase_Ptr + 2) |= 0x02;
	*(uintPushbuttonBase_Ptr + 3) = 0x02;

	alt_ic_isr_register(KEY1_IRQ_INTERRUPT_CONTROLLER_ID,KEY1_IRQ,pushbutton_isr,0,0);

	while(1){
		// run ram tests indefinitely until IRQ press
		while (checkFlag != 0) {
			Ram8bTest(0x0000, 16384, 0x00);
			Ram16bTest(0x0000, 8192, 0x1234);
			Ram32bTest(0x0000, 4096, 0xABCDEF90);
		}
	}

}
