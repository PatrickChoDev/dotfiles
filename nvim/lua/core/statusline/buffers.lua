local M = {}

local function blend_channel(fg, bg, alpha)
  return math.floor((alpha * fg) + ((1 - alpha) * bg) + 0.5)
end

local function unpack_rgb(color)
  color = color or 0
  local r = math.floor(color / 0x10000)
  local g = math.floor(color / 0x100) % 0x100
  local b = color % 0x100
  return r, g, b
end

local function blend_colors(fg, bg, alpha)
  local fg_r, fg_g, fg_b = unpack_rgb(fg)
  local bg_r, bg_g, bg_b = unpack_rgb(bg)

  local r = blend_channel(fg_r, bg_r, alpha)
  local g = blend_channel(fg_g, bg_g, alpha)
  local b = blend_channel(fg_b, bg_b, alpha)

  return r * 0x10000 + g * 0x100 + b
end

local function get_buffer_name(buf)
  local name = vim.api.nvim_buf_get_name(buf)
  if name == '' then
    return '[No Name]'
  end

  local ok, relativized = pcall(vim.fn.fnamemodify, name, ':~:.')
  if ok and relativized ~= '' then
    return relativized
  end

  return vim.fn.fnamemodify(name, ':t')
end

local function build_segments()
  local buffers = vim.fn.getbufinfo { buflisted = 1 }
  if vim.tbl_isempty(buffers) then
    return {}, nil
  end

  local current = vim.api.nvim_get_current_buf()
  local segments = {}
  local current_index = 1

  for idx, buf in ipairs(buffers) do
    local name = get_buffer_name(buf.bufnr)
    if buf.changed == 1 then
      name = name .. ' ●'
    end

    local text = ' ' .. name .. ' '
    local highlight = buf.bufnr == current and 'LualineBuffersCurrent' or 'LualineBuffersInactive'
    local length = vim.fn.strdisplaywidth(text)

    segments[idx] = {
      text = text,
      length = length,
      highlight = highlight,
    }

    if buf.bufnr == current then
      current_index = idx
    end
  end

  return segments, current_index
end

local function render_buffers()
  local segments, current_index = build_segments()
  if not current_index then
    return ''
  end

  local current_segment = segments[current_index]
  if not current_segment then
    return ''
  end

  local available = math.max(20, vim.fn.winwidth(0) - 12)
  local display_segments = { current_segment }
  local used = current_segment.length
  local left_hidden = false
  local right_hidden = false

  local offset = 1
  while true do
    local added = false
    local left = segments[current_index - offset]
    if left then
      if used + left.length <= available then
        table.insert(display_segments, 1, left)
        used = used + left.length
        added = true
      else
        left_hidden = true
      end
    end

    local right = segments[current_index + offset]
    if right then
      if used + right.length <= available then
        table.insert(display_segments, right)
        used = used + right.length
        added = true
      else
        right_hidden = true
      end
    end

    if not added then
      break
    end

    offset = offset + 1
  end

  local parts = {}
  if left_hidden then
    table.insert(parts, '%#LualineBuffersFade#<<%*')
  end

  for _, segment in ipairs(display_segments) do
    table.insert(parts, string.format('%%#%s#%s%%*', segment.highlight, segment.text))
  end

  if right_hidden then
    table.insert(parts, '%#LualineBuffersFade#>>%*')
  end

  return table.concat(parts)
end

local function update_highlights()
  local ok_normal, normal = pcall(vim.api.nvim_get_hl, 0, { name = 'lualine_c_normal', link = false })
  local ok_inactive, inactive = pcall(vim.api.nvim_get_hl, 0, { name = 'lualine_c_inactive', link = false })

  if not ok_normal then
    return
  end

  local bg = normal.bg or 0
  local fg = normal.fg or 0xffffff
  local inactive_fg = (ok_inactive and inactive and inactive.fg) or blend_colors(fg, bg, 0.6)
  local fade_fg = blend_colors(inactive_fg, bg, 0.35)

  vim.api.nvim_set_hl(0, 'LualineBuffersCurrent', {
    fg = fg,
    bg = bg,
    bold = true,
  })

  vim.api.nvim_set_hl(0, 'LualineBuffersInactive', {
    fg = inactive_fg,
    bg = bg,
  })

  vim.api.nvim_set_hl(0, 'LualineBuffersFade', {
    fg = fade_fg,
    bg = bg,
  })
end

function M.component()
  return render_buffers
end

function M.setup()
  local group = vim.api.nvim_create_augroup('CoreStatuslineBuffers', { clear = true })
  vim.api.nvim_create_autocmd({ 'ColorScheme', 'VimEnter' }, {
    group = group,
    callback = update_highlights,
  })

  update_highlights()
end

return M
