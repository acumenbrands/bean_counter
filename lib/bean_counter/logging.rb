 module BeanCounter

   module Logging

     extend self

     def logger
       @logger ||= new_logger
     end

     def logger=(logger)
       @logger = logger
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
