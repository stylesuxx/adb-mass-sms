adb-mass-sms
============
Set ADB variable to the adb executable.

Examples:

Send a text to all numbers from 0 to 1000:
./sms.sh "Here comes the text" -r 0-1000

Send a text to all numbers from 0 to 10 and 50 to 60
./sms.sh "Here comes the text" -r 0-10 -r 50-60

Send a text to a list of numbers from file (one number per line):
./sms.sh "Here comes the text" -l /path/to/numbers.txt

Send a text to a list of numbers from file (one number per line) and to a range from 10-100:
./sms.sh "Here comes the text" -l /path/to/numbers.txt -r 10-100



