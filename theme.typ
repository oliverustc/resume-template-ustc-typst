// 排版实现文件。日常只编辑 content.typ；本文件不导入其他 Typst 文件。
// 所有示例及公开预览使用虚构信息；字体和图标许可保留在素材目录。
#let ustc-resume(resume, settings) = {
  let font-families = (sans: "Source Han Sans SC", serif: "Source Han Serif SC")
  let active-font = settings.font
  assert(active-font in font-families, message: "Unknown font preset: " + active-font)
  let font-family = font-families.at(active-font)
  let active-style = settings.style

  // 内部几何常量保持科大版式；用户设置由 content.typ 的 settings 传入。
  // 字号与正文行高由原 LaTeX 的 TeX point 换算（乘 72/72.27）。
  // 图片尺寸、基线修正和章节间距来自原 PDF 的视觉校准，集中在此维护。
  let theme = (
    accent: settings.accent, // 科大蓝；同步用于正文强调、横线和章节 SVG 图标。
    fonts: (regular: font-family, bold: font-family),
    text: (size: settings.font-size, word-gap: 9.96pt),
    page: (paper: "a4", margin: settings.margins),
    header: (
      background: "images/header.png", logo: "images/ustc-icon.png",
      logo-x: 0.7cm, logo-y: 7.02pt, logo-width: 55.8mm,
      school-x: -0.8cm, school-y: 17.37pt,
    ),
    footer: (
      background: "images/footer.png", y: -8.15pt, size: 7.97pt,
      icon-size: 7.97pt, icon-gap: 7.97pt, contact-gap: 27.9pt,
    ),
    // SVG 是唯一校徽源文件，内部已包含 PNG 像素与 5% 透明度；无需额外 PNG。
    watermark: (path: "images/watermark.svg", width: settings.watermark-width),
    personal: (
      // 左侧占剩余宽度，照片比例与原稿相同；信息标签按内容宽度自适应。
      columns: (1fr, settings.photo-gap, settings.photo-width), info-columns: (auto, 1fr, auto, 1fr),
      info-row-gap: settings.info-row-gap, info-column-gap: settings.info-column-gap, info-y: 0.5pt,
      name-size: settings.name-size, tagline-size: settings.tagline-size, title-y: -1.79pt,
      name-gap: 14.5pt, tagline-gap: 5.98pt, info-gap: 5.48pt,
    ),
    section: (
      size: settings.section-size,
      icon-box-width: 15.5pt, icon-box-height: 11.955pt,
      icon-width: 14pt, icon-height: 11pt, icon-baseline: 2pt, icon-gap: 12.25pt,
      rule-gap: 3pt, rule-width: 0.3985pt, // 原稿的 0.4 TeX pt 横线。
    ),
    education: (
      columns: (auto, 1fr, auto), column-gap: 9.96pt, row-extra: 1.58196pt,
      following-extra: 0.58pt, // 教育表格后额外间距，与图标种类无关。
    ),
    entry: (
      column-gap: 9.96pt, right-max: 35%,
      link-gap: 5pt, link-icon-size: 9.96pt, link-baseline: 2pt,
    ),
  )

  // 用户可编辑的预设和数值全部从 content.typ 传入。
  let spacing-presets = settings.density-presets
  let spacing-keys = ("line-height", "paragraph-gap", "entry-gap", "header-gap",
    "section-above", "section-below", "section-after")
  let entry-spacing-keys = ("line-height", "paragraph-gap", "entry-gap", "header-gap")
  let section-keys = ("education", "papers", "projects", "awards", "summary")

  let validate-spacing(values, keys: spacing-keys) = {
    for (key, value) in values {
      assert(key in keys, message: "Unknown spacing key: " + key)
      assert(type(value) == length and value >= 0pt, message: "Spacing must be a non-negative length: " + key)
    }
  }

  // 覆盖优先级：预设 < 全局 < 章节 < 调用者/单条目。
  let resolve-spacing(style: active-style, global: settings.global-spacing,
    sections: settings.section-spacing, section: none, overrides: (:)) = {
    assert(style in spacing-presets, message: "Unknown layout style: " + style)
    validate-spacing(spacing-presets.at(style))
    assert(section == none or section in section-keys, message: "Unknown spacing section.")
    validate-spacing(global)
    for (key, values) in sections {
      assert(key in section-keys, message: "Unknown spacing section: " + key)
      validate-spacing(values)
    }
    validate-spacing(overrides)
    let local = if section == none { (:) } else { sections.at(section, default: (:)) }
    spacing-presets.at(style) + global + local + overrides
  }
  let spacing-for(section: none, overrides: (:)) = resolve-spacing(section: section, overrides: overrides)


  let present(value) = value != none and value != "" and value != [] and value != ()
  let field(data, key) = data.at(key, default: none)
  let bold(body) = text(font: theme.fonts.bold, weight: "bold", body)
  let entry-title(body) = text(size: settings.entry-title-size, bold(body))
  let default-spacing = spacing-for()
  let line-leading(spacing) = {
    assert(spacing.line-height >= theme.text.size, message: "line-height must be at least the body font size.")
    spacing.line-height - theme.text.size
  }
  let join-values(values, gap: theme.text.word-gap) = values.filter(present).join(h(gap))

  let icon(name, color, width, height: auto) = {
    let source = read("icons/" + name + ".svg").replace("#000000", color.to-hex())
    image(bytes(source), format: "svg", width: width, height: height, fit: "contain", alt: none)
  }

  let contacts(p) = {
    let items = ()
    if present(field(p, "email")) {
      items.push([
        #box(baseline: 0pt, icon("envelope", white, theme.footer.icon-size))
        #h(theme.footer.icon-gap)#link("mailto:" + p.email, p.email)
      ])
    }
    if present(field(p, "phone")) {
      items.push([
        #box(baseline: 0pt, icon("phone", white, theme.footer.icon-size))
        #h(theme.footer.icon-gap)#p.phone
      ])
    }
    items.join(h(theme.footer.contact-gap))
  }

  let cv(resume, body) = {
    assert(sys.version >= version(0, 15, 1), message: "This project requires Typst 0.15.1 or newer.")
    assert(present(field(resume, "name")), message: "resume.name is required.")
    let max-pages = settings.max-pages
    assert(max-pages >= 0, message: "max-pages must be a non-negative integer.")
    set document(title: resume.name + "个人简历", author: resume.name)
    set text(font: theme.fonts.regular, weight: "regular", size: theme.text.size,
      lang: "zh", region: "CN", cjk-latin-spacing: none,
      top-edge: 0.8em, bottom-edge: -0.2em, hyphenate: false, overhang: true)
    set par(leading: line-leading(default-spacing), spacing: default-spacing.paragraph-gap, justify: true, first-line-indent: 0pt)
    set block(above: 0pt, below: 0pt)
    show strong: set text(font: theme.fonts.bold, weight: "bold")
    set page(paper: theme.page.paper, margin: theme.page.margin, numbering: none,
      background: block(width: 100%, height: 100%)[
        #place(top + left, image(theme.header.background, width: 100%))
        #place(top + left, dx: theme.header.logo-x, dy: theme.header.logo-y,
          image(theme.header.logo, width: theme.header.logo-width))
        #if present(field(resume, "school")) {
          place(top + right, dx: theme.header.school-x, dy: theme.header.school-y,
            text(fill: white, bold(resume.school)))
        }
        #if settings.show-watermark { place(center + horizon, image(theme.watermark.path, width: theme.watermark.width)) }
        #place(bottom + left, image(theme.footer.background, width: 100%))
      ],
      foreground: block(width: 100%, height: 100%)[
        #place(bottom + center, dy: theme.footer.y,
          text(size: theme.footer.size, fill: white, contacts(resume)))
      ])
    body
    context {
      let pages = counter(page).final().first()
      assert(max-pages == 0 or pages <= max-pages,
        message: "Page limit exceeded: " + str(pages) + " pages; allowed " + str(max-pages) + ".")
      [#metadata((pages: pages, style: active-style, font: active-font)) <resume-stats>]
    }
  }

  let personal(p) = {
    let info = (
      (label: "性别", value: field(p, "gender")),
      (label: "民族", value: field(p, "ethnicity")),
      (label: "出生年月", value: field(p, "birthday")),
      (label: "籍贯", value: field(p, "hometown")),
      (label: "手机", value: field(p, "phone")),
      (label: "邮箱", value: field(p, "email"), url: if present(field(p, "email")) { "mailto:" + p.email } else { none }),
    )
    // details 可覆盖默认字段顺序，或加入主页等自定义字段。
    info = p.at("details", default: info).filter(item => present(field(item, "value")))
    let title = [
      #text(size: theme.personal.name-size, fill: theme.accent, bold(p.name))
      #let tagline = (field(p, "role"), field(p, "focus")).filter(present)
      #if tagline.len() > 0 {
        h(theme.personal.name-gap)
        text(size: theme.personal.tagline-size, tagline.join([#h(theme.personal.tagline-gap)|#h(theme.personal.tagline-gap)]))
      }
    ]
    let details = [
      #move(dy: theme.personal.title-y, title)
      #if info.len() > 0 {
        v(theme.personal.info-gap)
        move(dy: theme.personal.info-y, grid(columns: theme.personal.info-columns,
          column-gutter: theme.personal.info-column-gap, row-gutter: theme.personal.info-row-gap,
          ..info.map(item => (
            [#item.label：],
            if present(field(item, "url")) { link(item.url, item.value) } else { item.value },
          )).flatten()))
      }
    ]
    block(breakable: false)[
      #if present(field(p, "photo")) {
        grid(columns: theme.personal.columns, align: horizon,
          details, [], image(p.photo, width: 100%, alt: p.at("photo-alt", default: "简历头像")))
      } else { details }
    ]
  }

  // 真正的 heading 提供 PDF 书签与标题结构；外观仍沿用科大样式。
  let cv-section(symbol, title, body, above: auto, spacing: default-spacing) = {
    set par(leading: line-leading(spacing), spacing: spacing.paragraph-gap)
    let before = if above == auto { spacing.section-above } else { above }
    show heading.where(level: 1): it => block(above: before, below: spacing.section-below, sticky: true)[
      #set text(font: theme.fonts.regular, weight: "regular", size: theme.text.size)
      #stack(dir: ttb, spacing: theme.section.rule-gap,
        text(size: theme.section.size)[#box(width: theme.section.icon-box-width, height: theme.section.icon-box-height,
        baseline: theme.section.icon-baseline,
        align(center + horizon, icon(symbol, theme.accent,
          theme.section.icon-width, height: theme.section.icon-height)))#h(theme.section.icon-gap)#bold(it.body)],
        line(length: 100%, stroke: theme.section.rule-width + theme.accent),
      )
    ]
    heading(level: 1, numbering: none, title)
    body
    if spacing.section-after > 0pt { v(spacing.section-after) }
  }

  let education(rows, spacing: spacing-for(section: "education")) = grid(
    columns: theme.education.columns,
    column-gutter: theme.education.column-gap, row-gutter: spacing.paragraph-gap + theme.education.row-extra,
    ..rows.map(e => (
      join-values((bold(e.university), field(e, "degree"))),
      join-values((field(e, "school"), field(e, "major"))),
      e.at("dates", default: []),
    )).flatten(),
  )

  // 右栏最多占可用宽度的 35%；两侧均可换行，避免长标题与日期挤压。
  let row(lhs, rhs, right-fill: black) = {
    if not present(rhs) { par(lhs) }
    else {
      layout(size => {
        let right-width = calc.min(measure(rhs).width, size.width * theme.entry.right-max)
        grid(columns: (1fr, right-width), column-gutter: theme.entry.column-gap,
          align: (left, right), lhs, text(fill: right-fill, rhs))
      })
    }
  }

  // 标题和状态作为不可拆的前缀，粘住下一段；长正文仍允许自然跨页。
  let entry(head, body, first: false, spacing: default-spacing) = {
    set par(leading: line-leading(spacing), spacing: spacing.paragraph-gap)
    block(breakable: false, sticky: present(body),
      above: if first { 0pt } else { spacing.entry-gap + spacing.paragraph-gap },
      below: if present(body) { spacing.header-gap } else { 0pt }, head)
    body
  }

  let papers(entries, spacing: spacing-for(section: "papers")) = {
    for (i, p) in entries.enumerate() {
      let local = p.at("spacing", default: (:))
      validate-spacing(local, keys: entry-spacing-keys)
      let item-spacing = spacing + local
      let status = field(p, "status")
      let badge = field(p, "badge")
      let url = field(p, "url")
      let badge-body = if present(url) {
        link(url)[#bold(if present(badge) { badge } else { "论文链接" })#h(theme.entry.link-gap)#box(baseline: theme.entry.link-baseline, icon("external-link", black, theme.entry.link-icon-size))]
      } else if present(badge) { bold(badge) } else { [] }
      let head = stack(dir: ttb, spacing: item-spacing.header-gap,
        par(entry-title(p.title)),
        ..if present(status) { (row(text(fill: theme.accent, bold(status)), badge-body),) }
          else if present(badge-body) { (par(badge-body),) } else { () },
      )
      let body = if present(field(p, "description")) { par(p.description) } else { [] }
      entry(head, body, first: i == 0, spacing: item-spacing)
    }
  }

  let projects(entries, spacing: spacing-for(section: "projects")) = {
    for (i, p) in entries.enumerate() {
      let local = p.at("spacing", default: (:))
      validate-spacing(local, keys: entry-spacing-keys)
      let item-spacing = spacing + local
      let paragraphs = ()
      if present(field(p, "description")) { paragraphs.push(par([#bold[项目内容：]#p.description])) }
      if present(field(p, "contribution")) { paragraphs.push(par([#bold[个人贡献：]#p.contribution])) }
      entry(row(entry-title(p.title), field(p, "sponsor"), right-fill: theme.accent), paragraphs.join(), first: i == 0, spacing: item-spacing)
    }
  }

  let awards(entries, spacing: spacing-for(section: "awards")) = {
    for (i, a) in entries.enumerate() {
      let local = a.at("spacing", default: (:))
      validate-spacing(local, keys: entry-spacing-keys)
      let item-spacing = spacing + local
      let parts = ()
      let prize = join-values((field(a, "prize"), field(a, "bonus")))
      if present(prize) { parts.push(text(fill: theme.accent, bold(prize))) }
      if present(field(a, "title")) { parts.push(bold(a.title)) }
      let subtitle = join-values(parts)
      let head = stack(dir: ttb, spacing: item-spacing.header-gap,
        row(entry-title(a.competition), field(a, "date")),
        ..if present(subtitle) { (par(subtitle),) } else { () },
      )
      let body = if present(field(a, "description")) { par(a.description) } else { [] }
      entry(head, body, first: i == 0, spacing: item-spacing)
    }
  }

  let default-sections = ("education", "papers", "projects", "awards", "summary")
  let render-resume(p, sections: default-sections) = {
    assert(sections.dedup().len() == sections.len(), message: "Duplicate section identifiers.")
    personal(p)
    let previous = none
    for key in sections {
      assert(key in default-sections, message: "Unknown section: " + key)
      let data = field(p, key)
      if present(data) {
        let spacing = spacing-for(section: key)
        let above = spacing.section-above + if previous == "education" { theme.education.following-extra } else { 0pt }
        if key == "education" { cv-section("education", settings.section-titles.education, above: above, spacing: spacing, education(data, spacing: spacing)) }
        else if key == "papers" { cv-section("paperclip", settings.section-titles.papers, above: above, spacing: spacing, papers(data, spacing: spacing)) }
        else if key == "projects" { cv-section("wrench", settings.section-titles.projects, above: above, spacing: spacing, projects(data, spacing: spacing)) }
        else if key == "awards" { cv-section("trophy", settings.section-titles.awards, above: above, spacing: spacing, awards(data, spacing: spacing)) }
        else if key == "summary" { cv-section("address-card", settings.section-titles.summary, above: above, spacing: spacing, par(data)) }
        previous = key
      }
    }
  }

    cv(resume, render-resume(resume, sections: settings.sections))
}
