" classpaths.vim
" Maintainer: rob boll <http://robertcboll.com>

" get the classpath for a given buffer
function classpaths#set_vimcp_for_buffer()
	" check if its set
	if !exists("b:vimcp")
		let cpfile = findfile(".vimcp", ".;")
		if filereadable(cpfile)
			let b:vimcp = join(readfile(cpfile))
		else
			let b:vimcp = ""
		endif
	endif

	call javacomplete#AddClassPath(b:vimcp)
endfunction

" update classpath closest to this buffer
function classpaths#update_classpath() 
	let rootdir = ""
	let toolname = ""

	for tool in ["maven", "sbt"]
		let rootdir = tools#find_tool_root("" . tool) 
		
		" found a project root
		if rootdir !=# ""
			break
		endif
	endfor

	echon "updating classpaths (may take a minute)... "
	execute "call tools#" . tool . "_write_classpath(\"" . rootdir . "\")"
	echon "complete!"
endfunction

" delete classpath closest to this buffer
function classpaths#delete_classpath()
	delete(findfile(".vimcp", ".;"))
endfunction
