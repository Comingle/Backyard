FROM rails:onbuild

RUN apt-get update && apt-get install -y \
    arduino-core \
    python \
    python-setuptools \
    python-jinja2 \
    python-serial \
    gcc-avr

RUN git clone https://github.com/miracle2k/python-glob2.git /usr/src/python-glob2 && cd /usr/src/python-glob2 && python setup.py install

RUN cp -R /usr/share/arduino/hardware/arduino/cores/arduino /usr/share/arduino/hardware/arduino/cores/arduino-noHID && cp /usr/src/app/deps/USBDesc.h /usr/share/arduino/hardware/arduino/cores/arduino-noHID/USBDesc.h

RUN git clone git://github.com/amperka/ino.git /usr/src/ino && cd /usr/src/ino && make install

RUN git clone https://github.com/Comingle/OSSex.git /usr/share/arduino/libraries/OSSex

COPY deps/boards.txt /usr/share/arduino/hardware/arduino/boards.txt
COPY deps/twi.c /usr/share/arduino/libraries/Wire/utility/twi.c
COPY deps/twi.h /usr/share/arduino/libraries/Wire/utility/twi.h

RUN rake db:migrate

EXPOSE 3000
