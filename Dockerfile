FROM alpine AS resource

RUN apk -U --no-cache update \
    && apk -U --no-cache upgrade \
    && apk -U --no-cache --allow-untrusted add dos2unix \
    && mkdir /res

COPY docker-entrypoint.sh /res/entrypoint.sh

RUN dos2unix /res/entrypoint.sh \
    && chmod +x /res/entrypoint.sh


FROM node:lts-alpine AS runtime

RUN echo "@edge http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk -U --no-cache update \
    && apk -U --no-cache upgrade \
    && apk -U --no-cache --allow-untrusted add git chromium nss freetype harfbuzz ca-certificates ttf-freefont font-wqy-zenhei@edge

RUN git config --global --add safe.directory '*' \
    && git config --global pull.rebase false \
    && git config --global user.email "Yunzai@yunzai.bot" \
    && git config --global user.name "Yunzai"

RUN rm -rf /var/cache/* \
    && rm -rf /tmp/*


FROM runtime AS prod

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

RUN git clone --depth=1 --branch master https://gitee.com/yoimiya-kokomi/Yunzai-Bot.git /app/Yunzai-Bot \
    && cd /app/Yunzai-Bot \
    && npm install

COPY --from=resource /res/entrypoint.sh /app/Yunzai-Bot/entrypoint.sh

ENTRYPOINT ["/app/Yunzai-Bot/entrypoint.sh"]
