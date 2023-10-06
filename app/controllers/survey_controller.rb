class SurveyController < ApplicationController
	helper_method :get_surveys, :create_survey

	def index
		@page_title = "Trial Balloons"
	end
	
	# calls on pol.is servers for a pre-filtered list.
	# survey sorting is done on their side.
	# @admin and context are what is important in the filtering 
	# on the pol.is side of things.
	# 

	def get_surveys
		require 'net/http'
		require 'uri'
		require 'json'

		@uri = URI.parse('https://api.pol.is/api/v3/conversations')
		
		@http = Net::HTTP.new(@uri.host, @uri.port)
		@http.use_ssl = true

		survey_filter = @current_chamber.id.to_s
		survey_filter += '1116'
		if @current_chamber_role.is_administrator?
			survey_filter += '&want_mod_url=true'
			
		end
		
		
		
		@request = Net::HTTP::Get.new('/api/v3/conversations?context='+ survey_filter , {'Content-Type' =>'application/json'})
		
		@request.basic_auth 'pkey_8he2JjNb6Cz3uEq131fjNk3e8e2', '' #Need to pull this out and add as a global variable


		response = @http.request(@request)

		puts "Response #{response.code} #{response.message}: #{response.body}"
		return JSON.parse(response.body)
	end


	# creates the call to the pol.is servers for a new survey.
	# needs the api key and it needs to be pointed to the right pol.is service
	# the data block is manipulated here in the send.
	#  

	def create
		require 'net/http'
		require 'uri'
		require 'json'


		@uri = URI.parse('https://api.pol.is/api/v3/conversations')

		@http = Net::HTTP.new(@uri.host, @uri.port)
		@http.use_ssl = true
		@topic = params[:topic]
		@context_dif = params[:group_id]
		@description = params[:description]
		@request = Net::HTTP::Post.new(@uri.path, {'Content-Type' =>'application/json'})

		@request.basic_auth 'pkey_8he2JjNb6Cz3uEq131fjNk3e8e2', ''
		context = @current_chamber.id.to_s
		context += @current_chamber.floor.id.to_s
		@data = {
	    	'topic' => @topic,
	    	'description' => @description,
	    	'context' => context,
	    	'is_public' => false,
	    	'strict_moderation' => false,
		}.to_json

		
		@request.body = @data
		response = @http.request(@request)

		puts "Response #{response.code} #{response.message}: #{response.body}"
		redirect_to(survey_path)
		return response.code + response.body
	end

end