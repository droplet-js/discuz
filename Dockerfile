# --- clone ---

FROM docker:git as clone

RUN git clone -b master https://gitee.com/ComsenzDiscuz/DiscuzX.git discuz

# config_ucenter_default.php 已经没有用了
# config 将被映射，移动并修改 config_global_default.php 的位置
RUN rm discuz/upload/config/config_ucenter_default.php; \
    cp -rf discuz/upload/config discuz/upload/config_default; \
    sed -i "s|./config/config_global_default.php|./config_default/config_global_default.php|g" discuz/upload/install/index.php

# --- prod ---

FROM php:7.3.0-apache as prod

MAINTAINER v7lin <v7lin@qq.com>

RUN docker-php-ext-install mysqli; \
    docker-php-ext-install pdo_mysql

COPY --from=clone /discuz/upload $PWD

RUN chmod a+w -R config data uc_server/data uc_client/data
