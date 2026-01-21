#!/bin/bash
#
# GitHubのissuesを取得し、指定のディレクトリ構成で配置するスクリプト
#
# 使用方法:
#   ./sync-github-issues.sh [--repo OWNER/REPO] [--output-dir DIR]
#
# 必要条件:
#   - GitHub CLI (gh) がインストールされていること
#   - jq がインストールされていること
#

set -e

# デフォルト値
OUTPUT_DIR="GitHub/issues"
REPO=""

# 引数のパース
while [[ $# -gt 0 ]]; do
    case $1 in
        --repo)
            REPO="$2"
            shift 2
            ;;
        --output-dir)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        -h|--help)
            echo "使用方法: $0 [--repo OWNER/REPO] [--output-dir DIR]"
            echo ""
            echo "オプション:"
            echo "  --repo OWNER/REPO    リポジトリ名（例: owner/repo）"
            echo "                       指定しない場合は現在のリポジトリを使用"
            echo "  --output-dir DIR     出力ディレクトリ（デフォルト: GitHub/issues）"
            exit 0
            ;;
        *)
            echo "不明なオプション: $1"
            exit 1
            ;;
    esac
done

# 必要なコマンドのチェック
check_command() {
    if ! command -v "$1" &> /dev/null; then
        echo "エラー: $1 がインストールされていません。"
        exit 1
    fi
}

check_command "gh"
check_command "jq"

# リポジトリ情報の取得
if [[ -z "$REPO" ]]; then
    REPO=$(gh repo view --json nameWithOwner -q '.nameWithOwner' 2>/dev/null || true)
    if [[ -z "$REPO" ]]; then
        echo "エラー: リポジトリ情報を取得できませんでした。--repo オプションで指定してください。"
        exit 1
    fi
fi

echo "リポジトリ: $REPO"
echo "issuesを取得中..."

# issuesを取得（全状態、最大500件）
ISSUES=$(gh issue list --repo "$REPO" --state all --limit 500 --json number,title,body,labels,state,url)

ISSUE_COUNT=$(echo "$ISSUES" | jq 'length')
echo "取得したissues数: $ISSUE_COUNT"

# ファイル名をサニタイズする関数
sanitize_filename() {
    local name="$1"
    # ファイル名に使用できない文字を置換
    name=$(echo "$name" | sed 's/[<>:"\/\\|?*]/_/g')
    # 先頭・末尾の空白やドットを削除
    name=$(echo "$name" | sed 's/^[. ]*//; s/[. ]*$//')
    # 長すぎる場合は切り詰め
    if [[ ${#name} -gt 200 ]]; then
        name="${name:0:200}"
    fi
    echo "$name"
}

# issueのMarkdownファイルを作成する関数
create_issue_file() {
    local file_path="$1"
    local issue_json="$2"
    
    # ディレクトリを作成
    mkdir -p "$(dirname "$file_path")"
    
    local body=$(echo "$issue_json" | jq -r '.body // ""')
    
    if [[ -n "$body" && "$body" != "null" ]]; then
        echo "$body" > "$file_path"
    else
        echo "" > "$file_path"
    fi
}

# 親PBIのbodyから子issue番号を抽出する関数
extract_child_issue_numbers() {
    local body="$1"
    
    if [[ -z "$body" || "$body" == "null" ]]; then
        echo ""
        return
    fi
    
    # 複数のパターンでissue番号を抽出
    # パターン1: /issues/番号
    # パターン2: #番号（単語境界で）
    local numbers=""
    
    # /issues/番号 のパターン
    local issues_pattern=$(echo "$body" | grep -oE '/issues/[0-9]+' | grep -oE '[0-9]+' | sort -u)
    
    # #番号 のパターン（タスクリストなどで使われる）
    local hash_pattern=$(echo "$body" | grep -oE '#[0-9]+' | grep -oE '[0-9]+' | sort -u)
    
    # 両方の結果を結合して重複を除去
    numbers=$(echo -e "${issues_pattern}\n${hash_pattern}" | sort -u | grep -v '^$' || true)
    
    echo "$numbers"
}

# 出力ディレクトリを作成（既存の内容をクリア）
rm -rf "${OUTPUT_DIR:?}"
mkdir -p "$OUTPUT_DIR"

# 一時ファイル
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

# issueをnumber -> jsonのマップとして保存
echo "$ISSUES" | jq -c '.[]' > "$TEMP_DIR/all_issues.jsonl"

# 「product backlog」ラベルを持つissueをPBIとして抽出
PBI_FILE="$TEMP_DIR/pbi_issues.jsonl"
echo "$ISSUES" | jq -c '.[] | select(.labels | map(.name | ascii_downcase) | index("product backlog"))' > "$PBI_FILE"

PBI_COUNT=$(wc -l < "$PBI_FILE" | tr -d ' ')
echo "PBI数: $PBI_COUNT"

# PBI番号のリストを作成
PBI_NUMBERS=$(cat "$PBI_FILE" | jq -r '.number' | tr '\n' ' ')

# 子issueとして割り当てられたissue番号を記録
ASSIGNED_CHILDREN="$TEMP_DIR/assigned_children.txt"
touch "$ASSIGNED_CHILDREN"

# PBIディレクトリを作成し、子issueを特定
while read -r pbi; do
    [[ -z "$pbi" ]] && continue
    
    pbi_num=$(echo "$pbi" | jq -r '.number')
    pbi_title=$(echo "$pbi" | jq -r '.title')
    pbi_body=$(echo "$pbi" | jq -r '.body // ""')
    pbi_dir_name=$(sanitize_filename "$pbi_title")
    
    pbi_dir="$OUTPUT_DIR/$pbi_dir_name"
    mkdir -p "$pbi_dir/sub-issues"
    
    # PBIファイルを作成（issue番号 - タイトル.md）
    pbi_file_name=$(sanitize_filename "$pbi_title")
    pbi_file="$pbi_dir/${pbi_num} - ${pbi_file_name}.md"
    create_issue_file "$pbi_file" "$pbi"
    echo "作成: $pbi_file"
    
    # このPBIのbodyから子issue番号を抽出
    child_numbers=$(extract_child_issue_numbers "$pbi_body")
    
    # 子issueを処理
    for child_num in $child_numbers; do
        # 自分自身はスキップ
        [[ "$child_num" == "$pbi_num" ]] && continue
        
        # 他のPBIはスキップ
        if echo "$PBI_NUMBERS" | grep -qw "$child_num"; then
            continue
        fi
        
        # 子issueを取得
        child_issue=$(grep -E "\"number\":${child_num}[,}]" "$TEMP_DIR/all_issues.jsonl" 2>/dev/null || true)
        
        if [[ -n "$child_issue" ]]; then
            child_title=$(echo "$child_issue" | jq -r '.title')
            child_file_name=$(sanitize_filename "$child_title")
            
            # サブissueファイルを作成（issue番号 - タイトル.md）
            sub_file="$pbi_dir/sub-issues/${child_num} - ${child_file_name}.md"
            create_issue_file "$sub_file" "$child_issue"
            echo "作成: $sub_file"
            
            # 割り当て済みとして記録
            echo "$child_num" >> "$ASSIGNED_CHILDREN"
        fi
    done
done < "$PBI_FILE"

# その他-issue（どのPBIにも属さないissue）を処理
OTHER_COUNT=0
other_dir="$OUTPUT_DIR/その他-issue"

while read -r issue; do
    [[ -z "$issue" ]] && continue
    
    issue_num=$(echo "$issue" | jq -r '.number')
    
    # PBI自体はスキップ
    if echo "$PBI_NUMBERS" | grep -qw "$issue_num"; then
        continue
    fi
    
    # 既にサブissueとして割り当て済みならスキップ
    if grep -qw "$issue_num" "$ASSIGNED_CHILDREN" 2>/dev/null; then
        continue
    fi
    
    # その他-issueディレクトリに配置
    mkdir -p "$other_dir"
    
    issue_title=$(echo "$issue" | jq -r '.title')
    issue_file_name=$(sanitize_filename "$issue_title")
    
    # その他issueファイルを作成（issue番号 - タイトル.md）
    issue_file="$other_dir/${issue_num} - ${issue_file_name}.md"
    create_issue_file "$issue_file" "$issue"
    echo "作成: $issue_file"
    
    ((OTHER_COUNT++))
done < "$TEMP_DIR/all_issues.jsonl"

echo ""
echo "完了！ ${PBI_COUNT}個のPBIと${OTHER_COUNT}個の独立したissueを処理しました。"
