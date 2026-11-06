-- Map fenced divs to LaTeX environments for callout boxes
local envs = {
  principle = true,
  howto = true,
  aside = true,
  warning = true,
}

function Div(el)
  for cls, _ in pairs(envs) do
    if el.classes:includes(cls) then
      return {
        pandoc.RawBlock('latex', '\\begin{' .. cls .. '}'),
        el,
        pandoc.RawBlock('latex', '\\end{' .. cls .. '}'),
      }
    end
  end
end
