# BlastPop - Feature List

## App Overview
- **App Name**: BlastPop
- **Bundle ID**: com.ggsheng.BlastPop
- **Core Concept**: A stress-relief ASMR bubble popping tool app. Users pop colorful bubbles on screen for relaxation, create photo bubble collages, and track daily mood with bubble journals.
- **Target Users**: 欧美青少年、青年、中年 (14-45 years old)
- **App Language**: English (primary), no Chinese characters in UI
- **Platform**: iOS 17.0+

---

## 功能清单 (60+ Features)

### 1. 核心解压 (Core Pop)
1. 自由泡泡模式 - 屏幕随机出现彩色泡泡，一指戳破
2. 多指同时戳 - 支持多指同时戳破多个泡泡
3. 泡泡物理动效 - 泡泡有弹性/碰撞/漂浮物理效果
4. ASMR 音效 - 泡泡戳破有 satisfying pop 音效
5. 无尽模式 - 无限泡泡，持续减压
6. 泡泡大小随机 - 小/中/大三档随机
7. 泡泡形状 - 圆形/方形/星形/心形随机
8. 背景颜色 - 深色/浅色背景可切换
9. 触感反馈 - haptic 震动反馈

### 2. 心情气泡墙 (Mood Bubble Wall)
10. 每日气泡 - 每天一个心情气泡写入文字
11. 气泡日历 - 按日期排列心情气泡
12. 气泡颜色 - 心情颜色选择（开心绿/平静蓝/难过紫/生气红）
13. 气泡投屏 - 心情墙可全屏展示
14. 气泡回顾 - 月度心情回顾统计
15. 气泡删除 - 长按删除单个气泡
16. 气泡编辑 - 点击修改已写气泡

### 3. 图片气泡编辑 (Photo Bubble Edit)
17. 相册导入 - 导入照片添加泡泡
18. 气泡蒙版 - 照片元素用泡泡覆盖
19. 气泡画笔 - 手动绘制气泡区域
20. 文字气泡 - 添加文字在泡泡里
21. 表情气泡 - 添加 emoji 表情气泡
22. 滤镜 - 给照片加滤镜
23. 拼贴导出 - 多张照片气泡拼贴
24. 一键分享 - 分享到 Instagram/小红书/微信

### 4. 白噪音 + 泡泡 (White Noise + Pop)
25. 雨声背景 - 雨声白噪音
26. 海浪背景 - 海浪白噪音
27. 篝火背景 - 火焰噼啪白噪音
28. 森林背景 - 鸟鸣+树叶白噪音
29. 咖啡馆背景 - 咖啡馆环境音
30. 泡泡同步 - 白噪音下泡泡同步出现
31. 音量控制 - 白噪音音量独立调节
32. 定时器 - 设定放松时长（5/10/15/30/60分钟）

### 5. 挑战模式 (Challenge Mode)
33. 每日挑战 - 每天一个新主题（戳破XX个绿泡泡）
34. 挑战计时 - 限时完成挑战
35. 挑战奖励 - 完成挑战获得虚拟金币
36. 连续打卡 - 连续完成挑战天数
37. 挑战历史 - 查看历史挑战记录

### 6. 虚拟货币系统
38. 金币余额 - 完成挑战/分享获得金币
39. 气泡商店 - 用金币解锁特殊气泡样式
40. 解锁记录 - 已解锁物品展示

### 7. 个人中心 (Profile)
41. 使用统计 - 总泡泡数/总时长/连续天数
42. 成就徽章 - 达成特定里程碑获得徽章
43. 解锁主题 - 解锁深色/浅色主题
44. 数据导出 - 导出心情记录为 PDF
45. 每日提醒 - 设置每日放松提醒时间
46. 声音设置 - 开/关音效、开/关白噪音
47. 震动设置 - 开/关 haptic 反馈
48. 深色/浅色 - 主题切换

### 8. 设置 (Settings)
49. 关于页面 - App 版本、开发者信息
50. 隐私政策 - 隐私政策页面
51. 联系我们 - 邮箱联系 support@techidaily.com
52. 评分入口 - 跳转 App Store 评分
53. 分享好友 - 分享 App 给朋友

---

## Identifier Capabilities 推荐

| 功能 | Capabilities |
|------|-------------|
| 无特殊功能 | 无特殊 Capabilities（App Groups 不需要，除非后续加 Widget）|

---

## 技术架构

- **UI Framework**: SwiftUI
- **Architecture**: MVVM
- **Data Storage**: UserDefaults (心情数据), 文件系统 (图片)
- **Audio**: AVFoundation
- **Haptics**: CoreHaptics
- **分享**: UIActivityViewController