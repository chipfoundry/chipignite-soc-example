#include <firmware_apis.h>

#define RAM_NUM_WORDS 1024
#define SRAM_BASE_OFFSET (0x20000 / 4)

void main(){
  ManagmentGpio_outputEnable();
  ManagmentGpio_write(0);
  
  enableHkSpi(0);
  
  GPIOs_configure(32, GPIO_MODE_MGMT_STD_OUTPUT);
  GPIOs_configure(33, GPIO_MODE_MGMT_STD_OUTPUT);
  GPIOs_loadConfigs();
  
  User_enableIF();
  
  GPIOs_writeHigh(0b10);
  
  volatile int shifting;
  volatile int data_used;
  int start_address[3] = {0, (RAM_NUM_WORDS*4 / 10), (RAM_NUM_WORDS*9 / 10)};
  int end_address[3] = {(RAM_NUM_WORDS / 10), (RAM_NUM_WORDS*5 / 10), RAM_NUM_WORDS};
  
  for (int k = 0; k < 3; k++){
    for (int i = start_address[k]; i < end_address[k]; i++){
      shifting = 0xFFFFFFFF - (0x1 << (i%32));
      data_used = 0x55555555 & shifting;
      USER_writeWord(data_used, SRAM_BASE_OFFSET + i);
    }
    for (int i = start_address[k]; i < end_address[k]; i++){
      shifting = 0xFFFFFFFF - (0x1 << (i%32));
      data_used = 0x55555555 & shifting;
      int data = USER_readWord(SRAM_BASE_OFFSET + i);
      if (data_used != data) {
        GPIOs_writeHigh(0b01);
        ManagmentGpio_write(1);
        return;
      }
    }
  }
  
  ManagmentGpio_write(1);
}
