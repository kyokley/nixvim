{
    extraConfigVim = ''
        " Error Functions {{{
        function! s:FindError(file_name, bad_str, error_msg, ...) abort
            " Sometimes need to remove a temporary buffer
            let l:remove_temp_buffer = get(a:000, 0, 0)

            let l:line = search('\c' . a:bad_str, 'nw')
            if l:line != 0
                if match(getline(l:line), '\c' . a:file_name) == -1
                    let l:message = a:error_msg . ' ' . a:file_name . ':' . l:line
                else
                    let l:message = a:error_msg . ' ' . getline(l:line)
                endif

                if l:remove_temp_buffer
                    bdelete!
                endif

                throw l:message
            endif
        endfunction

        function! RaiseExceptionForUnresolvedErrors() abort
            let s:file_name = expand('%:t')

            " Check for unresolved VCS conflicts
            call s:FindError(s:file_name, '\v^[<=>]{7}( .*|$)', 'Found unresolved conflicts in')

            " Check for trailing whitespace
            call s:FindError(s:file_name, '\s\+$', 'Found trailing whitespace in')

            if &filetype == 'python'

                let current_lazyredraw = &lazyredraw

                set lazyredraw
                silent %yank p
                new
                setlocal nobuflisted buftype=nofile bufhidden=delete noswapfile
                silent 0put p

                " Open all folds before messing with the buffer
                silent normal zR
                silent $,$delete

                try
                    let pyflakes_cmd = '%!ruff --stdin-filename ' . s:file_name . ' -'
                    let bandit_cmd = '%!bandit -ll -s B322,B101 -'

                    silent execute pyflakes_cmd

                    let error_strs = ['\(unable to detect \)\@<!undefined name',
                                \ 'unexpected indent',
                                \ 'expected an indented block',
                                \ 'invalid syntax',
                                \ 'unindent does not match any outer indentation level',
                                \ 'EOL while scanning string literal',
                                \ 'redefinition of unused',
                                \ 'list comprehension redefines',
                                \ 'shadowed by loop variable',
                                \ 'syntax error',
                                \ 'referenced before assignment',
                                \ 'duplicate argument',
                                \ 'repeated with different values',
                                \ 'imports must occur at the beginning of the file',
                                \ 'outside function',
                                \ 'not properly in loop',
                                \ 'outside loop',
                                \ 'two starred expressions in assignment',
                                \ 'too many expressions in star-unpacking assignment',
                                \ 'assertion is always true',
                                \ 'trailing comma not allowed without surrounding parentheses',
                                \ 'keyword argument repeated',
                                \ 'problem decoding source',
                                \ 'EOF in multi-line statement',
                                \ 'simple statements must be separated',
                                \ 'unexpected EOF']

                    for error_str in error_strs
                        call s:FindError(s:file_name, error_str, 'Syntax error!', 1)
                    endfor

                finally
                    let &lazyredraw = current_lazyredraw
                endtry

                bdelete!

                silent %yank p
                new
                silent 0put p
                silent $,$delete
                silent execute bandit_cmd
                silent execute '%s/<stdin>/' . s:file_name . '/e'

                let s:is_res = search('^>> Issue:', 'nw')
                if s:is_res != 0
                    let s:res_end = s:is_res + 2
                    for item in getline(s:is_res, s:res_end)
                        echohl ErrorMsg | echo item | echohl None
                    endfor

                    bdelete!
                    let &lazyredraw = current_lazyredraw
                    throw 'Bandit Error'
                endif

                bdelete!
                let &lazyredraw = current_lazyredraw
            endif
        endfunction
        " }}}

        " Python Breakpoints {{{
        python3 << EOF
        import vim
        def SetBreakpoint():
            import re
            nLine = int(vim.eval('line(".")'))

            strLine = vim.current.line
            strWhite = re.search('^(\s*)', strLine).group(1)

            vim.current.buffer.append(
            "%(space)simport pdb; pdb.set_trace()  # %(mark)s Breakpoint %(mark)s" %
                {'space':strWhite, 'mark': '#' * 30}, nLine - 1)


        def RemoveBreakpoints():
            nCurrentLine = int(vim.eval('line(".")'))

            nLines = []
            nLine = 1
            for strLine in vim.current.buffer:
                if strLine == "import pdb" or strLine.lstrip()[:27] == "import pdb; pdb.set_trace()":
                    nLines.append( nLine)
                nLine += 1

            nLines.reverse()

            for nLine in nLines:
                vim.command("normal %dG" % nLine)
                vim.command("normal dd")
                if nLine < nCurrentLine:
                    nCurrentLine -= 1

            vim.command("normal %dG" % nCurrentLine)

        EOF
        " }}}

        " Indentation Text Objects {{{
        " Thanks to Dylan McClure for the following indent text objects. They are
        " awesome!
        " https://vimways.org/2018/transactions-pending/
        function! InIndentation()
            " select all text in current indentation level excluding any empty lines
            " that precede or follow the current indentationt level;
            "
            " the current implementation is pretty fast, even for many lines since it
            " uses "search()" with "\%v" to find the unindented levels
            "
            " NOTE: if the current level of indentation is 1 (ie in virtual column 1),
            "       then the entire buffer will be selected
            "
            " WARNING: python devs have been known to become addicted to this

            " magic is needed for this
            let l:magic = &magic
            set magic

            " move to beginning of line and get virtcol (current indentation level)
            " BRAM: there is no searchpairvirtpos() ;)
            normal! ^
            let l:vCol = virtcol(getline('.') =~# '^\s*$' ? '$' : '.')

            " pattern matching anything except empty lines and lines with recorded
            " indentation level
            let l:pat = '^\(\s*\%'.l:vCol.'v\|^$\)\@!'

            " find first match (backwards & don't wrap or move cursor)
            let l:start = search(l:pat, 'bWn') + 1

            " next, find first match (forwards & don't wrap or move cursor)
            let l:end = search(l:pat, 'Wn')

            if (l:end !=# 0)
                    " if search succeeded, it went too far, so subtract 1
                    let l:end -= 1
            endif

            " go to start (this includes empty lines) and--importantly--column 0
            execute 'normal! '.l:start.'G0'

            " skip empty lines (unless already on one .. need to be in column 0)
            call search('^[^\n\r]', 'Wc')

            " go to end (this includes empty lines)
            execute 'normal! Vo'.l:end.'G'

            " skip backwards to last selected non-empty line
            call search('^[^\n\r]', 'bWc')

            " go to end-of-line 'cause why not
            normal! $o

            " restore magic
            let &magic = l:magic
        endfunction

        function! AroundIndentation()
            " select all text in the current indentation level including any emtpy
            " lines that precede or follow the current indentation level;
            "
            " the current implementation is pretty fast, even for many lines since it
            " uses "search()" with "\%v" to find the unindented levels
            "
            " NOTE: if the current level of indentation is 1 (ie in virtual column 1),
            "       then the entire buffer will be selected
            "
            " WARNING: python devs have been known to become addicted to this

            " magic is needed for this (/\v doesn't seem work)
            let l:magic = &magic
            set magic

            " move to beginning of line and get virtcol (current indentation level)
            " BRAM: there is no searchpairvirtpos() ;)
            normal! ^
            let l:vCol = virtcol(getline('.') =~# '^\s*$' ? '$' : '.')

            " pattern matching anything except empty lines and lines with recorded
            " indentation level
            let l:pat = '^\(\s*\%'.l:vCol.'v\|^$\)\@!'

            " find first match (backwards & don't wrap or move cursor)
            let l:start = search(l:pat, 'bWn') + 1

            " NOTE: if l:start is 0, then search() failed; otherwise search() succeeded
            "       and l:start does not equal line('.')
            " FORMER: l:start is 0; so, if we add 1 to l:start, then it will match
            "         everything from beginning of the buffer (if you don't like
            "         this, then you can modify the code) since this will be the
            "         equivalent of "norm! 1G" below
            " LATTER: l:start is not 0 but is also not equal to line('.'); therefore,
            "         we want to add one to l:start since it will always match one
            "         line too high if search() succeeds

            " next, find first match (forwards & don't wrap or move cursor)
            let l:end = search(l:pat, 'Wn')

            " NOTE: if l:end is 0, then search() failed; otherwise, if l:end is not
            "       equal to line('.'), then the search succeeded.
            " FORMER: l:end is 0; we want this to match until the end-of-buffer if it
            "         fails to find a match for same reason as mentioned above;
            "         again, modify code if you do not like this); therefore, keep
            "         0--see "NOTE:" below inside the if block comment
            " LATTER: l:end is not 0, so the search() must have succeeded, which means
            "         that l:end will match a different line than line('.')

            if (l:end !=# 0)
                " if l:end is 0, then the search() failed; if we subtract 1, then it
                " will effectively do "norm! -1G" which is definitely not what is
                " desired for probably every circumstance; therefore, only subtract one
                " if the search() succeeded since this means that it will match at least
                " one line too far down
                " NOTE: exec "norm! 0G" still goes to end-of-buffer just like "norm! G",
                "       so it's ok if l:end is kept as 0. As mentioned above, this means
                "       that it will match until end of buffer, but that is what I want
                "       anyway (change code if you don't want)
                let l:end -= 1
            endif

            " finally, select from l:start to l:end
            execute 'normal! '.l:start.'G0V'.l:end.'G$o'

            " restore magic
            let &magic = l:magic
        endfunction
        " }}}
    '';
}
