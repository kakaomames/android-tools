#!/bin/bash

# ==================================================
# 探検隊仕様：Termux Proot-Ubuntu用 Android-VNC-Canvas Sandbox
# ==================================================

# 1. パッケージのアップデートと画面共有一式の補給
apt-get update
apt-get install -y xvfb x11vnc fvwm websockify novnc libpulse0 libgl1 libglx-mesa0 unzip curl
echo "[ACTION] 最新の依存ライブラリと画面共有パッケージの補給が完了したぞ！"

# 2. JavaとAndroid SDKのセットアップ
apt-get install -y openjdk-17-jdk
mkdir -p $HOME/android-sdk/cmdline-tools
curl -L https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -o cmdline-tools.zip
unzip -q cmdline-tools.zip -d $HOME/android-sdk/cmdline-tools
mv $HOME/android-sdk/cmdline-tools/cmdline-tools $HOME/android-sdk/cmdline-tools/latest

# 環境変数の定義（ログ出力付き）
export ANDROID_HOME=$HOME/android-sdk
export ANDROID_AVD_HOME=$HOME/.android/avd
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools
echo "[ACTION] 環境変数の設定が完了したぞ！"
echo "[LOG] ANDROID_HOME=$ANDROID_HOME"
echo "[LOG] PATH=$PATH"

mkdir -p $ANDROID_AVD_HOME
echo "[ACTION] AVDの保存先ディレクトリを設定: $ANDROID_AVD_HOME"

# ライセンス承諾
yes | sdkmanager --licenses > /dev/null

# 【重要】スマホ(ARM64)環境に合わせて、system-imageをarm64に変更！
echo "[ACTION] Android 28 (ARM64) のシステムイメージをダウンロード中..."
sdkmanager "platform-tools" "emulator" "system-images;android-28;default;arm64-v8a" > /dev/null

# AVDの作成（イメージターゲットをarm64に変更）
echo "no" | avdmanager create avd -n test_android -k "system-images;android-28;default;arm64-v8a" --force
echo "[ACTION] AVD 'test_android' の作成コマンドが完了したぞ！"

# AVDの一覧ログを出力
echo "[ACTION] 作成されたAVDの一覧ログ:"
emulator -list-avds

# 3. 仮想ディスプレイ(Xvfb)とウィンドウマネージャ(fvwm)の起動
Xvfb :1 -screen 0 800x1280x24 &
export DISPLAY=:1
sleep 3
fvwm & 

# VNCサーバー起動
x11vnc -display :1 -nopw -listen localhost -forever -shared &
echo "[ACTION] 仮想ディスプレイ(:1)とVNCサーバー(5900)がバックグラウンドで起動したぞ！"

# エミュレータ起動用の環境変数再確認
export ANDROID_HOME=$HOME/android-sdk
export ANDROID_AVD_HOME=$HOME/.android/avd
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools
export DISPLAY=:1

echo "[ACTION] これからエミュレータを召喚する！ターゲット: test_android"
# KVMなし環境のため、-no-accel を付与
emulator -avd test_android -no-accel -no-audio -gpu swiftshader_indirect &

sleep 5
echo "[ACTION] エミュレータ起動プロセスの初期化を完了したぞ！"

# 4. noVNC(WebSocket)サーバーの起動
echo "[ACTION] websockify を使って VNCポート(5900) を Webポート(6080) に変換開始！"
websockify --web=/usr/share/novnc 6080 localhost:5900 &

sleep 10
echo "[ACTION] noVNC Webサーバーの起動待機が完了したぞ！"

# 5. Cloudflare Tunnel のセットアップ（ARM64版バイナリを取得）
echo "[ACTION] スマホ(ARM64)用の cloudflared を調達するぞ！"
curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64 -o cloudflared
chmod +x cloudflared

# トンネル開通
./cloudflared tunnel --url http://localhost:6080 > cloudflare.log 2>&1 &
sleep 5

echo "=================================================="
echo "🌐 【探検隊・ブラウザ接続URL】ここへ突入せよ！"
echo "=================================================="
grep -o 'https://[^ ]*trycloudflare.com' cloudflare.log || cat cloudflare.log
echo "=================================================="
echo "💡 もちろんスマホ自身のブラウザから http://localhost:6080/vnc.html でも繋がるぞ！"
echo "=================================================="

# 生存維持ループ
echo "[ACTION] キャンバスハック作戦、維持ループに突入！終了時は Ctrl+C を押してくれ！"
while true; do
    sleep 3600
done
