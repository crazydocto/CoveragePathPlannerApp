# AUV 全覆盖路径规划器

一个用于生成 AUV (自主水下航行器) 海底探测梳状全覆盖路径的 MATLAB GUI 应用程序。

## 功能特点

- 交互式路径规划：通过图形界面设置路径参数
- 灵活的路径生成：支持 X/Y 两个方向的梳状路径规划
- 实时路径可视化：动态显示规划路径和关键点
- 数据导出功能：支持将路径点导出为 CSV 格式
- TCP 通信：可直接将规划数据发送至 AUV 控制系统
- Dubins 路径规划：支持避障算法设置

## 界面参数说明

### 相关坐标初始化

- **规划路径起始点坐标 (X, Y)**：设定梳状路径的起始位置坐标
- **AUV 初始位置 (X, Y, Z)**：航行器的起始位置
  - X: 东向坐标（米）
  - Y: 北向坐标（米）
  - Z: 深度坐标（米），正值表示水下深度
- **AUV 初始姿态角 (Roll, Pitch, Yaw)**：航行器初始姿态
  - Roll: 横滚角（度），围绕X轴旋转
  - Pitch: 俯仰角（度），围绕Y轴旋转
  - Yaw: 航向角（度），围绕Z轴旋转
- **路径 Z 坐标设置**：设定路径的深度
- **上浮/下潜设置**：
  - 上浮高度和时间：定义上浮操作的高度（米）和时间（秒）
  - 下潜深度和时间：定义下潜操作的深度（米）和时间（秒）

### 路径参数

- **路径方向**：选择X方向或Y方向的梳状路径
  - X方向：梳状路径的主线沿X轴方向延伸
  - Y方向：梳状路径的主线沿Y轴方向延伸
- **梳状齿间距**：相邻两条探测线之间的距离（米），默认200m
- **路径宽度**：整个覆盖区域的宽度（米），默认1000m
- **路径数量**：探测线的总数，默认6条
- **AUV深度**：设置航行器的巡航深度（米）
- **下潜点/下潜深度**：指定下潜操作的路径点序号和目标深度（米）
- **上浮路径点/上浮深度**：指定上浮操作的路径点序号和目标深度（米）

### 运动控制参数

- **设置最大速度**：AUV的最大航行速度（米/秒）
- **设置掉深时间**：下潜操作的执行时间（秒）
- **设置急停时间**：紧急停止指令的响应时间（秒）

### 容错控制参数

- **设置卡舵序号 (K1-K4)**：设定需要特殊处理的控制点序号
- **设置卡舵舵角 (δ1-δ4)**：对应控制点的转向角度（度）
  - 舵1-舵4：不同舵面的转向角设置

### Dubins 路径规划设置

- **前段路径点个数**：起始段路径采样点数量
- **中段路径点个数**：过渡段路径采样点数量
- **后段路径点个数**：终止段路径采样点数量
- **转弯半径**：AUV 转向时的最小转弯半径（米）

### TCP 通信设置

- **服务器IP/端口**：AUV控制系统的IP地址和端口
  - 默认IP：192.168.1.120
  - 默认端口：5001
- **本机IP/端口**：本地计算机的IP地址和监听端口
  - 默认IP：192.168.1.100
  - 默认端口：8888

## 功能按钮说明

### 全局路径规划功能

- **【生成梳状路径】**：根据设定的起始点、间距、宽度等参数，生成全局探测路径。点击后，在UIAxes1区域显示规划结果。
- **【导出梳状路径点】**：将生成的全局路径点数据以CSV格式保存到指定位置，便于后续分析和使用。导出的数据包含完整的路径点坐标。
- **【发送梳状路径数据至AUV】**：通过配置的TCP连接将路径数据传输至AUV控制系统。发送成功后会在状态栏显示确认信息。

### 地图处理与避障功能

- **【导入地图数据】**：支持导入.mat格式的海底地形高程数据，用于后续的障碍物分析。导入后会在UIAxes3区域显示地形数据。
- **【地形图及障碍物标注】**：在UIAxes3绘图区域中可视化地形数据，并自动标注潜在障碍物位置。红色区域表示危险区域。
- **【Dubins路径规划】**：基于预设的路径点密度和转弯半径，生成平滑的避障路径。计算结果会在UIAxes2区域显示。

### Dubins路径输出功能

- **【导出Dubins路径点】**：将优化后的路径点数据以CSV格式保存，包含所有关键航点坐标、速度和角度信息。
- **【发送Dubins路径数据至AUV】**：将优化后的避障路径数据通过TCP协议发送至AUV控制系统。
- **【绘制仿真图】**：生成AUV沿规划路径行进的仿真动画，用于直观评估路径可行性。

## 典型工作流程

1. 设置起始点和各项参数
2. 点击【生成梳状路径】生成全局路径
3. 导入地形数据并标注障碍物
4. 执行Dubins路径规划避开障碍物
5. 导出最终路径或直接发送至AUV

## 系统要求

- MATLAB R2024a 或更高版本
- 建议屏幕分辨率：1200x800 或更高
- 需安装的工具箱：
  - MATLAB 基础工具箱
  - 信号处理工具箱
  - 通信工具箱（用于TCP通信）

## 版权信息

版权所有 © 哈尔滨工程大学智能海洋机器人实验室张强老师团队

维护者：Chi-hong22/游子昂 (you.ziang@hrbeu.edu.cn)

未经允许，不得用于商业用途