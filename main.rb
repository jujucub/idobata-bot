require "logger"
require "./idobata/idobata.rb"
require "./zoi-chan-bot.rb"

logger = Logger.new(ENV["IDOBATA_LOG"],7)
logger.level = Logger::ERROR;

Idobata.logger = logger;
zoichan = Idobata::ZoiChanBot.new()
zoichan.run()
