require 'json'

module Idobata
	class ZoiChanBot < Bot

		def name
			"zoi-chan"
		end
		
		def on_message(message)
		end

		def on_myself_message(message)
			to_body_plain = message.to_body_plain()
			if /今日も一日/ =~ to_body_plain
				to_say( message.room_id, message.sender_name, "がんばるぞい!" )
			elsif /おはよう$/ =~ to_body_plain || /おはー$/ =~ to_body_plain || /おは$/ =~ to_body_plain
				to_say( message.room_id, message.sender_name, "おはようございます！ 今日も一日がんばるぞい！");
			elsif /こんにちは$/ =~ to_body_plain || /こにちはー$/ =~ to_body_plain || /こん$/ =~ to_body_plain
				to_say( message.room_id, message.sender_name, "こんにちは！ 午後もがんばってください！")
			elsif /こんばんは$/ =~ to_body_plain || /ばんー$/ =~ to_body_plain || /ばん$/ =~ to_body_plain
				to_say( message.room_id, message.sender_name, "こんばんは！ 無理をしすぎないようにしてください！")
			elsif /(.*)[？|?|！|!]/ =~ to_body_plain 
				question = $1
				if /(.*)って何$/ =~ question || /(.*)って$/ =~ question
					question = $1
				end
				if /(.*)みせてー$/ =~ question || /(.*)みせて$/ =~ question || /(.*)見せて$/ =~ question || /(.*)見せてー$/ =~ question
					question = $1
				end
				if /(.*)について/ =~ question
					question = $1
				end
				url = get_image_url(question)
				if !url.nil?
					to_say( message.room_id, message.sender_name, question + " ! " + url)
				else
					to_say( message.room_id, message.sender_name, "ごめんなさい. わからないです・・。")
				end
			elsif /LGTM/ =~ to_body_plain || /lgtm/ =~ to_body_plain
				url = get_lgtm_url()
				to_say( message.room_id, message.sender_name, "LGTM！ " + url )
			end
		end

		def get_image_url(search)
			params = URI.encode("q=#{search}");
			response = Net::HTTP.get(
				'api.tiqav.com',
				'/search.json?'+params
			)
			responseJsons = JSON.parse(response)
			if responseJsons.nil?
				return nil
			end
			random_index = rand(responseJsons.length)
			if responseJsons[random_index]["id"].nil?
				return nil
			end
			"http://tiqav.com/"+responseJsons[random_index]["id"]+"."+responseJsons[random_index]["ext"]
		end

		def get_lgtm_url()
			response = Net::HTTP.get('www.lgtm.in','/g').force_encoding('utf-8')
			/value="(.*)" class="form-control" id="imageUrl"/ =~ response
			$1
		end
	end
end
