
#encoding: utf-8  
# ##贝格尔编排法
# 贝格尔编排法 从1985年起，世界性排球比赛多采用“贝格尔”编排法。
# 其优点是单数队参加时可避免第二轮的轮空队从第四轮起每场都与前一轮的轮空队比赛的不合理现象。

# 方法
# 采用“贝格尔”编排法，编排时如果参赛队为双数时，把参赛队数分一半(参赛队为单数时，最后以“0”表示形成双数)，
# 前一半由1号开始，自上而下写在左边；后一半的数自下而上写在右边，然后用横线把相对的号数连接起来。
# 这即是第一轮的比赛。
# 第二轮将第一轮右上角的编号(“0”或最大的一个代号数)左角上，第三轮又移到右角上，以此类推。
# 即单数轮次时“0”或最大的一个代号在右上角，双数轮次时则在左上角。如下：

# 7个队比赛的编排方法
# 第一轮 第二轮 第三轮 第四轮 第五轮 第六轮 第七轮
# 1－0   0－5  2－0  0－6   3－0  0－7   4－0
# 2－7   6－4  3－1  7－5   4－2  1－6   5－3
# 3－6   7－3  4－7  1－4   5－1  2－5   6－2
# 4－5   1－2  5－6  2－3   6－7  3－4   7－1
# 无论比赛队是单数还是双数，最后一轮时，必定是“0”或最大的一个代号在右上角，“1”在右下角。
# 根据参赛队的除数不同，“1”朝逆时针方向移动一个位置时，应按规定的间隔数移动（见表2）“0”或最大　代号数应先于“1”移动位置。

# 比赛轮数：在循环制的比赛中，各队都参加完一场比赛即为一轮。
# 参加比赛的队数为单数时，比赛轮数等于队数。参加比赛的队数为双数时，比赛轮数等于队数减一。

class Game
	#编排比赛
	def self.arrange_rounds(team_count)
		team_count = team_count+1 if team_count % 2 == 1
		result = []
		#比赛轮数
		round_count = team_count % 2 == 1 ? team_count : team_count -1
		#第一轮比赛，默认顺序
		round = (1..team_count).to_a
		result << round
		2.upto(round_count).each do |i|
			round = next_round(round,i)
			result << round	
		end
		result
	end

	#显示对阵图
	
	def self.display(rounds,rand_teams)
		rounds.each_with_index do |round, index|
			groups = []
			1.upto(round.size/2) do |i|
				puts rand_teams[round[i-1]-1] + " vs " + rand_teams[round[round.size-i]-1]
			end
		end
	end

	# 下一轮比赛, 将下一轮分为四个部分，头部，尾部，中间两部分;
	# 首先定位头部，尾部，然后按照顺时针方向放入剩下的元素
	# 变换图如下
	# [1 2 3 4 5 6 7 8]
	# [8			    5]
	# [8] [6 7] [1 2 3 4] [5]
	# [8 6 7 1 2 3 4 5]
	def self.next_round(round, round_num=1)
		tmp = (1..(round.size-1)).to_a
		if round_num % 2 == 1
			foot = round[0]
			middle = round[round.size/2]
			header = [middle]
			footer = [foot]
		else
			foot = round[round.size/2]
			middle = foot
			header = [round[-1]]
			footer = [foot]
		end
		higher = tmp.select{|x| x > middle}
		lower = tmp.select{|x| x < middle}
		header + higher + lower + footer
	end

end

#测试
teams = ["澳大利亚", "韩国", "阿曼", "科威特"]
rand_teams = teams.sample(teams.size)
rounds = Game.arrange_rounds(rand_teams.size)
puts rounds.to_s
Game.display(rounds,rand_teams)

# 第1轮
# 1 - 8 , 2 - 7 , 3 - 6 , 4 - 5
# 第2轮
# 8 - 5 , 6 - 4 , 7 - 3 , 1 - 2
# 第3轮
# 2 - 8 , 3 - 1 , 4 - 7 , 5 - 6
# 第4轮
# 8 - 6 , 7 - 5 , 1 - 4 , 2 - 3
# 第5轮
# 3 - 8 , 4 - 2 , 5 - 1 , 6 - 7
# 第6轮
# 8 - 7 , 1 - 6 , 2 - 5 , 3 - 4
# 第7轮
# 4 - 8 , 5 - 3 , 6 - 2 , 7 - 1

