
#include "system.h"

const unsigned char ssdValues[9] = {0x40, 0x79, 0x24, 0x30, 0x19, 0x12, 0x02, 0x78, 0x00, 0x10};

void main(){
    
    unsigned char *switchesBase_ptr    = (unsigned char *) INSERT_BASE_NAME;
    unsigned char *ledsBase_ptr        = (unsigned char *) INSERT_BASE_NAME;
    unsigned char *pushbuttonsBase_ptr = (unsigned char *) INSERT_BASE_NAME;
    volatile unsigned char pushbutton;
    volatile bool slideswitch;
    int N;
    
    while(1){
        
        # read in switch and pushbutton data
        pushbutton = *pushbuttonsBase_ptr;
        slideswitch = *switchesBase_ptr;
        # check if button is pressed
        if((pushbutton & 0x02) == 0){
            
            # read in slideswitch value, if zero decrement
            # else increment
            if((slideswitch & 0x01) == 0){
                # if array position is 9 then break to main
                # else increment by 1 and and write to LEDs
                if (N == 0){
                    return;
                }
                else {
                    N += 1;
                    *ledsBase_ptr = ssdValues[N];
                }
            }
            else {
                # if array position is 0 then break to main
                # else decrement by 1 and write to LEDs
                if (N == 9){
                    return;
                }
                else {
                    N -= 1;
                    *ledsBase_ptr = ssdValues[N];
                }
            }
            # hold until button is released
            while((pushbutton & 0x02) == 0){}
        }
                        
    }
    
}