module SlashDoto
  class Command
    VALID_COMMANDS = %w{
      player
    }.freeze

    def initialize text
      unless text.nil?
        @text = text.split(/\s+/)
        @command = @text.first
        @parameter = @text[1]
      end
    end

    def execute
    end

    def valid?
      VALID_COMMANDS.include?(@command) && !@parameter.nil?
    end
  end
end
