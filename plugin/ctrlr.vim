"" =============================================================================
"" File:          plugin/ctrlr.vim
"" Description:   Ex command history reverse-i-search in Vim
"" Author:        Vic Goldfeld <github.com/goldfeld>
"" Version:       0.1
"" ReleaseDate:   2013-06-09
"" License:       MIT License (see below)
""
"" Copyright (C) 2013 Vic Goldfeld under the MIT License.
""
"" Permission is hereby granted, free of charge, to any person obtaining a 
"" copy of this software and associated documentation files (the "Software"), 
"" to deal in the Software without restriction, including without limitation 
"" the rights to use, copy, modify, merge, publish, distribute, sublicense, 
"" and/or sell copies of the Software, and to permit persons to whom the 
"" Software is furnished to do so, subject to the following conditions:
""
"" The above copyright notice and this permission notice shall be included in 
"" all copies or substantial portions of the Software.
""
"" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
"" OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
"" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
"" THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR 
"" OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, 
"" ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR 
"" OTHER DEALINGS IN THE SOFTWARE.
"" =============================================================================

if exists('g:loaded_ctrlr') || &cp
  finish
endif
let g:loaded_ctrlr = 1

set history=1000

let s:k = {
  \ 'RETURN': 13, 'BACKSPACE': 8, 'ESCAPE': 27, 'CTRL_U': 21,
  \ 'CTRL_R': 18, 'CTRL_W': 23, 'CTRL_A': 1, 'CTRL_L': 12, 'CTRL_M': 13
  \ }

cnoremap <expr> <C-R> <SID>ctrlr()

function! s:ctrlr()
  let char = getchar()
  if len(getcmdline())
    let key = nr2char(l:char)

    if l:key =~# '[0-9a-z"%#:-=.]' | return getreg(l:key)
    elseif l:char == s:k.CTRL_W | return expand('<cword>')
    elseif l:char == s:k.CTRL_A | return expand('<cWORD>')
    elseif l:char == s:k.CTRL_L | return getline('.')

    elseif l:char == s:k.CTRL_M
      let [linenr, pos] = [line('.'), col('.')]
      let linetext = getline(l:linenr)
      let opening = strridx(l:linetext[: l:pos], '`')
      if l:opening == -1 | return '' | endif

      let result = l:linetext[l:opening :]
      let [l:linetext, closing] = ['', -1]
      while l:closing == -1 && l:linenr <= line('$')
        let l:linenr += 1
        let l:linetext = getline(l:linenr)
        let l:result .= ' ' . l:linetext
        let l:closing = stridx(l:linetext[l:pos :], '`')
      endwhile

      return l:result " . l:linetext[: l:closing]
    endif

  else 
    redir @r
    silent! history
    redir END

    " split the history into a list, exclude the '#  cmd history' header, and
    " reverse it to have more recent history on lower indexes.
    let cmdhist = reverse(split(@r, '\n')[1:])
    " remove the '>' from the most recent listing.
    let l:cmdhist[0] = substitute(l:cmdhist[0], '^>', ' ', '')
    " clean/trim the listings with a map invocation.
    let l:cmdhist = map(l:cmdhist, "strpart(v:val, 9)")

    let term = ''
    let currentmatch = ''
    let skip = 0
    while l:char != s:k.ESCAPE
      let previousTerm = l:term

      if l:char == s:k.RETURN | return l:currentmatch . "\<CR>"
      elseif l:char == s:k.CTRL_R | let l:skip += 1
      else
        " whenever the user presses an additional ^R, that means he wants to
        " skip the current match, but if he presses any other editing escape
        " sequence or a char, we need to reset his skips.
        let l:skip = 0

        if l:char == s:k.BACKSPACE
          let l:term = strpart(l:term, 0, len(l:term) - 1)
          let l:currentmatch = l:term

        elseif l:char == s:k.CTRL_U | let l:term = ''
        elseif l:char == s:k.CTRL_W | let l:term = ''

        else | let l:term = l:term . nr2char(l:char)
        endif
      endif

      let l:skipCount = l:skip
      let l:found = 0
      for entry in l:cmdhist
        if stridx(entry, l:term) != -1

          if l:skipCount | let l:skipCount -= 1
          else
            let l:currentmatch = entry
            let l:found = 1
            break
          endif

        endif
      endfor

      " if we found no new match, don't show the new char (if applicable)
      if !l:found | let l:term = l:previousTerm | endif

      echo "(reverse-i-search)`" . l:term . "': " . l:currentmatch
      let l:char = getchar()
    endwhile
  endif
  return l:currentmatch
endfunction
