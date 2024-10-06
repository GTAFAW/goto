--发布频道@RLGG8
--By.  xgo
--作者:Yx     QQ:3379132619
--后门自删即可

local error = error
local enc = function(yx,door_hl)



    --local Pic = {""}
    local debr1 = {
        "(function() local s1 = function() return ",
        " end local s2=(function()return s1() end)() return s2 end)()"
    }
    local debr2 = {
        "(function() local s1,s2 goto ss ::ss1:: s2=(function()return s1() end)() goto ss2 ::ss:: s1 = function() return ",
        " end goto ss1 ::ss2:: return s2 end)()"
    }
    Let={}

function To__16(str)
return(str:gsub(".",function(x)
return(To_16(string.byte(x)))
end))
end
function RandomStr(len)
len=len or math.random(4,6)
    local str = ""
    str = string.char(math.random(65, 90))
    for num = 1, len - 1 do
        local number = math.random(1, 3)
        if number == 1 then
            str = str .. string.char(math.random(65, 90))
        elseif number == 2 then
            str = str .. string.char(math.random(97, 122))
        elseif number == 3 then
            str = str .. string.char(math.random(48, 57))
        end
    end
    return str
end

    Let.To_16 = function(txt)
        local sp = string.format("%x",txt)
        if #sp == 1 then
            sp = "0" .. sp
        end
        return "\\x" .. sp
    end--转16进制

    Let.Un_know = function(num)
        local zl = {}
        if not num then
            num = math.random(4, 6)
        end
        for x = 1, num do
            zl[#zl+1] = Let.To_16(math.random(127, 248))
        end
        return table.concat(zl)
    end--生成16进制字符

    Let.Ran_str = function(len)
        if not len then
            len = math.random(4, 6)
        end
        local res = ""
        for i = 1, len do
            local choice = math.random(1, 2)
            if choice == 1 then
                res = res .. string.char(math.random(65, 90))
              elseif choice == 2 then
                res = res .. string.char(math.random(97, 122))
            end
        end
        return res
    end

    Let.Ran_bit = function(num)
        local zl = {}
        if not num then
            num = math.random(3, 5)
        end
        for x = 1, num do
            zl[#zl+1] = "\\x" .. string.char(math.random(65, 70)) .. string.char(math.random(65, 70))
        end
        return table.concat(zl)
    end
    local value_var = math.random(130,140)
    local Enc_FuncVarName = function(txt)
        txt = {string.byte(txt,0,-1)}
        for i,k in pairs(txt) do
            txt[i] = "\\x"..string.format("%02x",k~value_var)
        end
        return table.concat(txt)
    end
    local debris = function(txt)
        if math.random(0,1) == 1 then
            return debr1[1]..txt..debr1[2]
          else
            return debr2[1]..txt..debr2[2]
        end
    end

    local txt_Tab_set={}
    local tab_txt={}
    local tab_txt2={}
    local tab_num = 0
    local tab_num2 = 0
    function Table_Rand(t)
        local tRet = {}
        local Total = #t
        while Total > 0 do
            local i = math.random(1,Total)
            table.insert(tRet,t[i])
            t[i] = t[Total]
            Total = Total-1
        end
        return tRet
    end--打乱table
    local tab_ran_16 = {}
    Let_know = function(num)
        local zl = {}
        if not num then
            num = math.random(4, 8)
        end
        for x = 1, num do
            zl[#zl+1] = "\\x"..string.format("%02x",math.random(130, 190))
        end
        zl = table.concat(zl)
        if tab_ran_16[zl] then
            Let_know()
        end
        tab_ran_16[zl] = true
        return zl
    end--生成破损字符
    any_byte = function(num)
        local zl = {}
        if not num then
            num = math.random(4, 6)
        end
        for x = 1, num do
            zl[#zl+1] = string.char(math.random(0, 255))
        end
        zl = table.concat(zl)
        if tab_ran_16[zl] then
            any_byte()
        end
        tab_ran_16[zl] = true
        return zl
    end--生成16进制字符
    local function line(yx)
        return yx:gsub("\n%s+","\n")
    end
    local Forbyte = function(UI)
        UI=UI.."\x00"
        local p0 = #UI
        local p1 = string.char(#UI%256)
        local q2 = #UI/256
        local p3, p5, p7, q4, q6
        p3 = string.char(q2%256)
        q4 = q2/256
        p5 = string.char(q4%256)
        q6 = q4/256
        p7 = string.char(q6%256)
        return {p1, p3, p5, p7}
    end
    local chunk_2,chunk_3={},{}
    local chunk_4=100001


  
    function WlCon(nr)--while写法
        local func_Name = Let.Ran_str()
        local Key = math.random(10000,999999)
        local Main_Key = Key
        for i,k in pairs(nr) do
            if i==#nr then
                nr[i]="if " .. func_Name .. "==" .. debris(Key) .. " then\n" .. nr[i] .. "\nbreak\nend\n"
              else
                nr[i]="if " .. func_Name.."==" .. debris(Key) .. " then\n" .. nr[i]
                Key = math.random(10000,999999)
                nr[i]=nr[i] .. "\n" .. func_Name .. "=" .. Key .. "\nend\n"
            end
        end
        return "local " .. func_Name .."=" .. Main_Key .. "\nwhile true do\n" .. table.concat(Table_Rand(nr)).."\nend"
    end
    local Key_1 = math.random(5,10)
    local Key_2 = Key_1 * math.random(10,100)
    local Key_3 = math.random(5,18)
    local Hwea = function(str)
        local i
        local a, b, c, d = 1, 2, 0, 11
        local l = string.len(str)
        local h = l
        local x = string.byte(str, h, l)
        local v = bit32.bxor(Key_1,Key_2)
        local step = (l >> Key_1) * Key_2 * h + a
        local step2 = ((x >> Key_1) * Key_2 * h + a) * (Key_1 + Key_2)
        for i = l,step,step-step2 do
            local k = string.byte(str, i, i)
            h = (Key_2 ^ b ~ bit32.bxor((v + x - (x >> k) * Key_2)~ (h * step2 % (Key_1 + Key_2)), ((i - v * v + ((x + k) >> (v * Key_1)) * (step2 % step)) ~ (k >> ((k - step2) % step))) ~ h) << (i ~ h)) + Key_3
        end
        local ll = string.len(h)
        if (d - ll) ~= c then
            h = h * d ^ ( d - ll)
        end
        h = (h * ll ~ (Key_1 ~ Key_2)) + Key_3 - v
        return (h ~ c^c)
    end
    function WlConGoto(nr)--goto写法
        local func_Name = Let.Ran_str()
        local Key = math.random(10000,999999)
        local Main_Key = Key
        local s=0
        for i,k in pairs(nr) do
            if i==#nr then
                nr[i]="::S" .. s .. "::\nif " .. func_Name .. "==" .. debris(Key) .. " then\n" .. nr[i] .. "\nend\ngoto S" .. (s + 1) .. "\n"
              else
                nr[i]="::S" .. s .. "::\nif " .. func_Name.."==" .. debris(Key) .. " then\n" .. nr[i]
                Key = math.random(10000,999999)
                nr[i]=nr[i] .. "\n" .. func_Name .. "=" .. Key .. "\nend\ngoto S" .. (s + 1) .. "\n"
                s=s+1
            end
        end
        return "local " .. func_Name .."=" .. Main_Key .. "\ngoto S0\n" .. table.concat(Table_Rand(nr)) .. "::S" .. (s + 1) .. "::"
    end
    NusRv = {}
    local cxk = {}
    
    

    
    local Min_num = function(...)

        local arm = {...}
        local num = nil

        for i, v in pairs(arm) do

            if v ~= nil then

                if not num then
                    num = v
                  elseif num > v then
                    num = v
                end

            end

        end

        return num
    end
    local metatable0 = {
        "__add",
        "__sub",
        "__mul",
        "__div",
        "__mod",
        "__concat",
        "__call",

    }
    local js_value1 = math.random(150,190)
    local decmetatable = [=====[

local js_value
local dec = function(tab1, tab2)
    local jg,jg2 = nil, {}
    if not tab2 then
        tab2 = {tab1[2]}
    end
    jg={string.byte(ARM:sub(tab1[1] - tab2[1], tab1[1]), 0, -1)}
    for i = 1, #jg do
        table.insert(jg2,Char[jg[i]~js_value])
    end
    return table.concat(jg2)
end
local metatable = {
    "__add",
    "__sub",
	"__mul",
	"__div",
	"__mod",
	"__concat",
	"__call",

}
local metaMethod={}
for i, k in pairs(metatable) do
    metaMethod[k] = dec
end

for i,k in pairs(tab_txt) do
if type(k[1]) == "string" then
    k[1] = utf8.codepoint(k[1])
end
tab_txt[i]=setmetatable(k,metaMethod)
end
(function()
js_value = "替换代用"
js_value = Char[js_value]
end)()

]=====]
    decmetatable = decmetatable:gsub("替换代用", string.char(js_value1), 1)
    local Deary = {}
    local tab_count = {}
    local num_count=0
    local ToStrong_Str = function(str)
        if str == "" then
            return "string.char()"
        end
        if Deary[str] then
            return Deary[str]
        end
        local dep = str
        str = {str:byte(0,-1)}
        local p1 = metatable0[math.random(1, #metatable0)]
        local brush = math.random(100,120)
        local txt_Tab_set3=any_byte(brush)
        local str1={}
        local Arith
        local Arith2=""
        if p1 == "__add" then
            Arith = "+"
          elseif p1 == "__sub" then
            Arith = "-"
          elseif p1 == "__mul" then
            Arith = "*"
          elseif p1 == "__div" then
            Arith = "/"
          elseif p1 == "__mod" then
            Arith = "%"
          elseif p1 == "__concat" then
            Arith = ".."
          elseif p1 == "__call" then
            Arith = "("
            Arith2 = ")"
        end
        for i,k in pairs(str) do
            str1[i] = string.char(k ~ js_value1)
        end
        str1 = table.concat(str1)
        local len_str=#str1
        txt_Tab_set3 = txt_Tab_set3 .. str1
        txt_Tab_set[#txt_Tab_set +1] = txt_Tab_set3
        num_count = num_count + #txt_Tab_set3
        tab_num = tab_num +1
        local str__ran = Let_know()
        local num_jg_pr = num_count
        if num_count <= 1114111 then
            num_jg_pr = "\""..utf8.char(num_count).."\""
        end
        tab_txt[tab_num] = "tab_txt[\""..str__ran.."\"] = {" .. num_jg_pr .. "}"
        str1 = "tab_txt[\"" .. str__ran .. "\"]"
        local str__ran = Let_know()
        if Arith then
            if tab_count[len_str-1] then
                str1 = str1 ..Arith.. tab_count[len_str-1]..Arith2
              else
                tab_num2 = tab_num2 +1
                tab_txt2[tab_num2] = "tab_txt2[\""..str__ran.."\"] = {"..(len_str-1).."}"
                tab_count[len_str-1] = "tab_txt2[\"" .. str__ran .. "\"]"
                str1 = str1 ..Arith..tab_count[len_str-1]..Arith2
            end
        end
        str1 = debris(str1)
        str1 = "("..str1..")"
        Deary[dep] = str1
        return Deary[dep]
    end
    fuc = {
    ["gg"] = 2,
    ["os"] = 2,
    ["io"] = 2,
    ["string"] = 2,
    ["math"] = 2,
    ["table"] = 2,
    ["debug"] = 2,
    ["bit32"] = 2,
    ["utf8"] = 2,
}
    local Fuc_Enc = function(ltre)
    gg.toast("正在加密标准库...")
    
	for v, s in pairs(_ENV) do
	
		if type(s) == "table" and fuc[v] then
		    Enc_func1 = ToStrong_Str(v)
		    
			for i in pairs(s) do
			
			    if ltre:find(v .. "%." .. i) then
			        Enc_func2 = ToStrong_Str(i)
			    	ltre = ltre:gsub("([^%w_])" .. v .. "%." .. i .. "%(",function(x)
			    	return x.."_ENV[" .. Enc_func1 .. "]" .. "[" .. Enc_func2 .. "]("
			    	end)
			    	ltre = ltre:gsub("([^%w_])" .. v .. "%." .. i .. "%)",function(x)
			    	return x.."_ENV[" .. Enc_func1 .. "]" .. "[" .. Enc_func2 .. "])"
			    	end)
			    	ltre = ltre:gsub("([^%w_])" .. v .. "%." .. i .. "%s*,",function(x)
			    	return x.."_ENV[" .. Enc_func1 .. "]" .. "[" .. Enc_func2 .. "],"
			    	end)
			    end
			    
			end
		
		    
		end
		
	end
	
	return ltre
end
    local Enc_Strings = function(DATA)
        local gr = {}

        repeat
            local s1, ss1, x1, xx1, n1, n2, str
            s1 = string.find(DATA, "\034")--单引号
            ss1 = string.find(DATA, "\039")--双引号
            x1 = string.find(DATA, "%[[=]*%[")--中括号
            xx1 = string.find(DATA, "%-%-")--注释

            str = Min_num(s1, ss1, x1, xx1)

            if str == nil then
                break
            end

            if str == s1 then
                DATA = DATA:gsub("(.-)(\034.-\034)",function(t1, t2)
                    gr[#gr + 1] = t1
                    t2 = string.gsub(t2, "\\\\","\\092")
                    t2 = string.gsub(t2, "\\\034", "\\034")

                    if t2:sub(-1, -1) ~= "\034" then
                        return t2
                    end
                    t3 = load("return "..t2)

                    if not t3 then
                        gg.alert("\034加密失败\n"..t2)
                        os.exit()
                    end
                    gr[#gr + 1] = ToStrong_Str(t3())
                    return ""
                end, 1)

              elseif str == ss1 then
                DATA = DATA:gsub("(.-)(\039.-\039)",function(t1, t2)
                    gr[#gr + 1] = t1
                    t2 = string.gsub(t2, "\\\\","\\092")
                    t2 = string.gsub(t2, "\\\039", "\\039")

                    if t2:sub(-1, -1) ~= "\039" then
                        return t2
                    end
                    t3 = load("return "..t2)

                    if not t3 then
                        gg.alert("\039加密失败\n"..t2)
                        os.exit()
                    end
                    gr[#gr + 1] = ToStrong_Str(t3())
                    return ""
                end, 1)

              elseif str == x1 then
                local g1 = string.match(DATA,"%[([=]*)%[")
                DATA=DATA:gsub("(.-)(%["..g1.."%[.-%]"..g1.."%])",function(t1, t2)
                    gr[#gr + 1] = t1
                    t3 = load("return "..t2)

                    if not t3 then
                        gg.alert("[[加密失败\n"..t2)
                        os.exit()
                    end
                    gr[#gr + 1] = ToStrong_Str(t3())
                    return ""
                end, 1)

              elseif str == xx1 then
                d1, d2, d3, d4 = string.find(DATA, "%-%-(%[([=]*)%[)")

                if d1 == xx1 then
                    DATA = string.gsub(DATA, "(.-)%-%-%[" .. d4 .. "%[.-%]" .. d4 .. "%]", function(txt1)
                        gr[#gr + 1] = txt1
                        return " "
                    end, 1)
                  else
                    DATA = string.gsub(DATA, "(.-)%-%-[^\n]*", function(txt1)
                        gr[#gr + 1] = txt1
                        return ""
                    end, 1)

                end
            
        elseif str == n1 then
            DATA = DATA:gsub("(.-[^%w_])(0[xX][0-9A-Fa-f]+)",function(txt1,txt2)
                gr[#gr + 1] = txt1
                gr[#gr + 1] = "TonumbEr("..ToStrong_Str(txt2)..")"
                return ""
            end,1)
            
        elseif str == n2 then
            local n3, n4, n5, n6
            n3 = string.find(DATA, "[^%w_]%d+%.%d+[eE][%-%+]%d+")
            n4 = string.find(DATA, "[^%w_]%d+%.%d+[eE]%d+")
            n5 = string.find(DATA, "[^%w_]%d+[eE]%d+")
            n6 = string.find(DATA, "[^%w_]%d+%.%d+")
            
            if str == n3 then
                DATA = DATA:gsub("(.-[^%w_])(%d+%.%d+[eE][%-%+]%d+)",function(txt1,txt2)
                    gr[#gr + 1] = txt1
                    gr[#gr + 1] = "TonumbEr("..ToStrong_Str(txt2)..")"
                    return ""
                end,1)
                
            elseif str == n4 then
                DATA = DATA:gsub("(.-[^%w_])(%d+%.%d+[eE]%d+)",function(txt1,txt2)
                    gr[#gr + 1] = txt1
                    gr[#gr + 1] = "TonumbEr("..ToStrong_Str(txt2)..")"
                    return ""
                end,1)
                
            elseif str == n5 then
                DATA = DATA:gsub("(.-[^%w_])(%d+[eE]%d+)",function(txt1,txt2)
                    gr[#gr + 1] = txt1
                    gr[#gr + 1] = "TonumbEr("..ToStrong_Str(txt2)..")"
                    return ""
                end,1)
                
            elseif str == n6 then
                DATA = DATA:gsub("(.-[^%w_])(%d+%.%d+)",function(txt1,txt2)
                    gr[#gr + 1] = txt1
                    gr[#gr + 1] = "TonumbEr("..ToStrong_Str(txt2)..")"
                    return ""
                end,1)
            else
                DATA = DATA:gsub("(.-[^%w_])(%d+)",function(txt1,txt2)
                    gr[#gr + 1] = txt1
                    gr[#gr + 1] = "TonumbEr("..ToStrong_Str(txt2)..")"
                    return ""
                end,1)
                
            end
            
        else
            break
        end

        until not str
        gr[#gr+1]=DATA
        gr = table.concat(gr):gsub("return%s+end","return 0\nend")
        gr=Fuc_Enc(gr)
        --    gr = Fuc_Enc(gr)
        return gr
    end
local value_var = math.random(130,140)
local Enc_FuncVarName = function(txt)
    txt = {txt:byte(0,-1)}
    for i,k in pairs(txt) do
        txt[i] = "\\x"..string.format("%02x",k~value_var)
    end
    return table.concat(txt)
end
    local Func_va = Let_know()
    local numb = 3369709924
    local function func_make(upval,index,key,u00)
        return [===[
	.func F]===]..numb..[===[ ; 2

	.source "=?"
	.linedefined 0
	.lastlinedefined 0
	.numparams 0
	.is_vararg 0
	.maxstacksize 2
	.upval ]===]..upval..[===[ nil

	.upval ]===]..u00..[===[ nil

	GETUPVAL v221 u1

	GETTABUP v0 u0 "]===]..index..[===["


	GETTABLE v0 v0 "]===]..key..[===["


	RETURN v0..v0
	.end ; F999
]===]
    end
    local Enc_FuncVar = function(yx)
        local start, fina
        yx=yx:gsub("(GETUPVAL )v%d+( u%d+)%s+LOADK v%d+ \"\\xFD\\xFE\"%s+CALL v%d+..v%d+","%1v221%2")
        fina=({string.find(yx,"LOADK v%d+ \"触发调用处\"")})[2]
        start=yx:sub(0,fina)
        local data=yx:sub(fina+1,-1)
        data = data:gsub("(maxstacksize %d+)(.-)(%s%.[ef][nu][dn][c ][; ])",function(max,str,final)
            local tab={}
            local u00 = str:match("GETUPVAL v221 (u%d+)")
            str=str:gsub("GETTABUP v%d+ (u%d+) \"([%w_]+)\"%s+GETTABLE (v%d+) v%d+ \"([%w_]+)\"",function(upval, index, p0, key)
                numb = numb +1
                tab[#tab+1]=func_make(upval,index,key,u00)
                return "CLOSURE "..p0.." F"..numb.."\nCALL "..p0..".."..p0.." "..p0..".."..p0
            end)
            return max..str..table.concat(tab,"\n")..final
        end)
	data = string.gsub(data, '%.maxstacksize %d+\n', '.maxstacksize 250\n')
        local arr = {'"[%w_]+"', '-?%d[%w%.]*'}
        local opNames = {
            ADD = true,
            SUB = true,
            MUL = true,
            DIV = true,
            MOD = true,
            POW = true,
            GETTABLE = true,
            SETTABLE = true,
            SELF = true,
            GETTABUP = true,
            SETTABUP = true,
            EQ = true,
            LT = true,
            LE = true
        }
        for i, const in pairs(arr) do
            local A1 = 210 + (i % 3)
            data = string.gsub(data, '(\n(\t*)(%u+) %w+ %w+ )(' .. const .. '\n)', function(p1, tab, name, p2)
                if not opNames[name] then return end
                return '\n' .. tab .. 'LOADK v' .. A1 .. ' ' .. p2 .. p1 .. 'v' .. A1 .. '\n'
            end)

            data = string.gsub(data, '(\n(\t*)(%u+) %w+ )(' .. const .. ')( %w+\n)', function(p1, tab, name, p2, p3)
                if not opNames[name] then return end
                return '\n' .. tab .. 'LOADK v' .. A1 .. ' ' .. p2 .. '\n' .. p1 .. 'v' .. A1 .. p3
            end)

            data = string.gsub(data, '(\n(\t*)(%u+) %w+ )(' .. const .. ')( ' .. const .. '\n)', function(p1, tab, name, p2, p3)
                if not opNames[name] then return end
                local A2 = A1 + 1
                return '\n' .. tab .. 'LOADK v' .. A1 .. ' ' .. p2 .. '\n\n' .. tab .. 'LOADK v' .. A2 .. ' ' .. p3 .. p1 .. 'v' .. A1 .. ' v' .. A2 .. '\n'
            end)
        end

        data = data:gsub("LOADK (v%d+) \"([%w_]+)\"",function(vb,i)
            local Max = 222
            local ran_set
            if math.random(0,1)==0 then
          ran_set = "1"
              else
                ran_set = "0\nLOADBOOL "..vb.." 1\nMOVE "..vb.." v"..Max
            end
            return "MOVE v"..Max.." v221\nLOADK v"..(Max + 1).." \""..Enc_FuncVarName(i).."\"\nCALL v"..Max.."..v"..(Max + 1).." v"..Max.."..v"..Max.."\nTESTSET "..vb.." v"..Max.." "..ran_set
        end)
        data = data:gsub("LOADK (v%d+) (-?%d[%w%.]*)\n",function(vb,i)
            local Max = 201
            local ran_set
            if math.random(0,1)==0 then
                ran_set = "1"
              else
                ran_set = "0\nLOADBOOL "..vb.." 1\nMOVE "..vb.." v"..Max
            end
            return "MOVE v"..Max.." v221\nLOADK v"..(Max + 1).." \""..Enc_FuncVarName(i).."\"\nLOADBOOL v"..(Max + 2).." 1\nCALL v"..Max.."..v"..(Max + 2).." v"..Max.."..v"..Max.."\nTESTSET "..vb.." v"..Max.." "..ran_set
        end)
        data = data:gsub("LOADK (v%d+) (\"\\x01\\x00\\x00\\x00\\x04\\x02\\x00\\x00\\x00%(%.%)\\x00\")",function(vb,i)
            i = load("return "..i)()
            local Max = 208
            return "MOVE v"..Max.." v221\nLOADK v"..(Max + 1).." \""..Enc_FuncVarName(i).."\"\nCALL v"..Max.."..v"..(Max + 1).." v"..Max.."..v"..Max.."\nTESTSET "..vb.." v"..Max.." 1"
        end, 1)
        



        
        local LNT = {
            BNOT = 13,
            UNM = 14,
            LEN = 15,
        }
        local calculate={
            ["ADD"]=1,
            ["SUB"]=2,
            ["MUL"]=3,
            ["DIV"]=4,
            ["POW"]=5,
            ["BXOR"]=6,
            ["BAND"]=7,
            ["BOR"]=8,
            ["MOD"]=9,
            ["IDIV"]=10,
            ["SHL"]=11,
            ["SHR"]=12
        }
        data=data:gsub("(%s)([ADSUBMLIVPOWXRNH]+) (%w+) ([%w%.]+) ([%w%.]+)",function(p0,p1,p2,p3,p4)
            if calculate[p1] then
                if tonumber(p3) then
                    p3 = "LOADK v224 "..p3
                  else
                    p3 = "MOVE v224 "..p3
                end
                if tonumber(p4) then
                    p4 = "LOADK v225 "..p4
                  else
                    p4 = "MOVE v225 "..p4
                end
                return p0.."MOVE v222 v221\nLOADK v223 "..calculate[p1].."\n"..p3.."\n"..p4.."\nCALL v222..v225 v222..v222\nMOVE "..p2.." v222"
            end
        end)
        data=data:gsub("(%s)([BNOTUMLE]+) ([%w%.]+) ([%w%.]+)",function(p0,p1,p2,p3)
            if tonumber(p3) then
                p3 = "LOADK v224 "..p3
              else
                p3 = "MOVE v224 "..p3
            end
            if LNT[p1] then
                return p0.."MOVE v222 v221\nLOADK v223 "..LNT[p1].."\n"..p3.."\nCALL v222..v224 v222..v222\nMOVE "..p2.." v222"
            end
        end)
        data=data:gsub("NEWTABLE (v%d+) %d+ %d+","MOVE v222 v221\nCALL v222..v222 v222..v222\nMOVE %1 v222")
        yx=start..data
        yx=yx:gsub("LOADK v%d+ \"触发调用处\"\n","",1)
        return yx
    end
    start_dec=[===[
local value_var
local tab_by = {}
local ar3="p"
local tab_by = {}
local asc_EA = "i"
local asc_E5 = "s"
local asc_E7 = "g"
local asc_EC = "n"
local ar1="("
local asc_E9 = "h"
local asc_EF = "a"
local asc_EB = "t"
local asc_E4 = "r"
local ar2=")"
local asc_E2 = "c"
local asc_E1 = "m"
local asc_E3 = "o"
local ar4 = "d"
local asc_E6 = "u"
local asc_E8 = "b"
local asc_EQ = "e"
local char = _ENV[asc_E5 .. asc_EB .. asc_E4 .. asc_EA .. asc_EC .. asc_E7][asc_E2 .. asc_E9 .. asc_EF .. asc_E4]
local gmtch = _ENV[asc_E5 .. asc_EB .. asc_E4 .. asc_EA .. asc_EC .. asc_E7][asc_E7 .. asc_E1 .. asc_EF .. asc_EB .. asc_E2 .. asc_E9]
local match = _ENV[asc_E5 .. asc_EB .. asc_E4 .. asc_EA .. asc_EC .. asc_E7][asc_E1 .. asc_EF .. asc_EB .. asc_E2 .. asc_E9]
local tonum = _ENV[asc_EB .. asc_E3 .. asc_EC .. asc_E6 .. asc_E1 .. asc_E8 .. asc_EQ .. asc_E4]
local dump_ = _ENV[asc_E5 .. asc_EB .. asc_E4 .. asc_EA .. asc_EC .. asc_E7][ar4 .. asc_E6 .. asc_E1 .. ar3]
local Char = {}
for i = 0, 255 do
    Char[i] = char(i)
    Char[char(i)] = i
end
local set_tab_ = {}


value_var = "替换代用"
value_var = Char[value_var]
local decrypt_Var = function(txt,free, free2)
    if txt == nil then
        return {}
    end
    if txt == 1 then
        return free+free2
    elseif txt == 2 then
        return free-free2
    elseif txt == 3 then
        return free*free2
    elseif txt == 4 then
        return free/free2
    elseif txt == 5 then
        return free^free2
    elseif txt == 6 then
        return free~free2
    elseif txt == 7 then
        return free&free2
    elseif txt == 8 then
        return free|free2
    elseif txt == 9 then
        return free%free2
    elseif txt == 10 then
        return free//free2
    elseif txt == 11 then
        return free<<free2
    elseif txt == 12 then
        return free>>free2
    elseif txt == 13 then
        return ~free
    elseif txt == 14 then
        return -free
    elseif txt == 15 then
        return #free
    elseif set_tab_[txt] then
        return set_tab_[txt]
    end
    local txt2 = ""
    for i in gmtch(txt, ".") do
        i = Char[i]
        txt2=txt2..Char[i~value_var]
    end
    if free then
        txt2=tonum(txt2)
    end
    set_tab_[txt] = txt2
    return set_tab_[txt]
end

]===]
UI=""
    start_dec=start_dec:gsub("替换代用","\\"..value_var,1)
local out_put=[[
    local pay="/sdcard/yx_dec_/1/2/2/3/enc.lua"
    if io.open(pay) then
    io.open(pay,"w"):write(ARM2)
    end
    ]]
    yx=Enc_Strings(out_put..yx)
    tab_txt2=WlCon(tab_txt2)
    tab_txt = WlConGoto(tab_txt)
    yx="local tab_txt2 = {}\n"..tab_txt2.."\nlocal tab_txt = {}\n"..tab_txt.."\nlocal Repace = \"触发调用处\"\ndecrypt_Var(\"\\xFD\\xFE\")\n" ..decmetatable.."\nreturn (function(...)\n".. yx .."\nend)()"
    yx=yx:gsub("([^%w]function[%w%s%._:]*%(.-%))",function(xx)
    return xx.."\ndecrypt_Var(\"\\xFD\\xFE\")\n".."\n"
    end)
    txt_Tab_set=table.concat(txt_Tab_set)
    local ran_jg=math.ceil(((1024^2*500)/#txt_Tab_set)/3)
    txt_Tab_set=txt_Tab_set:gsub(".",function(x)
    return "\\"..x:byte()
    end)
    local num_2=math.random(1000,2000)
    
    key_="\xE0\x81\xAD\xE0\x81\xAB\xE0\x81\xAD\xE0\x81\x93\xE0\x81\xA9\xE0\x81\x85\xE0\x81\x94\xE0\x81\xA1\xE0\x81\x82\xE0\x81\xA7\xE0\x81\x91\xE0\x81\xB9\xE0\x81\x81\xE0\x81\x8C\xE0\x81\x94\xE0\x81\xB0\xE0\x81\x91\xE0\x81\x93\xE0\x81\x96\xE0\x81\xB7\xE0\x81\xA8\xE0\x81\x98\xE0\x81\xA2\xE0\x81\x95\xE0\x81\x8F\xE0\x81\xAC\xE0\x81\xA1\xE0\x81\x90\xE0\x81\xB9\xE0\x81\x8B\xE0\x81\x91\xE0\x81\xB2\xE0\x81\x8E\xE0\x81\xA9\xE0\x81\xAB\xE0\x81\x87\xE0\x81\x97\xE0\x81\x84\xE0\x81\xB5\xE0\x81\x84\xE0\x81\x8C\xE0\x81\xAF\xE0\x81\xA4\xE0\x81\x8C\xE0\x81\x8C\xE0\x81\xB7\xE0\x81\xAA\xE0\x81\xB5\xE0\x81\xAA\xE0\x81\x82\xE0\x81\x8E\xE0\x81\x95\xE0\x81\xB8\xE0\x81\x8C\xE0\x81\xA7\xE0\x81\xAB\xE0\x81\x84\xE0\x81\x9A\xE0\x81\xA8\xE0\x81\x95\xE0\x81\x8F\xE0\x81\xA3\xE0\x81\xB5\xE0\x81\x8F\xE0\x81\x9A\xE0\x81\x98\xE0\x81\x94\xE0\x81\x92\xE0\x81\x83\xE0\x81\xAB\xE0\x81\x92\xE0\x81\xB5\xE0\x81\xA3\xE0\x81\x8A\xE0\x81\xAE\xE0\x81\x8D\xE0\x81\x8C\xE0\x81\xA3\xE0\x81\x8D\xE0\x81\x8D\xE0\x81\xB5\xE0\x81\x98\xE0\x81\xB1\xE0\x81\x96\xE0\x81\x8E\xE0\x81\x82\xE0\x81\xB9\xE0\x81\x87\xE0\x81\xB8\xE0\x81\x89\xE0\x81\xA8\xE0\x81\xAE\xE0\x81\x8F\xE0\x81\x95\xE0\x81\x86\xE0\x81\xAB\xE0\x81\x8D\xE0\x81\xA5\xE0\x81\xA1\xE0\x81\x8B\xE0\x81\xAD\xE0\x81\xA9\xE0\x81\x82\xE0\x81\xB6\xE0\x81\x93\xE0\x81\x9A\xE0\x81\xB8\xE0\x81\x8B\xE0\x81\xAA\xE0\x81\xA4\xE0\x81\x9A\xE0\x81\x8E\xE0\x81\xA1\xE0\x81\xB7\xE0\x81\xAA\xE0\x81\xA4\xE0\x81\x96\xE0\x81\xB0\xE0\x81\xAB\xE0\x81\xB1\xE0\x81\xB2\xE0\x81\x8D\xE0\x81\xAC\xE0\x81\xAC\xE0\x81\xBA\xE0\x81\x8C\xE0\x81\xB7\xE0\x81\xA7\xE0\x81\xAF\xE0\x81\xA3\xE0\x81\xAC\xE0\x81\x8A\xE0\x81\xA5\xE0\x81\x8D\xE0\x81\x82\xE0\x81\xAE\xE0\x81\x8D\xE0\x81\xA2\xE0\x81\xAE\xE0\x81\xBA\xE0\x81\xA3\xE0\x81\xA4\xE0\x81\xA5\xE0\x81\x85\xE0\x81\xB1\xE0\x81\xB1\xE0\x81\x8D\xE0\x81\xB7\xE0\x81\xB8\xE0\x81\xB6\xE0\x81\xA9\xE0\x81\x8A\xE0\x81\x96\xE0\x81\x84\xE0\x81\x96\xE0\x81\xB0\xE0\x81\xBA\xE0\x81\xAE\xE0\x81\x84\xE0\x81\xB5\xE0\x81\xB7\xE0\x81\xB2\xE0\x81\xAF\xE0\x81\x8B\xE0\x81\xB6\xE0\x81\xB2\xE0\x81\xB1\xE0\x81\x95\xE0\x81\xA1\xE0\x81\xAA\xE0\x81\xAC\xE0\x81\x97\xE0\x81\x82\xE0\x81\xAA\xE0\x81\x90\xE0\x81\xB0\xE0\x81\x8F\xE0\x81\xA6\xE0\x81\x96\xE0\x81\x8D\xE0\x81\xAD\xE0\x81\xAB\xE0\x81\x8D\xE0\x81\x8E\xE0\x81\x84\xE0\x81\xB0\xE0\x81\xA5\xE0\x81\xA6\xE0\x81\x91\xE0\x81\xBA\xE0\x81\xA1\xE0\x81\x83\xE0\x81\xB8\xE0\x81\x96\xE0\x81\xAE\xE0\x81\x83\xE0\x81\x89\xE0\x81\x8A\xE0\x81\x8B\xE0\x81\xA7\xE0\x81\x95\xE0\x81\x96\xE0\x81\x94\xE0\x81\xB2\xE0\x81\xB1\xE0\x81\xAE\xE0\x81\xA4\xE0\x81\x9A\xE0\x81\x88\xE0\x81\xB5\xE0\x81\xAA\xE0\x81\x8C\xE0\x81\xA6\xE0\x81\xB5\xE0\x81\xAA\xE0\x81\x89\xE0\x81\xB8\xE0\x81\x89\xE0\x81\x93\xE0\x81\xAA\xE0\x81\x9A\xE0\x81\x85\xE0\x81\xB9\xE0\x81\x92\xE0\x81\xB8\xE0\x81\x8A\xE0\x81\xB2\xE0\x81\x91\xE0\x81\x9A\xE0\x81\xA8\xE0\x81\xAA\xE0\x81\xA5\xE0\x81\x8C\xE0\x81\xAD\xE0\x81\xB5\xE0\x81\xB1\xE0\x81\x90\xE0\x81\x8E\xE0\x81\xA9\xE0\x81\x8B\xE0\x81\xAA\xE0\x81\x94\xE0\x81\x86\xE0\x81\x85\xE0\x81\x95\xE0\x81\x8C\xE0\x81\xB1\xE0\x81\x93\xE0\x81\xB7\xE0\x81\xA5\xE0\x81\x8C\xE0\x81\xA9\xE0\x81\x83\xE0\x81\xB6\xE0\x81\xA1\xE0\x81\xAD\xE0\x81\x8B\xE0\x81\x8D\xE0\x81\xAE\xE0\x81\xB3\xE0\x81\x93\xE0\x81\xB6\xE0\x81\x85\xE0\x81\x84\xE0\x81\xB5\xE0\x81\xB8\xE0\x81\xB4\xE0\x81\x85\xE0\x81\x89\xE0\x81\x8F\xE0\x81\xA7\xE0\x81\xB5\xE0\x81\x89\xE0\x81\xA2\xE0\x81\xA6\xE0\x81\x84\xE0\x81\x97\xE0\x81\x94\xE0\x81\x92\xE0\x81\xA8\xE0\x81\x84\xE0\x81\x87\xE0\x81\x99\xE0\x81\xA5\xE0\x81\x81\xE0\x81\x92\xE0\x81\x87\xE0\x81\xB8\xE0\x81\xA2\xE0\x81\x99\xE0\x81\x84\xE0\x81\xA5\xE0\x81\xA7\xE0\x81\x98\xE0\x81\x8E\xE0\x81\xAC\xE0\x81\xB4\xE0\x81\xB5\xE0\x81\x85\xE0\x81\xA3\xE0\x81\xB5\xE0\x81\x86\xE0\x81\x84\xE0\x81\x8E\xE0\x81\x8B\xE0\x81\xAF\xE0\x81\xA4\xE0\x81\x96\xE0\x81\xB3\xE0\x81\x85\xE0\x81\x8D\xE0\x81\x8C\xE0\x81\xA9\xE0\x81\xB3\xE0\x81\xAD\xE0\x81\x82\xE0\x81\xB1\xE0\x81\xA4\xE0\x81\xAA\xE0\x81\x8F\xE0\x81\x81\xE0\x81\xB2\xE0\x81\x89\xE0\x81\xA2\xE0\x81\x8A\xE0\x81\xB1\xE0\x81\xAA\xE0\x81\xB5\xE0\x81\xA7\xE0\x81\xA8\xE0\x81\x89\xE0\x81\xAD\xE0\x81\x81\xE0\x81\xB9\xE0\x81\xA8\xE0\x81\xA4\xE0\x81\xAA\xE0\x81\x8D\xE0\x81\xA7\xE0\x81\x8E\xE0\x81\xAD\xE0\x81\xAB\xE0\x81\x95\xE0\x81\xAA\xE0\x81\xA1\xE0\x81\x96\xE0\x81\xBA\xE0\x81\x94\xE0\x81\x89\xE0\x81\xA3\xE0\x81\x88\xE0\x81\xB5\xE0\x81\x93\xE0\x81\xAB\xE0\x81\xB7\xE0\x81\x83\xE0\x81\xAF\xE0\x81\x98\xE0\x81\x8D\xE0\x81\xB5\xE0\x81\x91\xE0\x81\xBA\xE0\x81\x81\xE0\x81\x90\xE0\x81\xA5\xE0\x81\x87\xE0\x81\x81\xE0\x81\xAB\xE0\x81\xB0\xE0\x81\x84\xE0\x81\x8F\xE0\x81\xA2\xE0\x81\xB3\xE0\x81\xB9\xE0\x81\xB3\xE0\x81\x8E\xE0\x81\xB9\xE0\x81\xAF\xE0\x81\xB8\xE0\x81\x93\xE0\x81\xB9\xE0\x81\x85\xE0\x81\x81\xE0\x81\xBA\xE0\x81\x91\xE0\x81\x81\xE0\x81\x8A\xE0\x81\xBA\xE0\x81\x8F\xE0\x81\x93\xE0\x81\xA5\xE0\x81\x94\xE0\x81\x85\xE0\x81\xAE\xE0\x81\xA7\xE0\x81\xA8\xE0\x81\x85\xE0\x81\xAE\xE0\x81\x8C\xE0\x81\xB4\xE0\x81\x90\xE0\x81\xA6\xE0\x81\x8F\xE0\x81\x94\xE0\x81\x83\xE0\x81\x87\xE0\x81\xAB\xE0\x81\xA1\xE0\x81\xA9\xE0\x81\xA4\xE0\x81\xB6\xE0\x81\x8D\xE0\x81\x86\xE0\x81\xB6\xE0\x81\x8A\xE0\x81\x89\xE0\x81\x8F\xE0\x81\x96\xE0\x81\xB6\xE0\x81\x83\xE0\x81\xB8\xE0\x81\x98\xE0\x81\x86\xE0\x81\xAA\xE0\x81\xAB\xE0\x81\x82\xE0\x81\xAF\xE0\x81\x83\xE0\x81\xA2\xE0\x81\xB2\xE0\x81\xAA\xE0\x81\x85\xE0\x81\x8E\xE0\x81\x87\xE0\x81\x9A\xE0\x81\xA4\xE0\x81\xA8\xE0\x81\x96\xE0\x81\xB7\xE0\x81\x9A\xE0\x81\x8B\xE0\x81\xAB\xE0\x81\x87\xE0\x81\x85\xE0\x81\x88\xE0\x81\x99\xE0\x81\xA6\xE0\x81\xA1\xE0\x81\x91\xE0\x81\xA4\xE0\x81\xA7\xE0\x81\xA7\xE0\x81\xBA\xE0\x81\xA6\xE0\x81\x98\xE0\x81\x8E\xE0\x81\x81\xE0\x81\xA5\xE0\x81\x82\xE0\x81\x87\xE0\x81\xAD\xE0\x81\x93\xE0\x81\xB5\xE0\x81\xAC\xE0\x81\xAA\xE0\x81\xAA\xE0\x81\x8D\xE0\x81\xA1\xE0\x81\x95\xE0\x81\xB9\xE0\x81\x9A\xE0\x81\x93\xE0\x81\xAE\xE0\x81\x83\xE0\x81\x8E\xE0\x81\xA2\xE0\x81\xAE\xE0\x81\xAB\xE0\x81\xB4\xE0\x81\x84\xE0\x81\xBA\xE0\x81\xA2\xE0\x81\xB9\xE0\x81\x8D\xE0\x81\x8C\xE0\x81\xB0\xE0\x81\x93\xE0\x81\x96\xE0\x81\xAC\xE0\x81\x99\xE0\x81\xB0\xE0\x81\xB2\xE0\x81\x8E\xE0\x81\xB9\xE0\x81\xA9\xE0\x81\xAC\xE0\x81\xB9\xE0\x81\xAD\xE0\x81\xB7\xE0\x81\xB0\xE0\x81\x98\xE0\x81\x82\xE0\x81\x83\xE0\x81\x8A\xE0\x81\xA2\xE0\x81\xA9\xE0\x81\xAE\xE0\x81\x88\xE0\x81\x87\xE0\x81\x8E\xE0\x81\xA1\xE0\x81\xAC\xE0\x81\xAD\xE0\x81\xAF\xE0\x81\xB7\xE0\x81\x8F\xE0\x81\x97\xE0\x81\xB4\xE0\x81\xB8\xE0\x81\x98\xE0\x81\xA9\xE0\x81\x96\xE0\x81\xA6\xE0\x81\x90\xE0\x81\xAC\xE0\x81\x96\xE0\x81\x83\xE0\x81\x90\xE0\x81\xA4\xE0\x81\xA3\xE0\x81\x8D\xE0\x81\xB9\xE0\x81\x90\xE0\x81\x8B\xE0\x81\xB6\xE0\x81\xAE\xE0\x81\x85\xE0\x81\x8D\xE0\x81\xA6\xE0\x81\x8B\xE0\x81\x92\xE0\x81\x8A\xE0\x81\x9A\xE0\x81\xA2\xE0\x81\xAC\xE0\x81\xB9\xE0\x81\xA1\xE0\x81\xAD\xE0\x81\xAD\xE0\x81\xAA\xE0\x81\x8D\xE0\x81\xB7\xE0\x81\x94\xE0\x81\x82\xE0\x81\x91\xE0\x81\x9A\xE0\x81\x91\xE0\x81\xB1\xE0\x81\xB5\xE0\x81\x8C\xE0\x81\xAF\xE0\x81\x88\xE0\x81\xA4\xE0\x81\x87\xE0\x81\xB9\xE0\x81\x8A\xE0\x81\x81\xE0\x81\xA5\xE0\x81\xA5\xE0\x81\x89\xE0\x81\x97\xE0\x81\x8C\xE0\x81\xB8\xE0\x81\xA2\xE0\x81\xAA\xE0\x81\xA9\xE0\x81\x85\xE0\x81\x98\xE0\x81\x96\xE0\x81\xAC\xE0\x81\xB0\xE0\x81\x81\xE0\x81\xA3\xE0\x81\xAA\xE0\x81\x81\xE0\x81\xB1\xE0\x81\xB4\xE0\x81\xA4\xE0\x81\x8D\xE0\x81\xA4\xE0\x81\x90\xE0\x81\x8B\xE0\x81\xB3\xE0\x81\x9A\xE0\x81\xB4\xE0\x81\xB3\xE0\x81\xA1\xE0\x81\xBA\xE0\x81\x93\xE0\x81\x8A\xE0\x81\x98\xE0\x81\xBA\xE0\x81\x83\xE0\x81\xA1\xE0\x81\x96\xE0\x81\x99\xE0\x81\x8B\xE0\x81\x95\xE0\x81\x85\xE0\x81\xB5\xE0\x81\xA6\xE0\x81\xAD\xE0\x81\xAD\xE0\x81\xB6\xE0\x81\x84\xE0\x81\x85\xE0\x81\xAD\xE0\x81\xB9\xE0\x81\x90\xE0\x81\x84\xE0\x81\x81\xE0\x81\xB6\xE0\x81\xAB\xE0\x81\x94\xE0\x81\x85\xE0\x81\xB5\xE0\x81\x87\xE0\x81\x89\xE0\x81\xA2\xE0\x81\xA6\xE0\x81\xA3\xE0\x81\x96\xE0\x81\x8A\xE0\x81\xA2\xE0\x81\x8B\xE0\x81\xB3\xE0\x81\x8B\xE0\x81\x8B\xE0\x81\x92\xE0\x81\x90\xE0\x81\xB2\xE0\x81\xA3\xE0\x81\x8F\xE0\x81\xAC\xE0\x81\x93\xE0\x81\xA3\xE0\x81\x84\xE0\x81\x90\xE0\x81\x91\xE0\x81\xB7\xE0\x81\x96\xE0\x81\xA3\xE0\x81\xB0\xE0\x81\x8F\xE0\x81\x96\xE0\x81\xA5\xE0\x81\x84\xE0\x81\x91\xE0\x81\x90\xE0\x81\xA1\xE0\x81\xAE\xE0\x81\x8B\xE0\x81\x83\xE0\x81\xA2\xE0\x81\x90\xE0\x81\xA9\xE0\x81\xA5\xE0\x81\x91\xE0\x81\x8F\xE0\x81\x90\xE0\x81\x95\xE0\x81\xAC\xE0\x81\x8D\xE0\x81\xB6\xE0\x81\x97\xE0\x81\xA1\xE0\x81\x84\xE0\x81\x89\xE0\x81\xB3\xE0\x81\xB0\xE0\x81\xAD\xE0\x81\x99\xE0\x81\x90\xE0\x81\xAA\xE0\x81\x8A\xE0\x81\x89\xE0\x81\xA1\xE0\x81\xA6\xE0\x81\x85\xE0\x81\xB8\xE0\x81\x8A\xE0\x81\xB2\xE0\x81\xA7\xE0\x81\x93\xE0\x81\x81\xE0\x81\xA7\xE0\x81\xAC\xE0\x81\x91\xE0\x81\x93\xE0\x81\xB9\xE0\x81\x94\xE0\x81\x87\xE0\x81\x98\xE0\x81\x8F\xE0\x81\x85\xE0\x81\xB8\xE0\x81\x96\xE0\x81\xA5\xE0\x81\xA2\xE0\x81\xB4\xE0\x81\xAB\xE0\x81\x9A\xE0\x81\x8A\xE0\x81\xAD\xE0\x81\x87\xE0\x81\x85\xE0\x81\xA5\xE0\x81\xA3\xE0\x81\x99\xE0\x81\xB1\xE0\x81\xAB\xE0\x81\x85\xE0\x81\x87\xE0\x81\x8E\xE0\x81\x8E\xE0\x81\x8A\xE0\x81\xA2\xE0\x81\xB2\xE0\x81\xA3\xE0\x81\x98\xE0\x81\x90\xE0\x81\x83\xE0\x81\x95\xE0\x81\xB6\xE0\x81\x8C\xE0\x81\xAB\xE0\x81\x99\xE0\x81\x86\xE0\x81\x8E\xE0\x81\x85\xE0\x81\x9A\xE0\x81\xA4\xE0\x81\x82\xE0\x81\xB2\xE0\x81\xB2\xE0\x81\x8C\xE0\x81\xA4\xE0\x81\xAB\xE0\x81\x81\xE0\x81\x98\xE0\x81\x83\xE0\x81\x99\xE0\x81\x82\xE0\x81\xB0\xE0\x81\x85\xE0\x81\xA9\xE0\x81\xAD\xE0\x81\xB9\xE0\x81\xA5\xE0\x81\x8A\xE0\x81\x90\xE0\x81\x86\xE0\x81\x89\xE0\x81\x92\xE0\x81\xB0\xE0\x81\xBA\xE0\x81\xB6\xE0\x81\xB0\xE0\x81\x8E\xE0\x81\xA7\xE0\x81\xB8\xE0\x81\xAB\xE0\x81\x8B\xE0\x81\x88\xE0\x81\x8F\xE0\x81\xA6\xE0\x81\x87\xE0\x81\xA1\xE0\x81\x95\xE0\x81\xB0\xE0\x81\xB4\xE0\x81\xA7\xE0\x81\x81\xE0\x81\x91\xE0\x81\xB5\xE0\x81\x8A\xE0\x81\x8F\xE0\x81\x97\xE0\x81\xB3\xE0\x81\x86\xE0\x81\xAC\xE0\x81\x89\xE0\x81\x87\xE0\x81\xB4\xE0\x81\xB4\xE0\x81\xA1\xE0\x81\xB2\xE0\x81\xB8\xE0\x81\xB2\xE0\x81\x85\xE0\x81\xB1\xE0\x81\x99\xE0\x81\x9A\xE0\x81\x8C\xE0\x81\xA6\xE0\x81\xA7\xE0\x81\x84\xE0\x81\xA5\xE0\x81\xA8\xE0\x81\x94\xE0\x81\x90\xE0\x81\x96\xE0\x81\x98\xE0\x81\xBA\xE0\x81\x87\xE0\x81\xB1\xE0\x81\x88\xE0\x81\xA1\xE0\x81\x8E\xE0\x81\xAE\xE0\x81\xA4\xE0\x81\x8C\xE0\x81\x95\xE0\x81\xB1\xE0\x81\x86\xE0\x81\xA6\xE0\x81\x87\xE0\x81\x8E\xE0\x81\xB8\xE0\x81\xA8\xE0\x81\x81\xE0\x81\x8F\xE0\x81\x95\xE0\x81\xA6\xE0\x81\xAC\xE0\x81\xAA\xE0\x81\x96\xE0\x81\x97\xE0\x81\xA8\xE0\x81\xA6\xE0\x81\xAC\xE0\x81\xA1\xE0\x81\x84\xE0\x81\xA3\xE0\x81\x9A\xE0\x81\xB7\xE0\x81\xAB\xE0\x81\xA2\xE0\x81\xB8\xE0\x81\x93\xE0\x81\x98\xE0\x81\x88\xE0\x81\xAA\xE0\x81\xB1\xE0\x81\x85\xE0\x81\x83\xE0\x81\x89\xE0\x81\x95\xE0\x81\xB7\xE0\x81\x8B\xE0\x81\x90\xE0\x81\x94\xE0\x81\xAB\xE0\x81\x8A\xE0\x81\x92\xE0\x81\xB7\xE0\x81\xA9\xE0\x81\x8F\xE0\x81\xB6\xE0\x81\x94\xE0\x81\xB1\xE0\x81\x8F\xE0\x81\xA7\xE0\x81\x89\xE0\x81\xB1\xE0\x81\xB3\xE0\x81\xA6\xE0\x81\x84\xE0\x81\xB6\xE0\x81\xA9\xE0\x81\x83\xE0\x81\x86\xE0\x81\x8F\xE0\x81\xB8\xE0\x81\xA9\xE0\x81\xB0\xE0\x81\x85\xE0\x81\xA3\xE0\x81\x91\xE0\x81\xB6\xE0\x81\xAD\xE0\x81\xA9\xE0\x81\xA8\xE0\x81\xB7\xE0\x81\x8E\xE0\x81\xAE\xE0\x81\x98\xE0\x81\xB3\xE0\x81\xAE\xE0\x81\x88\xE0\x81\x83\xE0\x81\xAD\xE0\x81\xB3\xE0\x81\x91\xE0\x81\xA3\xE0\x81\xAF\xE0\x81\x94\xE0\x81\xA6\xE0\x81\x8A\xE0\x81\x9A\xE0\x81\xB1\xE0\x81\x90\xE0\x81\x91\xE0\x81\xB8\xE0\x81\x86\xE0\x81\xB8\xE0\x81\x8D\xE0\x81\x8A\xE0\x81\x99\xE0\x81\xA4\xE0\x81\xA3\xE0\x81\x95\xE0\x81\xAB\xE0\x81\xBA\xE0\x81\x8D\xE0\x81\x90\xE0\x81\x97\xE0\x81\xA2\xE0\x81\x86\xE0\x81\xB4\xE0\x81\x85\xE0\x81\x98\xE0\x81\x89\xE0\x81\xAB\xE0\x81\xB6\xE0\x81\x8C\xE0\x81\xA3\xE0\x81\x93\xE0\x81\xA6\xE0\x81\x99\xE0\x81\xA3\xE0\x81\xB0\xE0\x81\x93\xE0\x81\x83\xE0\x81\xA1\xE0\x81\x91\xE0\x81\xB0\xE0\x81\xB3\xE0\x81\xAA\xE0\x81\x90\xE0\x81\xB7\xE0\x81\xA3\xE0\x81\x81\xE0\x81\x94\xE0\x81\xB6\xE0\x81\x91\xE0\x81\xB1\xE0\x81\xA7\xE0\x81\x91\xE0\x81\xB9\xE0\x81\x99\xE0\x81\xA8\xE0\x81\x8B\xE0\x81\xAB\xE0\x81\x8C\xE0\x81\x90\xE0\x81\x92\xE0\x81\xB4\xE0\x81\x8A\xE0\x81\xA6\xE0\x81\xBA\xE0\x81\xB6\xE0\x81\xAE\xE0\x81\x94\xE0\x81\x9A\xE0\x81\x8C\xE0\x81\xAC\xE0\x81\x8E\xE0\x81\x8D\xE0\x81\x91\xE0\x81\xAD\xE0\x81\x99\xE0\x81\x96\xE0\x81\xA8\xE0\x81\x92\xE0\x81\x92\xE0\x81\xB8\xE0\x81\xB1\xE0\x81\xB4\xE0\x81\xA6\xE0\x81\x83\xE0\x81\x83\xE0\x81\x83\xE0\x81\x84\xE0\x81\xA7\xE0\x81\xA3\xE0\x81\x97\xE0\x81\x96\xE0\x81\x89\xE0\x81\xB4\xE0\x81\xB0\xE0\x81\xB8\xE0\x81\xAF\xE0\x81\xAF\xE0\x81\x8B\xE0\x81\x85\xE0\x81\x8A\xE0\x81\x94\xE0\x81\x91\xE0\x81\x99\xE0\x81\xAF\xE0\x81\xAA\xE0\x81\x82\xE0\x81\xBA\xE0\x81\xAD\xE0\x81\xA3\xE0\x81\xAD\xE0\x81\x86\xE0\x81\xA3\xE0\x81\x97\xE0\x81\x9A\xE0\x81\xAC\xE0\x81\xA3\xE0\x81\x86"
key_={key_:byte(0,-1)}
door_hl={door_hl:byte(0,-1)}
local n=1
for a,b in pairs(door_hl) do
door_hl[a]=string.char(b~key_[n])
if n==#key_ then
n=1
else
n=n+1
end
end
door_hl = table.concat(door_hl)
    yx = start_dec.."local ARM,ARM2\nARM2=[====["..any_byte(num_2).."\x71\x61\x54\x00䶣\xaa"..door_hl.."\x71\x61\x54\x00靌\xaa"..any_byte(num_2).."]====]\nARM=\""..txt_Tab_set.."\"\nwhile ARM==\"\" do\nlocal asm=\"我会被替换掉的\"\ngoto CNMNMSL\n::FLZD::\n"..("ARM=[===[替换专用，我真的服了啊]===]\n"):rep(ran_jg).."\n::CNMNMSL::\nif not nil then\ngoto FLZD\nend\nend\nreturn (function()\n"..yx.."\nend)()"
    yx="return (function()"..yx.." end)([===["..UI.."]===])"

   -- yc=yx:gsub("替换专用，我真的服了啊",function(x)return txt_Tab_set end)
   -- io.open("jmp.lua","w"):write(yx)
    --os.exit()

    return yx
end

yx=gg.prompt({"选择脚本"},{"/storage/emulated/0/"},{"file","checkbox","checkbox"})
if yx==nil then os.exit(print("未选择"))end
last=yx[1]
test,error=loadfile(last)
if test==nil then
    gg.alert('脚本错误!\n\n╾╾╾╾╾⚠ 问 题 所 在 ️⚠╾╾╾╾╾\n错误:\n'..error)
    os.exit(print("结束"))
end
ym=io.open(yx[1],"r"):read("*a")

last = yx[1]..".𝙀𝙣𝙘.lua"
ym=enc(ym,ym)
io.open(last,"w"):write(ym)
print("加密成功.记得使用免费加密重新加密一次")
gg.setVisible(true)
