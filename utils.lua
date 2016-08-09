function Timer0(self, field, dt)
	if self[field] > 0 then
		self[field] = clamp0(self[field] - dt)
	end

	return self[field] == 0
end

function IncWrap(v, lo, hi)
	v = v + 1
	if v > hi then return lo
	else return v end
end

function RectsOverlap(x1,y1,w1,h1, x2,y2,w2,h2)
	return x1 < x2+w2 and x2 < x1+w1 and y1 < y2+h2 and y2 < y1+h1
end

function clamp(v, lo, hi)
	if v < lo then return lo
	elseif v > hi then return hi
	else return v end
end

function clamp0(v)
	if v < 0 then return 0
	else return v end
end

function clampHi(v, hi)
	if v > hi then return hi
	else return v end
end

function clampLo(v, lo)
	if v < lo then return lo
	else return v end
end

function wrap(v, lo, hi)
	local diff = hi - lo
	while v >= hi do
		v = v - diff
	end
	return v
end

function wrap0(v, hi)
	while v >= hi do
		v = v - hi
	end

	return v
end