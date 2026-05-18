ARG BUILD_FROM
FROM $BUILD_FROM

RUN apk add --no-cache i2c-tools

# Copy data for add-on
COPY script.sh /

# Grant execution rights
RUN chmod a+x /script.sh

CMD [ "/script.sh" ]
