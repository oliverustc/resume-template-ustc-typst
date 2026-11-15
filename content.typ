#import "theme.typ": ustc-resume

// 使用顺序：先填写下面的简历，再到文件后半部分调整字体、字号和间距。
// 直接编译本文件即可。所有示例身份、经历和成果均为虚构。

// ═══════════════════ 一、个人信息与简历内容 ═══════════════════
// 只有 name 必填；其他个人字段可省略或设为 none。
// 教育/论文/项目/比赛数组可设为 ()，自述可设为 none，空章节自动隐藏。
// 如需自定义信息表，可在 resume 中增加：
// details: ((label: "主页", value: "example.com", url: "https://example.com"),),
// details: () 表示隐藏整个信息表。
// 单条论文、项目或比赛可增加 spacing: (line-height: 15pt, entry-gap: 8pt),
// 单条目支持的键及其含义，见文件后半部分的“间距参数说明”。
#let resume = (
  // 姓名，必填；也用于 PDF 的标题和作者信息。
  name: "张三",
  // 姓名旁的身份介绍；不显示时设为 none。
  role: "硕士研究生",
  // 姓名旁的研究方向或求职方向；不显示时设为 none。
  focus: "XX专业",
  // 头像文件路径，相对于项目目录；none 表示不显示照片。
  photo: "images/avatar-placeholder.svg",
  // 页眉右侧显示的学院或单位名称；none 表示不显示。
  school: "XX学院",
  // 以下基本信息均可省略或设为 none，相应字段会自动隐藏。
  gender: "男",         // 性别
  ethnicity: "汉",      // 民族
  birthday: "2000年1月", // 出生年月（按原样显示，不会自动计算年龄）
  hometown: "示例城市",  // 籍贯或所在城市
  email: "zhangsan@example.com", // 邮箱，同时用于信息区、页脚和邮件链接
  phone: "13800000000",         // 联系电话，同时用于信息区和页脚
  // 教育经历：university 学校；degree 学位；school 学院；major 专业；dates 时间区间。
  education: (
    (university: "中国科学技术大学", degree: "硕士", school: "XX学院", major: "XX专业", dates: "2024.09 - 2027.06"),
    (university: "中国科学技术大学", degree: "学士", school: "XX学院", major: "XX专业", dates: "2020.09 - 2024.06"),
  ),
  // 论文：title 论文标题；status 发表/投稿状态；description 简要说明。
  // badge 是链接旁的显示文字；url 是链接地址；不需要时设为 none。
  papers: (
    (
      title: "A Sample Study on Reliable Software Systems",
      status: "示例期刊名称 · 论文状态请按实际情况填写",
      badge: "链接", url: "https://example.com/paper",
      description: "此处概述论文所研究的问题、采用的方法和主要结论。建议突出本人承担的工作以及经过验证的成果，使用准确、简洁的语言描述研究贡献。本条论文为虚构示例。",
    ),
    (
      title: "An Example Framework for Reproducible Data Analysis",
      status: "示例会议名称 · 本条目仅展示第二篇论文的排版方式",
      badge: none, url: none,
      description: "此处介绍研究背景、方法设计及实验验证。可以说明如何组织数据、构建实验流程并复现结果；如果论文尚未发表，应明确填写投稿、审稿或其他真实状态。",
    ),
  ),
  // 项目：title 项目名称；sponsor 项目来源；description 项目内容；contribution 个人贡献。
  projects: (
    (
      title: "可复现的数据分析工具", sponsor: "科研训练（虚构示例）",
      description: "将数据导入、清洗、统计分析与图表生成整合到统一流程中，通过参数配置复用分析步骤，并记录输入与运行环境。",
      contribution: "设计数据处理模块与配置格式，实现批量运行和结果导出；整理操作说明，使其他使用者能够理解并复现实验。",
    ),
    (
      title: "团队知识库检索服务", sponsor: "实践项目（虚构示例）",
      description: "针对团队文档分散、检索效率较低的问题，构建文档索引与检索接口，为常用资料提供统一入口。",
      contribution: "负责文档解析、索引更新和检索接口，结合使用反馈改进查询与展示流程。请使用可核实的结果说明项目价值。",
    ),
  ),
  // 比赛：competition 比赛名称；date 获奖时间；prize 奖项；bonus 奖金或补充说明。
  // title 是参赛作品名称；description 介绍作品与个人贡献；可选字段可省略。
  awards: (
    (
      competition: "示例软件设计竞赛", date: "2025.10",
      prize: "示例一等奖", bonus: "虚构奖项", title: "参赛作品：校园活动管理平台",
      description: "此处说明参赛作品的目标、技术方案及本人贡献。比赛名称、奖项、时间和成果应在使用模板时替换为真实信息。",
    ),
    (
      competition: "示例数据分析挑战赛", date: "2025.05",
      prize: "示例二等奖", bonus: "虚构奖项", title: "参赛作品：实验数据分析方案",
      description: "此处概述任务内容、采用的方法及交付结果。奖项与项目说明可以根据投递方向精简，保持信息清晰并避免重复。",
    ),
  ),
  // 个人自述正文；设为 none 可隐藏该章节。
  summary: "此处填写与目标岗位相关的研究兴趣、技术能力和协作经验。建议用具体事实支持自己的能力描述，突出熟悉的工具、完成过的任务和可验证的产出。本简历中的全部内容均为虚构排版示例。",
)

// ═══════════════════ 二、外观参数（需要时再改） ═══════════════════
// 单位：pt 为排版点，cm 为厘米；百分比的参照范围在对应参数旁注明。
#let settings = (
  // 【字体与排版密度】
  // 字体："sans" 为思源黑体，"serif" 为思源宋体，使用随项目提供的字体。
  font: "sans",
  // 整体密度：compact 较紧凑，standard 适中，relaxed 更舒展。
  // 只改变垂直间距，不会改变字号或自动拉伸至页底。具体数值在本参数区末尾。
  style: "standard",

  // 【字号与颜色】
  // 描述正文的字号，单位 pt；增大后需要相应增大行高，内容也更容易跨页。
  font-size: 10pt,
  // 论文标题、项目名称和比赛名称的字号，单位 pt。
  entry-title-size: 11pt,
  // 顶部姓名的字号，单位 pt。
  name-size: 22pt,
  // 姓名旁身份介绍（role）与方向介绍（focus）的字号，单位 pt。
  tagline-size: 12pt,
  // “教育经历”“论文成果”等章节标题的字号，单位 pt。
  section-size: 12pt,
  // 文字强调、章节图标和横线的颜色，填写十六进制 RGB 色值。
  // 页眉页脚是图片，仍保留图片原有颜色。
  accent: rgb("1c4fa3"),

  // 【页面与个人信息区】
  // A4 正文区域的页边距，单位 cm。上、下边距还需留出页眉和页脚的位置。
  margins: (
    left: 1.2cm,   // 正文距离纸张左边缘的距离
    right: 1.2cm,  // 正文距离纸张右边缘的距离
    top: 1.7cm,    // 正文距离纸张上边缘的距离
    bottom: 1.3cm, // 正文距离纸张下边缘的距离
  ),
  // 允许的最多页数：0 不限制，1 要求单页，其他正整数表示相应页数上限。
  // 超出上限时编译报错，便于发现增删内容后意外出现的第二页。
  max-pages: 0,
  // 照片宽度，占“正文宽度”的百分比；简历中的 photo 为 none 时本项不起作用。
  photo-width: 12.5%,
  // 个人信息区与照片之间的空白，占“正文宽度”的百分比。
  photo-gap: 4.5%,
  // 顶部个人信息表相邻两行之间的额外空白，单位 pt；越大越松。
  info-row-gap: 4.8pt,
  // 顶部个人信息表相邻列之间的空白，单位 pt；会影响标签和值之间的距离。
  info-column-gap: 7.4pt,
  // 是否显示纸张中央的淡色校徽：true 显示，false 隐藏。
  show-watermark: true,
  // 校徽宽度，占“整张纸宽度”的百分比；不影响正文区域宽度。
  watermark-width: 70%,

  // 【章节显示与名称】
  // 数组中的顺序就是实际显示顺序，删除某项即可隐藏该章节。
  // education=教育，papers=论文，projects=项目，awards=比赛，summary=自述。
  sections: ("education", "papers", "projects", "awards", "summary"),
  // 各章节实际显示的标题文字；修改文字不影响章节内的数据。
  section-titles: (
    education: "教育经历", // 教育章节标题
    papers: "论文成果",   // 论文章节标题
    projects: "项目经历", // 项目章节标题
    awards: "比赛经历",   // 比赛章节标题
    summary: "个人自述",  // 自述章节标题
  ),

  // 【间距参数说明】以下参数均使用 pt，允许 0pt，不允许负数。
  // line-height：描述正文相邻两行的基线距离，不能小于 font-size。
  // paragraph-gap：同一条目内部段落之间的空白，如项目内容与个人贡献之间。
  // entry-gap：当前条目前的额外空白；章节首条由章节标题间距控制。
  // header-gap：条目标题、状态行与描述正文之间的空白。
  // section-above：章节标题之前的空白。
  // section-below：章节标题横线与该章节正文之间的空白。
  // section-after：整个章节结束后的额外空白。
  // 优先级：密度预设 < 全局覆盖 < 章节覆盖 < 单条目覆盖。
  // 单条目只支持前四个键，不支持 section- 开头的三个章节参数。

  // 全局间距覆盖：(:) 表示不覆盖，全部采用 style 所选预设。
  // 示例：(line-height: 15pt, entry-gap: 8pt) 会统一增加正文行高和条目前间距。
  global-spacing: (:),
  // 分章节覆盖：每项只填写要调整的键，未填写的继续继承全局和预设。
  section-spacing: (
    education: (:), // 教育章节；段落间距还会影响教育表格的行间空白
    papers: (:),    // 论文；例如 (line-height: 15pt, entry-gap: 8pt)
    projects: (:),  // 项目；例如 (paragraph-gap: 5pt, section-above: 14pt)
    awards: (:),    // 比赛；例如 (entry-gap: 9pt, section-after: 2pt)
    summary: (:),   // 自述；例如 (line-height: 15pt)
  ),

  // 【三种密度的具体数值】通常只需在上面选择 style；想定制三档时再改这里。
  // 保留 compact / standard / relaxed 三个名称和每档的七个参数。
  density-presets: (
    // 紧凑：保留适当留白，适合内容较多的简历。
    compact: (
      line-height: 13.15068pt, // 描述正文行高
      paragraph-gap: 3.18804pt, // 条目内部段间空白
      entry-gap: 3.985pt,       // 当前条目前的额外空白
      header-gap: 3.18804pt,    // 条目标题/状态与正文之间的空白
      section-above: 8.6pt,    // 章节标题之前的空白
      section-below: 4pt,      // 章节横线与正文之间的空白
      section-after: 0pt,      // 整章结束后的额外空白
    ),
    // 标准：默认密度，适合一般长度的简历。
    standard: (
      line-height: 14.2pt,    // 描述正文行高
      paragraph-gap: 4pt,    // 条目内部段间空白
      entry-gap: 6pt,        // 当前条目前的额外空白
      header-gap: 4pt,       // 条目标题/状态与正文之间的空白
      section-above: 11pt,   // 章节标题之前的空白
      section-below: 5pt,    // 章节横线与正文之间的空白
      section-after: 0pt,    // 整章结束后的额外空白
    ),
    // 舒展：留白更多，适合内容较少的简历；内容较多时可能增加页数。
    relaxed: (
      line-height: 15.5pt,   // 描述正文行高
      paragraph-gap: 5pt,    // 条目内部段间空白
      entry-gap: 9pt,        // 当前条目前的额外空白
      header-gap: 5pt,       // 条目标题/状态与正文之间的空白
      section-above: 14pt,   // 章节标题之前的空白
      section-below: 6pt,    // 章节横线与正文之间的空白
      section-after: 0pt,    // 整章结束后的额外空白
    ),
  ),
)

// ═══════════════════ 三、生成文档（通常无需修改） ═══════════════════
#ustc-resume(resume, settings)
