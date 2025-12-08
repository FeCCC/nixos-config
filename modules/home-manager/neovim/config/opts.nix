{
  fileencodings = "ucs-bom ,utf-8 ,cp936 ,gb18030 ,big5 ,euc-jp ,euc-kr ,latin1"; # 设置编码自动识别
  wrap = false; # 禁止折行显示文本
  scrolloff = 8; # 光标移动的时候始终保持 8 个空格的间隔
  sidescrolloff = 8; # 光标移动的时候始终保持 8 个空格的间隔
  number = true; # 设置行号
  cursorline = true; # 设置高亮显示光标所在行
  signcolumn = "yes"; # 设置左侧图标指示列
  shiftround = true; # NORMAL 模式下 >> << 和 INSERT 模式下 CTRL-T CTRL-D 的缩进长度
  shiftwidth = 4; # NORMAL 模式下 >> << 和 INSERT 模式下 CTRL-T CTRL-D 的缩进长度
  tabstop = 4; # 修改tab显示宽度
  expandtab = true; # 设置空格替代 tab
  list = true; # 把空格显示成一个点
  listchars = "tab:>-,space:·"; # 把空格显示成一个点
  autoindent = true; # 新行对齐当前行
  smartindent = true; # 新行对齐当前行
  ignorecase = true; # 搜索大小写不敏感 而在包含大写的时候让搜索变成大小写敏感
  smartcase = true; # 搜索大小写不敏感 而在包含大写的时候让搜索变成大小写敏感
  hlsearch = false; # 搜索结果不高亮显示
  cmdheight = 1; # 命令行高设置为 1 行
  autoread = true; # 当文件被外部程序修改的时候 自动加载修改后的内容
  mouse = "a"; # 开鼠标支持
  backup = false; # 禁止创建备份文件
  writebackup = false; # 禁止创建备份文件
  swapfile = false; # 禁止创建备份文件
  completeopt = "menu,menuone,noselect,noinsert"; # 自动补全但是不会自动选中
  wildmenu = true; # 命令tab补全
  showtabline = 2; # 永远显示 tabline

  updatetime = 300; # 缩短 swap file 的更新时间间隔
  timeoutlen = 500; # 设置快捷键触发的等待时间

  sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"; # session
}
