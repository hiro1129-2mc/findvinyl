#ベースイメージ
FROM ruby:3.2.2

#環境変数
ENV TZ=Asia/Tokyo \
    LC_ALL=C.UTF-8

# yarnインストール
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - \
  && wget --quiet -O - /tmp/pubkey.gpg https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update -qq \
  && apt-get install -y nodejs yarn

#DBにpostgreSQLをインストール
RUN apt-get update && apt-get install -y postgresql-client vim

# 作業ディレクトリを指定
WORKDIR /findvinyl

# ホストのGemfileとGemfile.lockをコンテナにコピー
COPY Gemfile /findvinyl/Gemfile
COPY Gemfile.lock /findvinyl/Gemfile.lock

# bundle installを実行
RUN bundle install

# ホストのカレントディレクトリをコンテナにコピー
COPY . /findvinyl

# entrypoint.shをコンテナ内の/usr/binにコピーし、実行権限を与える
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

#コンテナがリッスンするPORTを指定
EXPOSE 3000

# ENTRYPOINTを指定
ENTRYPOINT ["entrypoint.sh"]
