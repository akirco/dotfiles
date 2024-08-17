# Vim User Manual

## About the Manual

This chapter introduces the manuals available with vim. Read this know the conditions underwhich the commands are explained.

## installtion

- config path

```powershell
:h standard-path
```



- install
  - neovim
  - package manager
  - plugins
- config 


## shortcut 

1. `选定`文本块，使用`v`进入可视模式；移动光标键选定内容
2. `复制`选定文本块到缓存区，使用`y`复制;整行复制使用`yy`
3. `剪切`选定块到缓冲区，用`d`;剪切整行用`dd`
4. `粘贴`缓冲区的内容，使用`p` 
5. 跳转到`行首`，使用`0`或者`home`,区别与`^`(不是blank字符)
6. 跳转到`行尾`，使用`s`或者`end`,区别于`$`(同上)
7. 在同一个编辑窗口打开另一文件使用`sp [filename]`
8. 在多个编辑窗口间切换`Ctrl+w+w`
9. 


## vim config

### plugin mangager

- packer.vim

```powershell
git clone https://github.com/wbthomason/packer.nvim "$env:LOCALAPPDATA\nvim-data\site\pack\packer\start\packer.nvim"


nvim $env:LOCALAPPDATA\nvim\lua\plugins.lua 
```


### Plugins

- [vim-easy-align](https://github.com/junegunn/vim-easy-align)

```vim
Plug 'junegunn/vim-easy-align'
```


### NvChad keymap

<leader> = <space>

| model    | shortcut   | info   |
|-------------- | -------------- | -------------- |
| Normal | <Tab>   | goto next buffer     |
| Normal | <Esc>   | no highlight |
| Normal | <Space>x| close buffer |
| Normal | <Space>tk | show keys   |
| Normal | <Space>ff | find files |
| Normal | <Space>fo | find oldfiles |
| Normal | <Space>th | nvchad themes |
| Normal | <Space>fh | help pages |
| Normal | <Space>pt | pike hidden term |
| Normal | <Space>fb | find buffer |
| Normal | <Space>gt | git status |
| Normal | <Space>fw | live grep |
| Normal | <Space>cm | git commits |
| Normal | <Space>fa | find all |
| Normal | <Space>v  | new vertical term |
| Normal | <Space>h  | new horizontal term |
| Normal | <Space>e  | focus nvim tree |
| Normal | <Space>cc | jump to current context |
| Normal | <Space>/  | toggle comment |
| Normal | <Space>n  | toggle line number |
| Normal | <Space>rn | toggle relative number |
| Normal | <Space>ttz | toggle theme |
| Normal | <Space>uu | update nvchad |
| Normal | <Space>b  | new buffer |
| Normal | <&>       | nvim builtin |
| Normal | <Y>       | nvim builtin |
| Normal | <\>       | pick buffer  |
| Normal | <gc>      |    test          |
| Normal | <Space>x| close buffer |
| Normal | <Space>x| close buffer |
| Normal | <Space>x| close buffer |
| Normal | <Space>x| close buffer |
| Normal | <Space>x| close buffer |
| Normal | <Space>x| close buffer |
| Normal | <Space>x| close buffer |

