# Home Sensor iOS

## To generate certificate file from private key, server certificate and client certificate

$ openssl pkcs12 -legacy -export -out certificate_legacy.p12 -inkey home_sensor.private.key -in home_sensor.cert.pem -certfile root-CA.crt

