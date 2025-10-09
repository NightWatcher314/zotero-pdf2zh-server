# Server.py 重构说明

## 修改日期

2025 年 10 月 10 日

## 重构目标

移除所有虚拟环境管理相关的代码，改为由用户使用 uv 自行管理虚拟环境。

## 主要修改内容

### 1. 移除的导入

- 删除 `from utils.venv import VirtualEnvManager`

### 2. 移除的配置变量

- 删除 `venv` 配置文件路径
- 删除 `venv_name` 字典（包含 pdf2zh 和 pdf2zh_next 的虚拟环境名称）
- 删除 `default_env_tool` 变量
- 删除 `enable_venv` 变量

### 3. 移除的类成员

- 在 `PDFTranslator.__init__` 中删除 `self.env_manager` 的初始化

### 4. 简化的命令执行

所有原本通过虚拟环境管理器执行的命令，现在直接使用 `subprocess.run(cmd, check=True)` 执行：

**修改前：**

```python
if args.enable_venv:
    self.env_manager.execute_in_env(cmd)
else:
    subprocess.run(cmd, check=True)
```

**修改后：**

```python
subprocess.run(cmd, check=True)
```

### 5. 移除的命令行参数

- `--enable_venv`: 脚本自动开启虚拟环境
- `--env_tool`: 虚拟环境管理工具
- `--enable_mirror`: 启用下载镜像加速
- `--mirror_source`: 自定义 PyPI 镜像源
- `--skip_install`: 跳过虚拟环境中的安装

### 6. 更新排除目录列表

将自动更新功能中的排除目录从特定的虚拟环境目录改为通用的目录：

```python
EXCLUDE_DIRECTORIES = ['__pycache__', '.git', '.venv', 'venv', 'env', '.env']
```

### 7. 更新提示信息

移除了关于虚拟环境保护的提示信息。

## 使用方式

### 环境准备（使用 uv）

```bash
# 安装 uv（如果还没有安装）
curl -LsSf https://astral.sh/uv/install.sh | sh

# 创建虚拟环境
uv venv

# 激活虚拟环境
source .venv/bin/activate  # macOS/Linux
# 或
.venv\Scripts\activate  # Windows

# 安装依赖
uv pip install -r requirements.txt
```

### 运行服务器

```bash
# 确保已激活虚拟环境后
python server.py

# 或指定端口
python server.py --port 8890

# 启用调试模式
python server.py --debug true
```

## 保留的功能

- 所有 PDF 翻译功能
- 自动更新功能
- Windows 可执行文件支持（--enable_winexe）
- 所有 API 端点（/translate, /crop, /crop-compare, /compare）
- 配置文件管理

## 注意事项

1. **必须先激活虚拟环境**才能运行 server.py
2. 确保 `pdf2zh` 和 `pdf2zh_next` 命令在虚拟环境中可用
3. 所有依赖包需要通过 uv 或 pip 手动安装
4. 配置文件仍然保留在 `config/` 目录下

## 优势

- 代码更简洁，减少了复杂的虚拟环境管理逻辑
- 使用标准的 Python 虚拟环境方式，更符合 Python 最佳实践
- 用户可以完全控制虚拟环境的创建和管理
- 减少了依赖，移除了 `utils.venv` 模块的依赖
