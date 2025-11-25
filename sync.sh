#!/bin/bash

# ==========================================
# Obsidian Git 自动同步脚本
# 功能：先拉取远程更新，再提交本地修改，最后推送
# ==========================================

echo "🔄 [1/4] 正在尝试从 GitHub 拉取最新更新..."
git pull
if [ $? -ne 0 ]; then
    echo "⚠️ 拉取出现冲突或错误！请手动解决冲突后再运行。"
    exit 1
fi

echo "📦 [2/4] 正在添加所有文件变更..."
git add .

# 获取当前时间作为提交信息
current_time=$(date "+%Y-%m-%d %H:%M:%S")
commit_message="自动同步: $current_time"

echo "💾 [3/4] 正在提交: $commit_message"
git commit -m "$commit_message"

# 注意：如果只是为了同步而不一定有新修改，commit 可能会提示无变更，这很正常
# 所以这里不检查 commit 的退出码，直接尝试 push

echo "🚀 [4/4] 正在推送到 GitHub..."
git push

if [ $? -eq 0 ]; then
    echo "✅ 同步成功！"
else
    echo "❌ 推送失败，请检查网络或手动执行 git push 查看详情。"
fi
