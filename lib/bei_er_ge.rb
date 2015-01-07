
class Game
	def self.sort(n)
		n = n+1 if n % 2 == 1
		array = []
		# 比赛场数= 队数*(队数-1)/2
		games_count = n*(n-1)/2
		round_count = n % 2 == 1 ? n : n -1
		x_init = (0..round_count).to_a
		0.upto(round_count-1).each do |i|
			x = [0]*n
			x[0] = x_init[0]
			array << x	
		end
		array
	end

	def self.map(arry)

	end
end

puts Game.sort(8).inspect
puts Game.sort(8).size