# 自荐自己维护的一个fork zotero-pdf2zh-next

[zotero-pdf2zh-next](https://github.com/NightWatcher314/zotero-pdf2zh-next)。

`zotero-pdf2zh-next` 仍然面向 Zotero PDF 翻译，但把插件端和本地 Python 服务一起维护，重点改善了安装、任务管理和日常使用体验：

- 支持 Zotero 7 及以上版本。
- 插件内置任务面板，可以查看进度、取消任务、重试失败任务和导入结果。
- 偏好页可以直接查看插件端和服务端版本，并检查连接与 LLM 配置。
- 服务端提供 Homebrew、Docker 和源码启动方式，依赖统一使用 `uv` 管理。
- 已支持禁用自动术语提取等新选项。
- 精简代码, 只支持 pdf2zh-next, 弃用了 pdf2zh


# zotero-pdf2zh-server 安装工具(以下为原方案的 Homebrew 安装脚本的说明)

本仓库保留为 `zotero-pdf2zh` 原方案的 Homebrew 安装脚本，适合继续使用旧版稳定流程的用户。

这是 [zotero-pdf2zh](https://github.com/guaguastandup/zotero-pdf2zh) 的 Homebrew 安装脚本，让你可以轻松在本地部署 Zotero PDF 翻译服务器。

目前已更新至 v4.0.3

## 重要说明！

formula 以及自动更新的 CI 流程位于 [NightWatcher314/homebrew-formula](https://github.com/NightWatcher314/homebrew-formula) 中，请前往该仓库查看最新的更新日志和版本信息。

下面的安装与使用说明目前均适用，后续请以上游仓库的说明为准，欢迎 star 本仓库。

## 安装与使用

### macOS

这是为 macOS 用户推荐的安装方式。

1.  **Tap 本仓库:**

    ```bash
    brew tap NightWatcher314/formula
    ```

2.  **安装 zotero-pdf2zh:**

    ```bash
    brew install zotero-pdf2zh
    ```

3.  **启动服务:**

    **首次使用（必需步骤）：**

    先手动运行以下命令来下载所需的字体和依赖包：

    ```bash
    zotero-pdf2zh --port 47700
    ```

    等待命令执行完成，您会看到服务启动的输出。

    **后续使用：**

    确认服务能正常运行后，使用 `brew services` 将其作为后台服务，这样开机后会自动启动：

    ```bash
    brew services start zotero-pdf2zh
    ```

    **调试或使用自定义参数：**

    如需调试或使用不同参数，仍可手动运行：

    ```bash
    zotero-pdf2zh --port 47700
    ```

4.  **配置 Zotero 插件（必须）**:

    - 打开 Zotero，进入 Zotero PDF Translate 插件的设置
    - 在服务器配置部分，填入地址 `http://127.0.0.1`，端口 `47700`
    - 这一步必须完成，否则插件无法连接到本地服务器

5.  **开始翻译**: 在 Zotero 中右键点击一个 PDF 附件，然后选择翻译选项。

6.  **查看日志**

    您可以使用以下命令查看最近的实时日志输出：

    ```bash
    tail -f "$(brew --prefix)/var/log/zotero-pdf2zh.log"
    ```

    或者查看最后 50 行：

    ```bash
    tail -n 50 "$(brew --prefix)/var/log/zotero-pdf2zh.log"
    ```

    如果日志文件路径不同，请根据实际情况调整。

### Linux (使用 Linuxbrew)

安装步骤与 macOS 相同，只需运行上述命令即可。唯一的区别是：

- Linux 上使用系统服务管理工具（如 systemd）启动或在后台运行，而不是 `brew services`

## 更新

您可以使用 `brew` 来更新 `zotero-pdf2zh` 到最新版本：

```bash
brew upgrade zotero-pdf2zh
```

## 卸载

```bash
brew uninstall zotero-pdf2zh
```

## 问题反馈

如果遇到问题，请在 [GitHub Issues](https://github.com/NightWatcher314/zotero-pdf2zh-server/issues) 中提交反馈。提交 issue 时，请提供以下信息以便快速定位问题：

1. **系统信息**：

   - 操作系统（macOS、Linux）

2. **服务日志**:

   - 提供最近的服务日志输出：
     ```bash
     tail -n 100 "$(brew --prefix)/var/log/zotero-pdf2zh.log"
     ```

3. **版本信息**：

   - 运行以下命令查看安装的版本：
     ```bash
     brew info zotero-pdf2zh
     ```

4. **具体问题描述**：
   - 问题发生时的具体操作步骤
   - 错误信息或异常行为的详细描述
