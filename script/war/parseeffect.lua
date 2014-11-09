-- warcry
function addhp(warcardid,targets,args)
	local value = args
	for _,target in ipairs(targets) do
		target:addhp(value)
	end
end

function freeze(warcardid,targets,args)
	local roundcnt = args
	for _,target in ipairs(targets) do
		target:setstate("freeze",roundcnt)
	end
end

function changeto(warcardid,targets,args)
	local cardsid = args
	for _,target in ipairs(targets) do
		-- destroy target
		-- add a cardsid footman
	end
end

local global_buf_type = {
	self_all_hand_secret_card = "all_hand_secret_hand",

}
function addbuf(warcardid,targets,args)
	local k = global_buf_type[targets]
	if k then
		--xxx
	else
		for _,target in ipairs(targets) do
			target:addbuf(warcardid,args)
		end
	end
end
