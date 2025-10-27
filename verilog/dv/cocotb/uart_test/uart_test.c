#include <firmware_apis.h>
#include "CF_UART.h"

#define UART_BASE 0x30010000
#define UART ((CF_UART_TYPE_PTR)UART_BASE)

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

  GPIOs_loadConfigs();
  User_enableIF();
  ManagmentGpio_write(1);

  CF_UART_setGclkEnable(UART, 1);
  CF_UART_enable(UART);
  CF_UART_setTxFIFOThreshold(UART,3);
  CF_UART_enableTx(UART);
  CF_UART_enableRx(UART);

  CF_UART_setBaudRate(UART, 115200, 45000000);

  CF_UART_writeChar(UART, 'H');
  CF_UART_writeChar(UART, 'e');
  CF_UART_writeChar(UART, 'l');
  CF_UART_writeChar(UART, 'l');
  CF_UART_writeChar(UART, 'o');
  CF_UART_writeChar(UART, ' ');
  CF_UART_writeChar(UART, 'U');
  CF_UART_writeChar(UART, 'A');
  CF_UART_writeChar(UART, 'R');
  CF_UART_writeChar(UART, 'T');
  CF_UART_writeChar(UART, '\n');

  return;
}
