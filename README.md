# Homebrew Tap for zotero-pdf2zh

[![CI](https://github.com/NightWatcher314/homebrew-zotero-pdf2zh/actions/workflows/ci.yml/badge.svg)](https://github.com/NightWatcher314/homebrew-zotero-pdf2zh/actions/workflows/ci.yml)

这是一个用于 [zotero-pdf2zh](https://github.com/guaguastandup/zotero-pdf-translate) 的 Homebrew Tap，它提供了一个本地 Zotero PDF 翻译服务器。

## 安装与使用 (macOS)

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
    推荐使用 `brew services` 将其作为后台服务运行，这样开机后会自动启动。

    ```bash
    brew services start zotero-pdf2zh
    ```

    服务将默认在 `http://127.0.0.1:47700` 上运行。

    您也可以手动运行它以进行调试或使用不同参数：

    ```bash
    zotero-pdf2zh --port 47700
    ```

4.  **配置 Zotero 插件**:

    - 打开 Zotero。
    - 进入 Zotero PDF Translate 插件的设置。
    - 在服务器配置部分，确保 Python 服务器的地址和端口与您启动服务时使用的匹配。默认情况下，地址是 `http://127.0.0.1`，端口是 `47700`。

5.  **开始翻译**: 在 Zotero 中右键点击一个 PDF 附件，然后选择翻译选项。

## 更新

您可以使用 `brew` 来更新 `zotero-pdf2zh` 到最新版本：

```bash
brew upgrade zotero-pdf2zh
```

## 卸载

```bash
brew uninstall zotero-pdf2zh
brew untap NightWatcher314/zotero-pdf2zh
```
