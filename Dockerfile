# FROM cdrx/pyinstaller-linux:python3 AS build
FROM python:3.6 AS build

RUN apt-get update
ENV APP_NAME='sam-check'

RUN mkdir /x_src
WORKDIR /x_src
ADD . /x_src
RUN pip3 install -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com .
RUN pip3 install -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com pyinstaller
RUN pyinstaller --clean -y  --workpath /tmp  $APP_NAME.py -n $APP_NAME
# RUN mkdir -p /x_src/dist/$APP_NAME/asynqp
# RUN cp /usr/local/lib/*/*/asynqp/amqp*.xml /x_src/dist/$APP_NAME/asynqp/


# This results in a sing layer image
# FROM  ubuntu:16.04

# RUN apt-get update
FROM debian:9-slim
ENV APP_NAME='sam-check'

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
ENV TZ=Asia/Shanghai
RUN echo $TZ > /etc/timezone && \
    apt-get install -y tzdata && \
    rm /etc/localtime && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    apt-get clean

# clean
RUN apt-get autoremove \
    && rm -rf /var/cache/apt/* \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=build /x_src/dist/sam-check /app

EXPOSE 80
ENV NAME check

# need to set env for app
ENV SVC_URI http://localhost:18088/v2/system
ENV DB_URI mongodb://mongo:27017/mean
ENV SVC_PORT 80

# run the application
COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["sam-check"]
