#include <firmware_apis.h>
#include "CF_TMR32.h"
#include "CF_UART.h"

#define PWM_BASE 0x30000000
#define PWM ((CF_TMR32_TYPE_PTR)PWM_BASE)

#define UART_BASE 0x30010000
#define UART ((CF_UART_TYPE_PTR)UART_BASE)

#define RAM_NUM_WORDS 256
#define SRAM_BASE_OFFSET (0x20000 / 4)

void CF_UART_setBaudRate(CF_UART_TYPE_PTR uart, uint32_t baud_rate, uint32_t clock_freq){
  uint32_t prescaler = (clock_freq / (baud_rate * 8)) - 1;
  CF_UART_setPrescaler(uart, prescaler);
  return;
}

void main(){
  ManagmentGpio_outputEnable();
  ManagmentGpio_write(0);
  
  enableHkSpi(0);
  
  GPIOs_configure(5, GPIO_MODE_USER_STD_OUTPUT);
  GPIOs_configure(6, GPIO_MODE_USER_STD_INPUT_PULLUP);
  GPIOs_configure(7, GPIO_MODE_USER_STD_OUTPUT);
  GPIOs_configure(32, GPIO_MODE_MGMT_STD_OUTPUT);
  GPIOs_configure(33, GPIO_MODE_MGMT_STD_OUTPUT);
  
  GPIOs_loadConfigs();
  User_enableIF();
  
  ManagmentGpio_write(1);
  
  GPIOs_writeHigh(0b00);
  
  for (int i = 0; i < RAM_NUM_WORDS; i++){
    uint32_t test_data = 0xA5A5A5A5 ^ (i << 16);
    USER_writeWord(test_data, SRAM_BASE_OFFSET + i);
  }
  
  int sram_pass = 1;
  for (int i = 0; i < RAM_NUM_WORDS; i++){
    uint32_t expected = 0xA5A5A5A5 ^ (i << 16);
    uint32_t read_data = USER_readWord(SRAM_BASE_OFFSET + i);
    if (read_data != expected) {
      sram_pass = 0;
      break;
    }
  }
  
  if (sram_pass) {
    GPIOs_writeHigh(0b10);
  } else {
    GPIOs_writeHigh(0b01);
  }
  
  CF_UART_setGclkEnable(UART, 1);
  CF_UART_enable(UART);
  CF_UART_setTxFIFOThreshold(UART, 3);
  CF_UART_enableTx(UART);
  CF_UART_enableRx(UART);
  CF_UART_setBaudRate(UART, 115200, 45000000);
  
  CF_UART_writeChar(UART, 'S');
  CF_UART_writeChar(UART, 'Y');
  CF_UART_writeChar(UART, 'S');
  CF_UART_writeChar(UART, '\n');
  
  CF_TMR32_configureExamplePWM(PWM);
  CF_TMR32_enable(PWM);
  
  ManagmentGpio_write(0);
  
  for(volatile int i = 0; i < 50000; i++);
  
  ManagmentGpio_write(1);
  
  return;
}
