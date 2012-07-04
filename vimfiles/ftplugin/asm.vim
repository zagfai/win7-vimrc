set filetype=masm
set makeprg="ml /Zm /Bl link16 %"
map <F6> :!command<CR>
imap <F6> <Esc><F6>
map <F5> :!debug %:r.exe<CR>
imap <F5> :<Esc><F5>
