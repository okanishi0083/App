#!/bin/zsh

# Dockerイメージの名前
IMAGE_NAME="my_app"
# Docker イメージの存在確認
if [[ "$(docker images -q $IMAGE_NAME 2> /dev/null)" == "" ]]; then
  echo "初回実行: Dockerイメージをビルドします。"
  docker-compose build --no-cache
  echo "初回実行: Dockerイメージをビルド完了。"
else
  echo "既存のDockerイメージが見つかりました。ビルドをスキップします。"
fi

# 初回立ち上げの場合、コマンド実行 
# フラグファイルのパス
FLAG_FILE=".initialized"
if [ ! -f $FLAG_FILE ]; then
  echo "初回です。docker-compose runを実行します"
  docker-compose run --rm app sh -c 'npm create vite@latest react-app -- --template react-ts'
  echo "初回のdocker-compose up -dを実行します"
  docker-compose up -d
  # 初回実行が終わったことを示すフラグファイルを作成
  touch $FLAG_FILE
else
  echo "2回目以降のdocker-compose up -dを実行します"
  docker-compose up -d
fi

# ローカル環境立ち上げ
docker exec -it app sh -c "npm install && npm run dev -- --host"
