# VACP (Vaccine Availability Check Powershell) #
**Author: *Swapnil Mengi***

**Email: *swapnilmengi31@outlook.com***

**Tested on Powershell: *5.1***

**License:'*GPLv2***

**License URI: *http://www.gnu.org/licenses/gpl-2.0.html***

# Description
The script extends support for vaccine availability checks and booking vaccine slot from system.

# Installation
It is recommended to clone the repository on your system, update the neccasary variables and add to task scheduler. For booking use the other script after you recive avaialability notification.

# Notification
The script by default is configured to run with slack, update the webhook variable for slack workplace.

# Booking
Use the slot booking script with updated parameters to book the slot at convinience, you will be required to enter your OTP and CAPTCHA as prompted in order to complete the booking.

# Disclaimer
**The script has been created to extend support and not meant to be used inappropriately or for malicious purposes.**

***API calls are limited to 100 calls every 5 mins for a public address; restrict the calls to bare minimum in order run execute the script smoothly without causing inconvinience to production network or anyone else***



