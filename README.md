# SmartRent 智慧租房

基于 **华为 HarmonyOS 6.0.2 + ArkTS** 构建的智慧租房应用，提供从找房、收藏、通勤规划到家庭生活服务的一站式租住体验。

## 项目背景

本项目是面向 HarmonyOS 平台的期末设计作品，旨在通过实际项目熟悉 ArkTS 声明式 UI 语法、组件化开发模式以及鸿蒙系统 API 的使用方式。应用以"租房"这一高频生活场景为切入点，覆盖了从浏览房源、个性化匹配、通勤分析到入住后家庭服务的完整链路。

## 功能概览

| 模块 | 功能 |
|------|------|
| **首页** | 轮播 Banner、快速找房入口、分人群定制方案（在校生/毕业生/打工人/外籍人士）、房源推荐列表、本地搜索过滤、下拉刷新 |
| **想看** | 收藏房源管理、通勤目的地设置、**通勤找房**智能筛选、**地图找房**（周边配套/地铁沿线/热门社区）、收藏洞察（数量/均价/最近收藏） |
| **服务** | VIP 会员体系、15 项家庭服务（保洁、维修、家电清洗、洗衣、搬家、开锁、管道疏通、空气治理、宽带、宠物、绿植、窗帘、床品、消毒、管家） |
| **发现** | 精选文章双列推荐、热门标签、会员推广、轮播主题 Banner |
| **我的** | 手机号/管理员双模式登录、我的预约、收藏管理、优惠券入口 |

### 核心页面（15 个）

- `Index` — 登录页（手机验证码 / 管理员密码）
- `MainPage` — 主框架（5 个 Tab）
- `RentListPage` — 房源列表
- `RentDetailPage` — 房源详情
- `BookingPage` — 预约看房
- `OrderListPage` — 我的预约列表
- `MapSearchPage` — 地图找房
- `TripPage` — 通勤方案
- `PersonaPlanDetailPage` — 人群定制方案详情
- `LandlordPage` — 房东发布房源
- `VipDetailPage` — VIP 会员详情
- `ArticleDetailPage` — 文章详情
- `DiscoverAdPage` — 发现页广告
- `MessagePage` — 消息中心
- `DemoPage` — 组件展示

## 技术栈

| 层级 | 技术 |
|------|------|
| 运行环境 | HarmonyOS 6.0.2 (API 12) |
| 开发语言 | ArkTS (TypeScript 方言) |
| UI 框架 | ArkUI 声明式组件（`@Component`、`@State`、`@Builder`） |
| 路由 | `@kit.ArkUI` — `router.pushUrl` / `router.replaceUrl` |
| 网络请求 | `@ohos.net.http` 封装（GET / POST + Bearer Token） |
| 测试框架 | `@ohos/hypium` + `@ohos/hamock` |
| 构建工具 | hvigor |

## 项目结构

```
SmartRent/
├── AppScope/                  # 应用级资源配置（图标、名称）
├── entry/
│   └── src/
│       └── main/
│           ├── ets/
│           │   ├── api/                   # 接口层
│           │   │   ├── HomeApi.ets        #   首页数据接口
│           │   │   ├── ServiceApi.ets     #   服务数据接口
│           │   │   ├── DiscoverApi.ets    #   发现页接口
│           │   │   ├── UserApi.ets        #   用户/登录接口
│           │   │   ├── OrderApi.ets       #   预约订单接口
│           │   │   └── HouseApi.ets       #   房源详情接口
│           │   ├── model/                 # 数据模型层
│           │   │   ├── HomeData.ets       #   首页数据模型
│           │   │   ├── HouseData.ets      #   房源详情模型
│           │   │   ├── ServiceData.ets    #   服务数据模型
│           │   │   ├── DiscoverData.ets   #   发现页数据模型
│           │   │   ├── UserData.ets       #   用户数据模型
│           │   │   ├── OrderData.ets      #   订单数据模型
│           │   │   ├── RoomRecommendData.ets  # 房源推荐模型
│           │   │   ├── TileData.ets       #   磁贴数据模型
│           │   │   ├── PlanData.ets       #   方案步骤模型
│           │   │   ├── PersonaPlanData.ets #  人群方案模型
│           │   │   └── TagEntryData.ets   #   标签入口模型
│           │   ├── components/            # 可复用组件
│           │   │   ├── NavBar.ets         #   导航栏
│           │   │   ├── NavList.ets        #   导航列表
│           │   │   ├── SearchBar.ets      #   搜索栏
│           │   │   ├── TileList.ets       #   磁贴网格
│           │   │   ├── PlanList.ets       #   方案步骤列表
│           │   │   ├── Ad.ets             #   轮播广告
│           │   │   ├── RoomRecommend.ets  #   房源推荐卡片
│           │   │   ├── TagEntryGrid.ets   #   标签入口网格
│           │   │   └── PersonaPlanList.ets #  人群方案列表
│           │   ├── pages/                 # 页面（15 个）
│           │   ├── utils/http/Index.ets   # HTTP 工具封装
│           │   ├── constants/Size.ets     # 尺寸常量
│           │   ├── entryability/          # UIAbility 入口
│           │   └── entrybackupability/    # 备份扩展能力
│           └── resources/                 # 资源文件
│               └── base/
│                   ├── element/           # 字符串、颜色
│                   ├── media/             # 图标、图片（60+ 资源）
│                   └── profile/           # 页面路由配置
├── hvigor/                   # 构建配置
├── oh_modules/               # 依赖（hypium、hamock）
├── build-profile.json5       # 构建配置
├── oh-package.json5          # 包信息
└── hvigorfile.ts             # 构建入口
```

## 架构设计

```
Pages (页面层)
  └── Components (组件层)
        └── API (接口层) ──→ utils/http (网络层) ──→ @ohos.net.http
              └── Model (数据模型层)
```

- **数据模型层**：纯数据类，定义字段和默认值
- **API 层**：封装接口调用，返回 `HttpResult<T>` 统一结构
- **组件层**：通过 `@Component` + `@Builder` 构建可复用 UI 单元
- **页面层**：通过 `@Entry` 注册，由路由系统管理跳转

## 本地运行

### 环境要求

- **DevEco Studio** (适用于 HarmonyOS 开发)
- **HarmonyOS SDK** API 12+
- **模拟器或真机** 运行 HarmonyOS 6.0.2+

### 启动步骤

1. 克隆仓库
   ```bash
   git clone https://github.com/Vinceli-9527/SmartRent.git
   ```

2. 用 DevEco Studio 打开项目目录

3. 等待依赖同步（`oh_modules` 自动安装）

4. 选择模拟器或真机设备，点击 **Run** 运行

### 模拟数据说明

当前版本使用前端内置的 fallback 数据（`fallbackHomeData()`、`fallbackRecommend()` 等方法）。在 API 层面已预留接口请求逻辑，目标后端地址为 `https://api.smartrent.com/api/v1`，实际部署时替换为真实后端即可。

## 版本信息

| 项 | 值 |
|----|-----|
| HarmonyOS | 6.0.2 |
| API Level | 12 (SDK 5.0.0) |
| 语言 | ArkTS |
| 构建工具 | hvigor |

## 许可证

[MIT License](LICENSE)

Copyright (c) 2026
