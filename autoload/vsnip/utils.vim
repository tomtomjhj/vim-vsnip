function! vsnip#utils#get_indent() abort
  if !&expandtab
    return "\t"
  endif
  if &shiftwidth
    return repeat(' ', &shiftwidth)
  endif
  return repeat(' ', &tabstop)
endfunction

function! vsnip#utils#get_indent_level(line, indent) abort
  return strlen(substitute(matchstr(a:line, '^\s*'), a:indent, '_', 'g'))
endfunction

function! vsnip#utils#text_index2buffer_pos(text_start_pos, index_in_text, text) abort
  let l:lines = split(strpart(a:text, 0, a:index_in_text), "\n", v:true)

  let l:lnum_in_text = len(l:lines) - 1
  let l:col_in_text = strlen(l:lines[-1])

  let l:lnum = a:text_start_pos[0] + l:lnum_in_text
  let l:col = l:col_in_text + (l:lnum_in_text == 0 ? a:text_start_pos[1] : 1)

  return [l:lnum, l:col]
endfunction

function! vsnip#utils#curpos() abort
  let l:pos = getcurpos()
  let l:line = getline(l:pos[1])
  let l:col = min([l:pos[2], strlen(l:line)])
  if index(['i', 'ic', 'ix'], mode()) >= 0 && l:pos[2] <= strlen(l:line)
    let l:col = l:col - 1
  endif
  return [l:pos[1], l:col]
endfunction

function! vsnip#utils#get(dict, keys, def) abort
  let l:keys = type(a:keys) == v:t_string ? [a:keys] : a:keys
  let l:target = a:dict
  for l:key in l:keys
    if index([v:t_dict, v:t_list], type(l:target)) == -1 | return a:def | endif
    let _ = get(l:target, l:key, v:null)
    unlet! l:target
    let l:target = _
    if l:target is v:null | return a:def | endif
  endfor
  return l:target
endfunction

function! vsnip#utils#to_list(v) abort
  if type(a:v) ==# v:t_list
    return a:v
  endif
  return [a:v]
endfunction

function! vsnip#utils#inputlist(prompt, candidates) abort
  if len(a:candidates) <= 1
    return get(a:candidates, 0, v:null)
  endif

  let l:idx = inputlist([a:prompt] + map(a:candidates, { i, v -> printf('  %s: %s', i + 1, v) }))
  if l:idx <= 0
    return v:null
  endif
  return substitute(a:candidates[l:idx - 1], '^\s\+\d\+: ', '', 'g')
endfunction

function! vsnip#utils#yesno(prompt) abort
  return index(['y', 'ye', 'yes'], input(a:prompt . '(yes/no): ')) >= 0
endfunction

