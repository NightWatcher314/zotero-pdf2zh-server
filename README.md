# zotero-pdf2zh

本地 Zotero PDF 翻译服务器，使用 `pdf2zh` 和 `pdf2zh-next` 作为后端引擎。

## 功能

- 接收来自 [Zotero PDF Translate](https://github.com/guaguastandup/zotero-pdf-translate) 插件的请求。
- 调用 `pdf2zh` 或 `pdf2zh-next` 引擎翻译 PDF 文件。
- 支持对翻译后的 PDF 进行裁剪、合并等后处理。
- 提供自动更新功能。

## 安装

您可以根据您的操作系统选择不同的安装方式。

### 方法一：通过 Homebrew (macOS 用户)

这是为 macOS 用户推荐的安装方式。

1.  **Tap 本仓库:**

    ```bash
    brew tap NightWatcher314/zotero-pdf2zh
    ```

2.  **安装 zotero-pdf2zh:**

    ```bash
    brew install zotero-pdf2zh
    ```

3.  **启动服务:**
    您可以使用 `brew services` 将其作为后台服务运行。

    ```bash
    brew services start zotero-pdf2zh
    ```

    服务将默认在 `http://127.0.0.1:47700` 上运行。

    您也可以手动运行它以进行调试或使用不同参数：

    ```bash
    zotero-pdf2zh --port 47700
    ```

### 方法二：从源代码运行 (适用于所有平台)

如果您不使用 macOS，或者您是希望修改代码的开发者，可以从源代码运行。

1.  **克隆仓库:**

    ```bash
    git clone https://github.com/NightWatcher314/homebrew-zotero-pdf2zh.git
    cd homebrew-zotero-pdf2zh
    ```

2.  **安装依赖:**
    项目使用 `uv` 来管理依赖和运行环境。请先确保您已安装 `uv`。

    ```bash
    # 安装 uv (如果尚未安装)
    pip install uv

    # 使用 uv 创建虚拟环境并安装依赖
    uv venv
    uv pip install -r requirements.txt
    ```

3.  **运行服务:**
    您可以使用 `run.sh` 脚本来启动服务：
    ```bash
    ./run.sh
    ```
    或者直接使用 `uv` 运行：
    ```bash
    uv run server.py --port 47700
    ```

## 使用方法

1.  **启动服务**: 根据您选择的安装方式启动服务。

2.  **配置 Zotero 插件**:

    - 打开 Zotero。
    - 进入 Zotero PDF Translate 插件的设置。
    - 在服务器配置部分，确保 Python 服务器的地址和端口与您启动服务时使用的匹配。默认情况下，地址是 `http://127.0.0.1`，端口是 `47700`。

3.  **开始翻译**: 在 Zotero 中右键点击一个 PDF 附件，然后选择翻译选项。

### 命令行参数

您可以在启动服务时附加以下参数：

| 参数                      | 别名 | 默认值   | 描述                                          |
| ------------------------- | ---- | -------- | --------------------------------------------- |
| `--port`                  | `-p` | `47700`  | 指定服务器运行的端口。                        |
| `--debug`                 |      | `False`  | 以 Flask 调试模式运行。                       |
| `--check_update`          |      | `True`   | 启动时检查新版本。                            |
| `--update`                |      | `False`  | 强制执行更新。                                |
| `--update_source`         |      | `github` | 指定更新源 (`github` 或 `gitee`)。            |
| `--skip_install`          |      | `False`  | 更新时跳过 `pdf2zh` 和 `pdf2zh-next` 的安装。 |
| `--enable_winexe`         |      | `False`  | (Windows) 使用 `pdf2zh.exe` 代替 `uv` 运行。  |
| `--winexe_path`           |      | `None`   | (Windows) `pdf2zh.exe` 的路径。               |
| `--winexe_attach_console` |      | `False`  | (Windows) 将 `exe` 的输出附加到当前控制台。   |

**示例:**

```bash
# 在端口 8080 上运行并禁用更新检查
uv run server.py --port 8080 --check_update false
```

## 自动更新

服务在每次启动时都会自动检查是否有新版本。如果检测到新版本，它会提示您更新。

您也可以通过 `--update` 参数来强制触发更新流程：

```bash
uv run server.py --update
```

如果您在中国大陆访问 GitHub 速度较慢，可以切换到 Gitee 更新源：

```bash
uv run server.py --update --update_source gitee
```
