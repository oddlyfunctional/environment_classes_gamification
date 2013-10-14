class CityWrapper
  ATTRIBUTES = [:pollution, :public_support, :corporate_support, :health, :satisfaction, :population, :balance]
  attr_writer  *ATTRIBUTES
  attr_accessor :delta_pollution, :delta_public_support, :delta_corporate_support, :delta_balance

  def initialize(attributes)
    attributes.each {|attr, value| send("#{attr}=", value.to_f)}
  end

  ATTRIBUTES.each do |attr|
    define_method attr do
      apply(attr)
    end
  end

  def apply(attribute)
    functions = {
      pollution: ->{ (1 + delta_pollution/100) * @pollution },
      public_support: ->{ (1 + delta_public_support/100) * @public_support },
      corporate_support: ->{ (1 + delta_corporate_support/100) * @corporate_support },
      health: ->{ (1 - pollution/100) * @health },
      satisfaction: ->{ (1 + (public_support - pollution)/10) * @satisfaction },
      population: ->{ (1 + (5 + health)/100) * @population },
      balance: ->{ (1 + (population + satisfaction)/200) * @balance + delta_balance }
    }

    functions[attribute].call
  end
end