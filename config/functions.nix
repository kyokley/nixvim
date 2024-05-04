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
    '';
}
