-- worklog.lua - Daily worklog picker for payrix (like :Obsidian dailies)

vim.api.nvim_create_user_command("Worklog", function(opts)
	local worklog_dir = vim.fn.expand("~/code/personal/zk/payrix/worklog")
	vim.fn.mkdir(worklog_dir, "p")

	local offset_start = -14
	local offset_end = 0

	if opts.fargs and #opts.fargs > 0 then
		if #opts.fargs == 1 then
			local n = tonumber(opts.fargs[1])
			if n and n >= 0 then
				offset_end = n
			elseif n then
				offset_start = n
			end
		elseif #opts.fargs == 2 then
			local a, b = tonumber(opts.fargs[1]), tonumber(opts.fargs[2])
			if a and b then
				offset_start, offset_end = math.min(a, b), math.max(a, b)
			end
		end
	end

	local entries = {}
	for offset = offset_end, offset_start, -1 do
		local time = os.time() + (offset * 86400)
		local date_str = os.date("%Y-%m-%d", time)
		local display = os.date("%A %B %d, %Y", time)
		local filepath = worklog_dir .. "/" .. date_str .. ".md"

		if offset == 0 then
			display = display .. " @today"
		elseif offset == -1 then
			display = display .. " @yesterday"
		elseif offset == 1 then
			display = display .. " @tomorrow"
		end

		if vim.fn.filereadable(filepath) ~= 1 then
			display = display .. " ➡️ create"
		end

		entries[#entries + 1] = {
			display = display,
			date = date_str,
			filepath = filepath,
		}
	end

	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	pickers
		.new({}, {
			prompt_title = "Worklog",
			finder = finders.new_table({
				results = entries,
				entry_maker = function(entry)
					return {
						value = entry,
						display = entry.display,
						ordinal = entry.date .. " " .. entry.display,
						filename = entry.filepath,
					}
				end,
			}),
			sorter = conf.generic_sorter({}),
			previewer = conf.file_previewer({}),
			attach_mappings = function(prompt_bufnr)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					if not selection then
						return
					end

					local entry = selection.value
					if vim.fn.filereadable(entry.filepath) ~= 1 then
						local timestamp = os.date("%a %b %d %H:%M")
						local template = "# Worklog "
							.. entry.date
							.. "\n#worklog #payrix\n\n## "
							.. timestamp
							.. "\n\n"
						local f = io.open(entry.filepath, "w")
						if f then
							f:write(template)
							f:close()
						end
					end

					vim.cmd("edit " .. vim.fn.fnameescape(entry.filepath))
				end)
				return true
			end,
		})
		:find()
end, { nargs = "*" })
