class Award
    attr_reader :name
    attr_accessor :expires_in, :quality

    # Set max and min as class constants no need to initalize for every instance
    MAX_QUALITY = 50
    MIN_QUALITY = 0

    def initialize(name, initial_expires_in, initial_quality)
        @name, @expires_in = name, initial_expires_in
        @quality = self.validate_quality(initial_quality)
    end

    def validate_quality(quality)
        return @quality = MIN_QUALITY if quality < MIN_QUALITY
        return @quality = MAX_QUALITY if quality > MAX_QUALITY
        @quality = quality
    end

    def update_quality
        @quality -= expired?() || day_of_expiration?() ? 2 : 1
        @quality = 0 if quality_below_zero?()
        update_expiration()
    end

    # helper methods
    def update_expiration
        @expires_in -= 1
    end

    def day_of_expiration?
        @expires_in == 0
    end

    def expired?
        @expires_in < 0
    end

    def quality_below_zero?
        @quality < MIN_QUALITY
    end

    def maxed?
        @quality >= MAX_QUALITY
    end
end

class BlueFirst < Award
    def update_quality
        # quality is under 50(MAX) 
        unless maxed?()
            # if expired +2 else +1
            @quality += expired?() || day_of_expiration?() ? 2 : 1
        end
        
        # set to 50(MAX) if quality >= 50
        @quality = MAX_QUALITY if maxed?()
        update_expiration()
    end
end

class BlueDistinctionPlus < Award
    INITIAL_VALUE = 80

    def initialize(name, initial_expires_in, initial_quality)
        super(name, initial_expires_in, INITIAL_VALUE)
    end

    # override method to set quality to initial qualtiy of 80 
    def validate_quality(quality)
        @quality = INITIAL_VALUE
    end

    # override method to do not update quality
    def update_quality
        return
    end
end

class BlueCompare < Award
    def update_quality
        @quality += 1 if @expires_in > 10
        @quality += 2 if @expires_in.between?(6,10)
        @quality += 3 if @expires_in.between?(0,5)

        @quality = MAX_QUALITY if maxed?()
        @quality = 0 if expired?()
        update_expiration()
    end
end