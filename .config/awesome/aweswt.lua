-- aweswt.lua
local io=io
local table=table
local pairs=pairs
local awful=awful
local client=client
local string=string
module("aweswt")
function get_out (a)
    local  f=io.popen (a)
    t={}
    for line in f:lines() do
      table.insert(t, line ) 
    end
    return t
end
function get_input (a)
  s1='echo -n \"'..a..'\"|dmenu -nb \"black\" -nf \"grey\" -fn \"-*-terminal-*-*-*-*-14-*-*-*-*-*-*-*\"'
  return get_out(s1)
end

function switch()
   local clients = client.get()
   if table.getn(clients) == 0 then 
     return
   end
   local m1=''
   local t2={}
   local tmp
   for i, c in pairs(clients) do
      --tmp=i..':'..c['instance']..'.'..c['class']
      tmp=i..':'..c['class']..':'..c['name']
      m1=m1..tmp..'\n'
      t2[tmp]=c
   end
   local t6=t2[get_input(m1)[1]]
   if t6 then
      local ctags = t6:tags()
      awful.tag.viewonly(ctags[1])
      client.focus = t6
      t6:raise()
   end
end
