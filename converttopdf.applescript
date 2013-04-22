on run theQuery
	set these_files to {}
	-- Convert to PDF
	set keep_duplicates to "Keep Duplicates"
	set keep_original to "Keep Original"
	set microsoftWordWasRunning to "false"
	
	set text item delimiters to " "
	set these_files to text items of (theQuery as string)
	set the_counter to count of these_files
	set text item delimiters to ""
	repeat with i from 1 to the_counter
		set cur_file to (POSIX file ((item i of these_files) as string)) as string
		set file_name to (remove_extension(cur_file) & ".pdf")
		file_name
		tell application "Microsoft Word"
			open cur_file
			tell application "Finder"
				if exists file file_name then
					if keep_duplicates is "Discard Duplicates" then
						delete file file_name
					else if keep_duplicates is "Keep Duplicates" then
						set file_name to (file_name & "(duplicate).pdf")
					end if
				end if
			end tell
			save as active document file format format PDF file name file_name
			close document 1 saving no
			if keep_original is "Discard Original" then
				tell application "Finder"
					delete cur_file
				end tell
			end if
		end tell
	end repeat
end run
on remove_extension(file_name)
	set theCharacters to characters of file_name
	set theReverse to reverse of theCharacters as string
	set extension_length to (offset of "." in theReverse) + 1
	set cut_file to (text 1 thru -extension_length) of file_name
end remove_extension