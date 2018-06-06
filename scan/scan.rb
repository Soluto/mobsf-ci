require 'net/http'
require 'multipart_body'
require 'uri'
require 'json'

mobsf_url = ENV["MOBSF_URL"]
target = ENV["TARGET_PATH"]

puts "Starting to scan \"#{target}\""

begin 
  uri = URI.parse("#{mobsf_url}api/v1/upload")
  request = Net::HTTP::Post.new(uri)
  request["Authorization"] = "12345"

  file_part = ""
  File.open(target, 'rb') do |f|
    file_part = Part.new :name => 'file',
                :body => f,
                :filename => target,
                :content_type => 'application/octet-stream'
  end

  boundary = "---------------------------#{rand(10000000000000000000)}"
  body = MultipartBody.new [file_part], boundary

  request.body = body.to_s
  request["Content-Type"] = "multipart/form-data; boundary=#{boundary}"

  response = Net::HTTP.start(uri.hostname, uri.port) do |http|
    http.request(request)
  end

  if (response.code.to_i > 299)
    p "MobSF reques failed for unknown reason, status code: #{response.code}, body: #{response.body}"
    exit 1
  end

  puts "File uploaded, requesting a scan"

  scan_details = JSON.parse(response.body)

  uri = URI.parse("#{mobsf_url}api/v1/scan")
  request = Net::HTTP::Post.new(uri)
  request["Authorization"] = "12345"
  request.set_form_data(
    "file_name" => scan_details["file_name"],
    "hash" => scan_details["hash"],
    "scan_type" => scan_details["scan_type"],
  )

  response2 = Net::HTTP.start(uri.hostname, uri.port, :read_timeout => 600) do |http|
    http.request(request)
  end

  if (response.code.to_i > 299)
    p "MobSF reques failed for unknown reason, status code: #{response.code}, body: #{response.body}"
    exit 1
  end

rescue SocketError => e
  puts "MobSF request failed due to network error: #{e}"
  exit 1
rescue Exception => e  
  puts "MobSF request failed due to unknwon error #{e}"
  exit 1
end

open('output/report.json', 'w') { |f|
  f.puts response2.body
}

puts "Scan completed, report saved"