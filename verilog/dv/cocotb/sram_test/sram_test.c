#include <firmware_apis.h>

#define RAM_NUM_WORDS 128
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
  
  for (int i = 0; i < RAM_NUM_WORDS; i++){
    uint32_t test_data = 0xA5A5A5A5 ^ (i << 16);
    USER_writeWord(test_data, SRAM_BASE_OFFSET + i);
  }
  
  for (int i = 0; i < RAM_NUM_WORDS; i++){
    uint32_t expected = 0xA5A5A5A5 ^ (i << 16);
    uint32_t read_data = USER_readWord(SRAM_BASE_OFFSET + i);
    if (read_data != expected) {
      GPIOs_writeHigh(0b01);
      ManagmentGpio_write(1);
      return;
    }
  }
  
  ManagmentGpio_write(1);
}
