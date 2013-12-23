 module BeanCounter

   module Logging

     LOG_PREFIX = "BeanCounter: "

     extend self

     def logger
       @logger ||= new_logger
     end

     def logger=(logger)
       @logger = logger
     end

     def debug(message)
       logger.debug("#{LOG_PREFIX}#{message}")
     end

     def info(message)
       logger.info("#{LOG_PREFIX}#{message}")
     end

     def warn(message)
       logger.warn("#{LOG_PREFIX}#{message}")
     end

     def error(message)
       logger.error("#{LOG_PREFIX}#{message}")
     end

     def fatal(message)
       logger.fatal("#{LOG_PREFIX}#{message}")
     end

     private

     def new_logger
       arguments =  [Config.log_path]
       arguments << Config.log_count if Config.log_count
       arguments << Config.log_size  if Config.log_size
       ::Logger.new(*arguments)
     end

   end

 end
