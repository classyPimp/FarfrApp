class AttachmentsController < ApplicationController

SEND_FILE_METHOD = :default

  def download
    
    search_id = params[:id1] + params[:id2] + params[:id3] 
    head(:not_found) and return if (attachment = Attachment.find(search_id.to_i)).nil?
    begin
    path = attachment.document.path(params[:style])
    rescue
      path = attachment.attachment.path(params[:style])
    end


    head(:bad_request) and return unless File.exist?(path) && params[:format].to_s == File.extname(path).gsub(/^\.+/, '')

    begin
    send_file_options = { :type => attachment.document.content_type }
    rescue
      send_file_options = {type: attachment.attachment.content_type}      
    end

    case SEND_FILE_METHOD
      when :apache then send_file_options[:x_sendfile] = true
      when :nginx then head(:x_accel_redirect => path.gsub(Rails.root, ''), :content_type => send_file_options[:type]) and return
    end

    send_file(path, send_file_options)
    #taken from:
    #http://thewebfellas.com/blog/2009/8/29/protecting-your-paperclip-downloads
  end

end
