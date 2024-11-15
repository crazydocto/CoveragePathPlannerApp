# AUV 全覆盖路径规划器

一个用于生成 AUV (自主水下航行器) 海底探测梳状全覆盖路径的 MATLAB GUI 应用程序。

## 功能特点

- 交互式路径规划：通过图形界面设置路径参数
- 灵活的路径生成：支持 X/Y 两个方向的梳状路径规划
- 实时路径可视化：动态显示规划路径和关键点
- 数据导出功能：支持将路径点导出为 CSV 格式
- TCP 通信：可直接将规划数据发送至 AUV 控制系统

## 安装与使用

### 开发工作流

> 请确保已安装 Git 和 MATLAB
> 
> 请确保已配置好 Git 的用户名和邮箱
> 
> 详细工作流请参考组内的Git教程

1. Fork 本仓库至自己的github账号仓库中
2. 克隆到本地进行开发

    ```bash
    git clone https://github.com/yourusername/auv-coverage-planner.git
    cd CoveragePathPlannerApp
    ```

3. 创建新分支进行开发

    ```bash
    git checkout -b feature/your-feature-name
    ```

4. 提交更改

    ```bash
    git add .
    git commit -m "描述你的更改"
    ```

5. 推送到远程仓库（自己的）

    ```bash
    git push origin feature/your-feature-name
    ```

6. 创建 Pull Request 到主仓库
7. 等待审核

#### 版本发布

```bash
# 标记新版本
git tag -a v1.1 -m "版本1.1发布"

# 推送标签
git push origin v1.1
```

#### 请确保提交前：

运行所有测试用例
更新相关文档
遵循代码规范

### 运行方式

1. 在MATLAB中打开`CoveragePathPlannerApp.m`文件
2. 点击"运行"按钮或在命令行输入:

    ```bash
    CoveragePathPlannerApp
    ```

3. 根据提示设置参数，点击"生成规划路径"按钮，即可生成规划路径
4. 点击"导出规划路径点"按钮，即可将规划路径点导出为 CSV 文件
5. 点击"发送规划数据"按钮，即可将规划数据发送至 AUV 控制系统

#### 常见问题

1. 如遇到TCP连接失败：

   - 检查目标IP地址和端口是否正确
   - 确认防火墙设置
  
2. 路径生成失败：

   - 确保输入参数在有效范围内
   - 检查MATLAB版本兼容性

## 界面参数介绍

### 相关坐标初始化

- 规划路径起始点坐标 (X, Y)
- AUV 初始位置 (X, Y, Z)
- AUV 初始姿态角 (Roll, Pitch, Yaw)

### 路径参数

- 路径方向：X/Y 方向选择
- 梳状齿间距：默认 200m
- 路径宽度：默认 1000m
- 路径数量：默认 6 条

### TCP 通信设置

- 服务器 IP：默认 192.168.1.108
- 端口：默认 5000

## 功能按钮

- 生成规划路径：生成并显示路径规划
- 导出规划路径点：保存为 CSV 格式
- 发送规划数据：通过 TCP 发送至 AUV

## 所有权声明

版权所有 © 哈尔滨工程大学智能海洋机器人实验室张强老师团队

未经允许，不得用于商业用途

维护者：Chi-hong22/游子昂

## 版本信息

版本：1.1

发布日期：2024-11-15

## 系统要求

MATLAB R2024a 或更高版本

建议屏幕分辨率：1200x800 或更高

## 联系方式

`you.ziang@hrbeu.edu.cn`

如有优化需求，请联系项目负责人`游子昂`进行统一安排迭代升级。