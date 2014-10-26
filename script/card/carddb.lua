require "script.base"
require "script.card"
require "script.logger"

ccarddb = class("ccarddb",cdatabaseable)

function ccarddb:init(conf)
	cdatabaseable.init(self,conf)
	self.data = {}
	self.id_card = {}
	self.sid_cards = {}
end

function ccarddb:save()
	local data = {}
	data.data = self.data
	local d1 = {}
	for sid,cards in pairs(self.sid_cards) do
		local d2 = {}
		d1[tostring(sid)] = d2
		for _,card in ipairs(cards) do
			table.insert(d2,card:save())
		end
	end
	data.sid_cards = d1
	return data
end

function ccarddb:load(data)
	if not data or not next(data) then
		return
	end
	self.data = data.data
	for sid,cards_data in pairs(data.sid_cards) do
		sid = tonumber(sid)
		for _,v in ipairs(cards_data) do
			local card = ccard.create(self.pid,sid)
			card:load(v)
			self:addcard(card)
		end
	end
end

function ccarddb:clear()
	logger.log("info","card",string.format("#%d clear card(flag=%s)",self.pid,self.__flag))
	self.data = {}
	self.id_card = {}
	self.sid_cards = {}
end

function ccarddb:addcard(card)
	self:check_sid_cards(card.sid)
	local cardid = card.cardid
	assert(self.id_card[cardid] == nil,"repeat cardid:" .. tostring(cardid))
	logger.log("info","card",string.format("%d addcard,cardid=%d sid=%d amount=%d",self.pid,cardid,card.sid,card:getamount()))
	self.id_card[cardid] = card
	table.insert(self.sid_cards[card.sid],card)
	self:afteraddcard(card)
end

function ccarddb:delcard(card)
	local cardid = card.cardid
	assert(self.id_card[cardid],"not exists cardid:" .. tostring(cardid))
	logger.log("info","card",string.format("%d delcard,cardid=%d sid=%d amount=%d",self.pid,cardid,card.sid,card:getamount()))
	self.id_card[cardid] = nil
	local cards = self.sid_cards[card.sid]
	for k,v in ipairs(cards) do
		if v.cardid == cardid then
			table.remove(cards,k)
			break
		end
	end
	self:afterdelcard(card)
end

function ccarddb:afteraddcard(card)
end

function ccarddb:afterdelcard(card)
end

function ccarddb:check_sid_cards(sid)
	if not self.sid_cards[sid] then
		self.sid_cards[sid] = {}
	end
end

function ccarddb:addcardbysid(sid,amount)
	self:check_sid_cards(sid)
	-- merge
	local cardcls = ccard.getclassbysid(sid)	
	local max_amount = cardcls.max_amount
	for _,card in ipairs(self.sid_cards[sid]) do
		local num  = card:getamount()
		if num < max_amount then
			local addamount = math.min(amount,max_amount-num)
			amount = amount - addamount
			card:setamount(num+addamount)
			if amount <= 0 then
				break
			end
		end
	end
	local cnt = math.floor(amount / max_amount)
	local leftamount = amount - max_amount * cnt
	local card
	for i=1,cnt do
		card = ccard.create(self.pid,sid,max_amount)
		self:addcard(card)
	end
	if leftamount > 0 then
		card = ccard.create(self.pid,sid,leftamount)
		self:addcard(card)
	end
end

function ccarddb:getamountbysid(sid)
	self:check_sid_cards(sid)
	local amount = 0
	for _,card in ipairs(self.sid_cards[sid]) do
		amount = amount + card:getamount()
	end
	return amount
end

function ccarddb:delcardbysid(sid,amount)
	self:check_sid_cards(sid)
	local cards = self.sid_cards[sid]
	local delcards = {}
	for _,card in ipairs(cards) do
		table.insert(delcards,card)
		amount = amount - card:getamount()
		if amount <= 0 then
			break
		end
	end
	for _,card in ipairs(delcards) do
		self:delcard(card)
	end
end

function ccarddb:usecard(cardid)
end
