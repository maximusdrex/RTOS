esptool.py --port /dev/ttyUSB0 write_flash 0x00000 bin/eagle.flash.bin 0x10000 bin/eagle.irom0text.bin 0x3FC000 bin/esp_init_data_default_v08.bin 0x3FE000 bin/blank.bin 0x3FB000 bin/blank.bin

