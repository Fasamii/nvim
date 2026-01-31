require("blink.cmp").setup({
	appearance = {
		use_nvim_cmp_as_default = true,
		nerd_font_variant = "mono",
	},

	fuzzy = {
		implementation = "prefer_rust_with_warning",
	},

	sources = {
		default = { "lsp", "path", "buffer" },
		providers = {
			lsp = {
				name = "LSP",
				module = "blink.cmp.sources.lsp"
			},
			path = {
				name = "Path",
				module = "blink.cmp.sources.path"
			},
			buffer = {
				name = "Buffer",
				module = "blink.cmp.sources.buffer"
			}
		},
	},

	completion = {
		accept = {
			auto_brackets = {
				enabled = true
			}
		},
		menu = {
			draw = {
				columns = {
					{ "kind_icon" }, { "label", "label_description", gap = 1 }
				},

				components = {
					kind_icon = {
						text = function(ctx)
							local icon = ctx.kind_icon
							if vim.tbl_contains({ "Path" }, ctx.source_name) then
								local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
								if dev_icon then
									icon = dev_icon
								end
							end

							return icon .. ctx.icon_gap
						end,

						-- Optionally, use the highlight groups from nvim-web-devicons
						-- You can also add the same function for `kind.highlight` if you want to
						-- keep the highlight groups in sync with the icons.
						highlight = function(ctx)
							local hl = ctx.kind_hl
							if vim.tbl_contains({ "Path" }, ctx.source_name) then
								local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
								if dev_icon then
									hl = dev_hl
								end
							end
							return hl
						end,
					}
				}
			},

			border = "solid",
		},

		documentation = {
			auto_show = true,
			auto_show_delay_ms = 0,
			window = {
				border = "solid"
			}
		},

		signature = {
			enabled = true,
			-- TODO: Check that
			-- window = {
			-- 	border = "solid",
			-- }
		},

		keyword = {
			range = "full"
		},
	},

});
