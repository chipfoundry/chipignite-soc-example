#include <firmware_apis.h>
#include "CF_TMR32.h"

#define PWM_BASE 0x30000000
#define PWM ((CF_TMR32_TYPE_PTR)PWM_BASE)

void main() {
  ManagmentGpio_outputEnable();
  ManagmentGpio_write(0);

  enableHkSpi(0);

  GPIOs_configure(7, GPIO_MODE_USER_STD_OUTPUT);

  GPIOs_loadConfigs();
  User_enableIF();

  ManagmentGpio_write(1);

  CF_TMR32_configureExamplePWM(PWM);
  CF_TMR32_enable(PWM);

  return;
}
