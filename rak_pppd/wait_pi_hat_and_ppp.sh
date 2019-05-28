#!/bin/sh

cd /opt/RAKLTE/rak_pppd
./pi-hat.sh &
/opt/RAKLTE/rak_pppd/enable_lte_module.sh
sleep 5
./wait_pi_hat_and_ppp 115200 &
        
