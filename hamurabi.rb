class Hamurabi

	def play
		
		loop do
			game = Game.new()

			begin
				turn game
			end	while game.year <= 10 

			break if !restart
		end	
	end

	def restart
		puts "Shall we play again?"
    	answer = gets.downcase
    	answer.include? "y"
	end

	def reportStatus game
		puts "Hammurabi: I beg to report to you,"
		puts "In Year #{game.year}, #{game.starvation_losses} people starved."
		puts "#{game.population_growth} people came to the city."
		puts "The city population is now #{game.population}."
		puts "The city now owns #{game.land} acres."
		puts "You harvested #{game.productivity} bushels per acre."
		puts "Rats ate #{game.bushel_loss} bushels."
		puts "You now have #{game.bushels} bushels in store."
		puts "Land is trading at #{game.land_cost} per acre."
	end

	def turn game
		reportStatus game

		turn = Turn.new

		ask_turn_questions turn
		
		#Validate total bushels doesn't exceed available
		turn_bushels = (turn.acres_purchased * game.land_cost) + turn.food_bushels + (turn.acres_seeded * 10)

		if(turn_bushels > game.bushels)
			puts "You don't have enough bushels to do all that!"
			ask_turn_questions turn
		end

		# Buy Land
		purchase_cost =  turn.acres_purchased * game.land_cost
		game.bushels -= purchase_cost
		game.land += turn.acres_purchased

		# Feed the People
		per_person_feed_rate = 20
		people_fed = turn.food_bushels / 20
		game.bushels -= turn.food_bushels

		if(people_fed < game.population) 
			starved_people = game.population - people_fed
			game.population -= starved_people
		end
		


		# Seed 
		per_acre_seed_rate = 1
		seed_used = turn.acres_seeded * per_acre_seed_rate
		game.bushels -= seed_used

		# Harvest
		game.productivity = farmProductivityRate
		harvested_bushels = turn.acres_seeded * game.productivity
		game.bushels += harvested_bushels

		# Food Lost
		game.bushel_loss = food_loss_in_bushels
		game.bushels -= game.bushel_loss

		# Population Growth
		game.population_growth = population_growth_in_people
		game.population += game.population_growth
		
		# Land Cost
		game.land_cost = land_cost_in_bushels game

		game.year += 1 unless game.year == 11
		
	end

	def ask_turn_questions turn
		puts "How many acres do you wish to buy or sell?"
		turn.acres_purchased = gets.to_i

		puts "How many bushels do you wish to feed your people?"
		turn.food_bushels = gets.to_i

		puts "How many acres do you wish to plant with seed?"
		turn.acres_seeded = gets.to_i
	end

	def farmProductivityRate
		1+rand(5)
	end

	def food_loss_in_bushels
		1+rand(6) * 10
	end

	def population_growth_in_people
		1+rand(24)
	end

	def land_cost_in_bushels game
		if game.population > 100
			game.land_cost += 2
		else
			game.land_cost -= 1
		end
	end

end

class Turn
	attr_accessor :acres_purchased, :food_bushels, :acres_seeded 
end


class Game
	attr_accessor :year, :population_growth, :population, :land,:starvation_losses, :land_cost, :bushels, :productivity, :bushel_loss

	def initialize 
		@year = 1
		@population_growth = 5
		@starvation_losses = 0
		@population = 100
		@land = 1000
		@land_cost = 20
		@productivity = 3
		@bushel_loss = 200
		@bushels = 2800
	end

end
