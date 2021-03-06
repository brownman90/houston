class OneOrMany
  
  def initialize(one_or_many)
    @one_or_many = one_or_many
  end
  
  def map(&block)
    if @one_or_many.respond_to?(:map)
      @one_or_many.map(&block)
    else
      yield @one_or_many
    end
  end
  
end
